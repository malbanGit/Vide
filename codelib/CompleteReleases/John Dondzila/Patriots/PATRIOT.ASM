WAITRCL EQU     $F192           ;WAIT FOR T2 TIMEOUT, RECALIBRATE
BPNT    EQU     $CA00
DPTOD0  EQU     $F1AA           ;SET DP TO D0 (I/O)
DPTOC8  EQU     $F1AF           ;SET DP TO C8 (RAM)
SWITCHS EQU     $F1B4           ;READ SWITCHES
JOYSTK  EQU     $F1F8           ;READ JOYSTICK
ZAXTO7F EQU     $F2A9           ;SET Z AXIS INTENSITY TO 7F
ZAXTOA  EQU     $F2AB           ;SET Z AXIS INTENSITY TO A
MVD85   EQU     $F30C           ;MOVE DOT WITH MEDIUM INTEGRATION
RES0RF  EQU     $F354           ;RESET ZERO REFERENCE
DRWL1B  EQU     $F40E           ;DRAW LINE, MAG IN B
UFO     EQU     $C93B           ;UFO POINTER
SW11    EQU     $C812           ;SWITCH 1, CONSOLE 1
SW12    EQU     $C813           ;   "   2,    "    1
SW13    EQU     $C814           ;   "   3,    "    1
SW14    EQU     $C815           ;   "   4,    "    1
JOYVLS  EQU     $C81B           ;JOYSTICK VALUES (4 BYTES)
JOYENS  EQU     $C81F           ;JOYSTICK ENABLES (4 BYTES)
JOYTYP  EQU     $C823           ;JOYSTICK CONVERSION TYPE

        ORG     0
        db     'g GCE 0000',$80
        FDB     MUSIC
        FCB     $F8,$50,$20,$C8
        db     'PATRIOTS',$80
        FCB     $FA,$43,$00,$AA
        db     'SERIAL NUMBER 0000',$80
        FCB     $FC,$14,$7F,$EA
        db     'HIGH SCORE',$80,0
*----------------------------------------------------------------------------
BEGIN   LDA     #$80
        STA     $C957
        LDA     #$00
        STA     $C958
        JMP     HEADER

NEWGAME LDD     #$0000
        STD     $C8D0           ;LEVEL
        STD     $C8B0           ;PLAYER SCORE
        LDX     #$C8B0
        JSR     $F84F           ;INIT PLAYER SCORE
        LDX     #$C8D0
        JSR     $F84F           ;INIT LEVEL COUNTER TO 1
        LDD     #$0001
        LDX     #$C8D0
        JSR     $F87C

        LDA     #$01
        STA     $CAE7           ;INIT LEVEL TO 1
        LDA     #$31
        STA     $C950           ;BONUS CITY FLAG

        LDD     #$3075
        STD     $C83D           ;SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        STD     $8              ;START T2

        JSR     CLRMEM

        LDA     #$2F
        STA     $CAE6

        LDA     #$15            ;MISSILE SPEED
        STA     $C907           ;(DECREASE VALUE AS LEVELS INCREASE)

        LDY     #$00            ;NEW GAME STARTS HERE
        LDB     #$28
NEWGAM1 LDA     #$01            ;THIS ROUTINE SETS UP THE CITY INFO
        STA     $CABB,Y
        LDA     #$12
        STA     $CABC,Y
        STB     $CABD,Y
        ADCB    #$22
        LEAY    3,Y
        CMPY    #$12
        BMI     NEWGAM1

        LDA     #$14
        STA     $C910           ;MISSILES TO HIT B4 END OF LEVEL

        JSR     >JOYSET         ;SET UP FOR JOYSTICK

        LDA     #$00
        STA     $C94F           ;SMART BOMB LAUNCH

        LDB     #$04
        JSR     $F7A9           ;GET GAME SITE SPEED
        LDA     $C87A
        ADDA    #$02
        STA     $C93D

NEWLEV  LDA     #$7F
        STA     $C900           ;SITE Y COORD
        LDA     #$7F
        STA     $C901           ;SITE X COORD

        JSR     ALLMIS          ;SET UP ALL MISSILES

        LDA     $C907           ;COUNTER
        STA     $C906           ;REFRESH VALUE

        LDA     #$90
        STA     $CAB8
        LDA     #$80
        STA     $CAB9
        LDA     #$18            ;STORE LAUNCHER COORDS
        STA     $CACD
        STA     $CACF
        LDA     #$00
        STA     $CACE
        LDA     #$FF
        STA     $CAD0
        LDA     #$01
        STA     $CAE8           ;LEVEL DELAY
        STA     $C934
        STA     $CAAF
        STA     $CAB0
        LDA     $C910
        STA     $C917
        LDA     $C917
        LSRA
        ADDA    #$15
        STA     $C911           ;LEFT MISSILES
        STA     $C912           ;RIGHT MISSILES
        LDA     #$80
        STA     $C913
        STA     $C915
        LDA     #$80
        STA     $C914
        LDA     #$7F
        STA     $C916
        LDA     #$00
        STA     $C856
        STA     $C91A           ;NEXT LEVEL FLAG
        STA     $C918           ;BONUS OFF
        STA     $C91B           ;CITY COUNTER ON BONUS LEVEL
        STA     $C922           ;END OF BONUS SCREEN FLAG
        STA     $C939           ;SET SAUCER/PLANE FLAGS
        STA     $C93A           ;TO ZERO
        STA     $C934
        STA     $C941
        STA     $C942
        STA     $C943
        STA     $C944
        STA     $C949
        STA     $C929           ;RESET SMART BOMB 1
        STA     $C92E           ;RESET SMART BOMB 2
        STA     $C933           ;RESET SMART BOMB 3
        LDA     #$10
        STA     $C919           ;SHORT DELAY COUNTER

ERST    LDY     #$00
        LDA     #$00
ERST1   STA     $CA0C,Y         ;RESET EXPLOSIONS
        STA     $CA0D,Y
        LEAY    4,Y
        CMPY    #$50
        BNE     ERST1

MRST    LDA     #$00
        LDY     #$00
MRST1   STA     $CA5B
        LEAY    7,Y
        CMPY    #$54
        BMI     MRST1

        LDY     #$00
        STY     $C91B
CRST    LDA     $CABB,Y         ;RESTORE CITIES
        CMPA    #$02
        BNE     CRST1
        LDA     #$01
        STA     $CABB,Y
CRST1   LEAY    3,Y
        CMPY    #$12
        BMI     CRST

        LDA     #$7F
        STA     $C920
        STA     $C923
        STA     $C924
        LDA     $C8B1           ;SET FREE CITY STUFF
        STA     $C950
        JSR     FREECHK         ;CHECK TO SEE IF BONUS CITY IS AWARDED
        LDA     $C953
        CMPA    #$00
        BEQ     CHGO
        JSR     ELOOP

CHGO    LDA     #$00
        ADDA    $CABB
        ADDA    $CABE
        ADDA    $CAC1
        ADDA    $CAC4
        ADDA    $CAC7
        ADDA    $CACA
        CMPA    #$00
        BNE     MPLAY
        JMP     GO

MPLAY   LDU     #MUSIC1         ;NEW LEVEL MUSIC
        JSR     PON
*----------------------------------------------------------------------------
LOOP    JSR     DPTOC8
        LDA     $C921
        CMPA    #$01
        BNE     LOOPA
        JMP     GO              ;JUMP TO GAME OVER
LOOPA   LDA     $C91A
        CMPA    #$01
        BNE     LOOP0
        JMP     EOL
LOOP0   LDU     $C91D           ;SOUND POINTER
        JSR     $F687
        JSR     WAITRCL         ;NICE AND STRUCTURED FOR THIS GAME ! <--+
        JSR     $F289           ;SOUND ROUTINE                          |
        JSR     CITIES          ;DRAW THE CITIES                        |
        JSR     LAUNCH1         ;DRAW THE LAUNCHERS                     |
        JSR     SHOWSCR         ;SHOW SCORE                             |
        JMP     CHKPAUS         ;CHECK PAUSE SWITCH                     |
PRESUME LDA     $C949
        CMPA    #$01
        BNE     LOOP2
        JSR     ZAXTO7F
        LDU     #PAWS
        LDD     #$FC24
        STD     $C82A
        LDA     #$30
        LDB     #$E4
        JSR     $F37A
        JMP     LOOP
LOOP2   JSR     INC934          ;RANDOM NUMBER GENERATOR #1             |
        LDA     $C918           ;                                       |
        CMPA    #$00            ;                                       |
        BEQ     LOOP1           ;                                       |
        JSR     ADDBON          ;ADD BONUS POINTS AT END OF LEVEL       |
        JMP     LOOP            ;                                       |
LOOP1   JSR     DRWSPRT         ;DRAW SPRITES                           |
        JSR     NUKE            ;DRAW ANY EXPLODING CITIES
        JSR     MOVEPL          ;PLAYER MOVEMENT ROUTINES               |
        JSR     CHKFIRE         ;PATRIOT FIRING ROUTINES                |
        JSR     EXPROUT         ;EXPLOSION ROUTINES                     |
        JSR     SMART           ;SMART BOMB ROUTINES                    |
        JSR     CHKSMRT         ;MORE SMART BOMB ROUTINES
        LDA     $CAE8
        CMPA    #$00
        BEQ     CLOOP
        INC     $CAE8
        JSR     SHOWLEV
        JMP     LOOP
CLOOP   JSR     EMISSIL         ;ENEMY MISSILE ROUTINES                 |
        JSR     TARG
CHK4END LDA     $C939
        CMPA    #$01
        BPL     CHKEND
        LDA     $C96B
        CMPA    #$00
        BNE     CHKEND
        LDY     #$00
CHK4EN0 LDA     $CA0C,Y
        CMPA    #$00
        BNE     CHKEND
        LEAY    4,Y
        CMPY    #$50
        BMI     CHK4EN0
        LDA     $C929
        CMPA    #$00
        BNE     CHKEND
        LDA     $C92E
        CMPA    #$00
        BNE     CHKEND
        LDA     $C933
        CMPA    #$00
        BNE     CHKEND
        LDY     #$00            ;CHECK FOR END OF LEVEL
        LDB     #$00
CHK4EN2 LDA     $C980,Y
        CMPA    #$00
        BEQ     CHKFIX1
        INCB
CHKFIX1 LEAY    8,Y
        CMPY    #$80
        BNE     CHK4EN2
        CMPB    #$00
        BEQ     CHK4EN3
        JMP     LOOP
CHK4EN3 LDA     #$01
        STA     $C918
CHKEND  INC     $C96C
        INC     $C96C
        INC     $C96C
        INC     $C96C
        JMP     LOOP
*----------------------------------------------------------------------------
ADDBON  LDA     $C922
        CMPA    #$00
        BEQ     ADDBON0
        JMP     ADDBONA
ADDBON0 LDA     $C911           ;ROUTINE TO ADD BONUS POINTS
        CMPA    #$00            ;FOR LEFT REMAINING MISSILES
        BEQ     ADDBON1
        DEC     $C919
        LDA     $C919
        CMPA    #$00
        BNE     ADDBON2
        DEC     $C911
        LDA     #$05
        STA     $C919
        LDD     #$0005
        JSR     ADD2SC
        LDU     #MUSI
        JSR     PON
        RTS
ADDBON1 LDA     $C912           ;ROUTINE TO ADD BONUS POINTS
        CMPA    #$00            ;FOR RIGHT REMAINING MISSILES
        BEQ     ADDBON3
        DEC     $C919
        LDA     $C919
        CMPA    #$00
        BNE     ADDBON2
        DEC     $C912
        LDA     #$05
        STA     $C919
        LDD     #$0005
        JSR     ADD2SC
        LDU     #MUSI
        JSR     PON
ADDBON2 RTS
ADDBON3 LDA     #$00
        ADDA    $CABB
        ADDA    $CABE
        ADDA    $CAC1
        ADDA    $CAC4
        ADDA    $CAC7
        ADDA    $CACA
        CMPA    #$00
        BNE     ADDBON4                 ;CHECK INDIVIDUAL CITIES
        LDA     #$01
        STA     $C91A                   ;NEXT LEVEL FLAG
ADDBONR RTS
ADDBON4 DEC     $C919
        LDA     $C919
        CMPA    #$00
        BEQ     ADDBON5
        RTS
ADDBON5 LDA     #$10
        STA     $C919
        LDY     $C91B
        LDA     $CABB,Y                 ;CHECK INDIVIDUAL CITIES
        CMPA    #$00
        BEQ     ADDBON9
        LDA     #$02
        STA     $CABB,Y
        LDD     #$0050
        PSHS    Y
        JSR     ADD2SC
        LDU     #MUSI
        JSR     PON
        PULS    Y
ADDBON6 LEAY    3,Y
        STY     $C91B
        CMPY    #$12
        BMI     ADDBON7
        JMP     ADDBON8
ADDBON7 RTS
ADDBON8 LDA     #$7F
        STA     $C922                   ;END OF BONUS SCREEN FLAG
        RTS
ADDBON9 LDA     #$01
        STA     $C919
        JMP     ADDBON6
ADDBONA DEC     $C922
        LDA     $C922
        CMPA    #$00
        BNE     ADDBONB
        LDA     #$01
        STA     $C91A                   ;NEXT LEVEL FLAG
ADDBONB RTS
*----------------------------------------------------------------------------
EOL     LDD     #$0001          ;END OF LEVEL ROUTINE
        LDX     #$C8D0
        JSR     $F87C
        LDA     $CAE7
        CMPA    #$12
        BPL     EOL2
        INC     $CAE7           ;INCREASE LEVEL
        LDA     #$06
        ADDA    $C910
        STA     $C910
        LDA     $C907
        CMPA    #$03
        BEQ     EOL1
        DEC     $C907
        DEC     $C907
        DEC     $C907
EOL1    LDA     $C94F
        CMPA    #$60
        BPL     EOL2
        LDA     #$0A
        ADDA    $C94F
        STA     $C94F
EOL2    JMP     NEWLEV
*----------------------------------------------------------------------------
LAUNCH1 LDA     $C923
        CMPA    #$00
        BNE     LAUNCHL
        JMP     RLN1
LAUNCHL CMPA    #$7F
        BEQ     LAUNCL1
        DEC     $C923
LAUNCL1 LDA     $C923
        JSR     ZAXTOA
        LDX     #LAUNCH
        LDU     #$CAD1
        LDA     $C900
        LSRA
        LSRA
        LSRA
        LSRA
        SBCA    #$20
        NEGA
        LDB     $C923
        CMPB    #$7F
        BEQ     LLLL
        LDA     $C96C
LLLL    JSR     $F61F
        LDD     $CACD
        STD     $C902
        JSR     SETPEN
        LDB     #$30
        LDX     #$CAD1
        JSR     DRWL1B
        JSR     RES0RF
RLN1    LDA     $C924
        CMPA    #$00
        BNE     RLN2
        JMP     BOUTIME
RLN2    CMPA    #$7F
        BEQ     RLN3
        DEC     $C924
RLN3    LDA     $C924
        JSR     ZAXTOA
        LDX     #LAUNCH
        LDU     #$CAD1
        LDA     $C900
        LSRA
        LSRA
        LSRA
        LSRA
        SBCA    #$20
        LDB     $C924
        CMPB    #$7F
        BEQ     RRRR
        LDA     $C96C
RRRR    JSR     $F61F
        LDD     $CACF
        STD     $C902
        JSR     SETPEN
        LDB     #$30
        LDX     #$CAD1
        JSR     DRWL1B
        JSR     RES0RF
BOUTIME LDA     #$00
        STA     $C823
        LDA     $C911
        CMPA    #$00
        BEQ     SKIPL
        JSR     DPTOD0
        JSR     ZAXTO7F
        LDX     #$C913
        JSR     MVD85
        LDA     #$00
        LDB     $C911
        JSR     $F3DF
        JSR     RES0RF
SKIPL   LDA     #$00
        STA     $C823
        LDA     $C912
        CMPA    #$00
        BEQ     SKIPR
        JSR     ZAXTO7F
        LDX     #$C915
        JSR     MVD85
        LDA     #$00
        LDB     $C912
        NEGB
        JSR     $F3DF
        JSR     RES0RF
SKIPR   RTS
*----------------------------------------------------------------------------
CITIES  LDA     #$50
        JSR     ZAXTOA
        LDX     #$CAB8          ;DRAW BOTTOM OF SCREEN
        JSR     MVD85
        LDD     #$007F
        JSR     $F3DF
        LDD     #$007F
        JSR     $F3DF
        JSR     RES0RF
        LDY     #$00
CITIES1 LDA     $CABB,Y
        CMPA    #$01
        BEQ     CITIES3
CITIES2 LEAY    3,Y
        CMPY    #$12
        BMI     CITIES1
        RTS
CITIES3 PSHS    Y
        LDA     #$5F
        JSR     ZAXTOA
        LDD     $CABC,Y
        STD     $C902
        JSR     SETPEN
        LDB     #$2F
        LDX     #CITY
        JSR     DRWL1B
        JSR     RES0RF
        PULS    Y
        JMP     CITIES2
*----------------------------------------------------------------------------
EMISSIL LDY     #$00
EMISSI1 LDA     $C980,Y         ;CHECK IF MISSILE SHOULD BE DRAWN
        CMPA    #$01
        BEQ     EMISSI3
        CMPA    #$00
        BEQ     EMISSI2
EMISSI2 LEAY    8,Y
        CMPY    #$80
        BNE     EMISSI1         ;MORE MISSILES TO CHECK
        JMP     MISMOVE
EMISSI3 LDA     #$00
        STA     $C823           ;SET THIS TO ZERO, I DON'T KNOW WHY
        LDD     $C982,Y
        NEGA
        STD     $C902
        PSHS    Y
        JSR     SETPEN
        PULS    Y

        LDX     #FAKE
        JSR     $F404
        LDA     $C981,Y         ;MISSILE INTENSITY
        PSHS    Y
        JSR     ZAXTOA
        PULS    Y
        LDD     $C984,Y
        PSHS    Y
        JSR     $F3DF           ;DRAW THE LINE
        LDA     #$BF
        STA     $C828
        JSR     $F2C5           ;DRAW THE DOT AT THE END OF THE LINE
        JSR     RES0RF

        PULS    Y
        LDA     $C981,Y
        CMPA    #$4F
        BEQ     MRTS
        DEC     $C981,Y         ;DECREASE MISSILE BRIGHTNESS UNTIL IT DIES
        LDA     $C981,Y
        CMPA    #$04
        BNE     MRTS
        LDA     #$00            ;MISSILE DIES:
        STA     $C981,Y         ;TURN OFF BRIGHTNESS
        STA     $C980,Y         ;TURN OFF MISSILE
        LDA     $C917

        CMPA    #$11
        BMI     MRTS1

MRTS0   DEC     $C917
        JSR     ONEMIS
MRTS    JMP     EMISSI2
MRTS1   CMPA    #$FF
        BPL     MRTS
        BRA     MRTS0

MOVDONE RTS

MISMOVE LDB     #$00
        LDA     $C911
        CMPA    #$00
        BNE     MISMO01
MISMO00 LDA     $C912
        CMPA    #$00
        BNE     MISMO01
        BRA     MPOP
MISMO01 DEC     $C906           ;CHECK MISSILE SPEED
        LDA     $C906
        CMPA    #$00
        BNE     MOVDONE
        LDA     $C907
        STA     $C906
MPOP    LDY     #$00
MISMOV1 LDA     $C980,Y         ;CHECK IF MISSILE SHOULD BE DRAWN
        CMPA    #$01
        BEQ     MISMOV3
        LDA     $C980,Y
        CMPA    #$00
        BEQ     MISMOV2
        DEC     $C980,Y
MISMOV2 LEAY    8,Y
        CMPY    #$80
        BNE     MISMOV1         ;MORE MISSILES TO CHECK
        JMP     MOVDONE
MISMOV3 LDA     $C981,Y         ;MISSILE BRIGHTNESS REGISTER
        CMPA    #$4F
        BMI     MISMOV2         ;IT'S DYING, SO DON'T MOVE IT
        LDA     $C984,Y         ;MISSILE MOVEMENT ROUTINES
        SBCA    $C986,Y
        STA     $C984,Y

        LDA     $C985,Y
        ADDA    $C987,Y
        STA     $C985,Y

        LDA     $C982,Y
MM1     CMPA    #$00
        BEQ     MMFIX1
        LDA     $C984,Y         ;THIS ROUTINE ADDS THE
        SBCA    $C982,Y
        LSLA                    ;OFFSET TO THE START POINTS
        ADDA    $C982,Y         ;THE PROPER YX COORDS FOR THE
        CMPA    #$16
        BMI     MISMOV4
        JMP     MISMOV2
MMFIX1  LDA     $C984,Y
        LSLA
        ADDA    $C982,Y
        CMPA    #$16
        BMI     MISMOV4
        JMP     MISMOV2
MISMOV4 CMPA    #$00
        BPL     MISMOV5
        JMP     MISMOV2
MISMOV5 LDA     #$4E
        STA     $C981,Y
        LDD     $C984,Y         ;THIS ROUTINE ADDS THE
        LSLA                    ;OFFSET TO THE START POINTS
        LSLB                    ;OF THE MISSILES TO GIVE YOU
        NEGA
        ADDA    $C982,Y         ;THE PROPER YX COORDS FOR THE
        ADDB    $C983,Y         ;MISSILES ENDPOINTS
        STD     $CAB4
        JSR     GETEXP
        JMP     MISMOV2
*----------------------------------------------------------------------------
CHKPAUS JSR     DOSWTS          ;CHECK SWITCHES
        TST     SW12
        BEQ     PAUSER1
        LDA     $C94B
        CMPA    #$01
        BEQ     PAUSERT
        TST     SW12
        BEQ     PAUSERT
        LDA     $CAE7
        CMPA    #$00
        BNE     PAUSE0
        LDA     $C8B3
        CMPA    #$31
        BNE     PAUSE0
        LDA     $C8B4
        CMPA    #$35
        BNE     PAUSE0
        LDA     $C8B5
        CMPA    #$30
        BNE     PAUSE0
        JMP     HIDDEN
PAUSE0  LDA     #$01
        STA     $C94B
        LDU     #MUSIC7
        JSR     PON
        INC     $C949
        LDA     $C949
        CMPA    #$02
        BNE     PAUSERT
        LDA     #$00
        STA     $C949
        JMP     PRESUME
PAUSER1 LDA     #$00
        STA     $C94B
PAUSERT JMP     PRESUME
*----------------------------------------------------------------------------
CHKFIRE JSR     DOSWTS
        TST     SW11
        BEQ     NEXTSW0         ;NOT PRESSED
        LDA     $C94A
        CMPA    #$01
        BEQ     NEXTSW9
        TST     SW11
        BEQ     NEXTSW9
        LDA     #$01
        STA     $C94A
        LDU     #MUSIC4
        JSR     SON
        INC     $C93D
        LDA     $C93D
        CMPA    #$07
        BNE     NEXTSW9
        LDA     #$03
        STA     $C93D
        BRA     NEXTSW9
NEXTSW0 LDA     #$00
        STA     $C94A
NEXTSW9 TST     SW13
        BEQ     NEXTSW1        ;NOT PRESSED
        LDA     $CAAF
        CMPA    #$01
        BEQ     NEXTSW2        ;STILL HELD DOWN
        TST     SW13
        BEQ     NEXTSW2
        JSR     LFTMIS
        LDA     #$01
        STA     $CAAF
        JMP     NEXTSW2
NEXTSW1 LDA     #$00
        STA     $CAAF
NEXTSW2 TST     SW14
        BEQ     NEXTSW3        ;NOT PRESSED
        LDA     $CAB0
        CMPA    #$01
        BEQ     SKPSW2         ;STILL HELD DOWN
        TST     SW14
        BEQ     SKPSW2
        JSR     RGTMIS
        LDA     #$01
        STA     $CAB0
        JMP     SKPSW2
NEXTSW3 LDA     #$00
        STA     $CAB0
SKPSW2  LDY     #$00
SKPSW2A LDA     $CA5B,Y
        CMPA    #$00
        BEQ     JMPLOOP
        LDD     $CA5C,Y
        CMPB    #$00
        BEQ     SKIPPER
        NEGA
        STD     $C902
        PSHS    Y
        JSR     SETPEN
        LDA     #$7F
        STA     $C828
        JSR     ZAXTO7F
        JSR     $F2C5           ;DRAW MISSILE (DOT)
        JSR     RES0RF
        PULS    Y
SKIPPER LDA     $CA5C,Y
        SBCA    $CA5E,Y
        STA     $CA5C,Y
        LDA     $CA5D,Y
        SBCA    $CA5F,Y
        STA     $CA5D,Y

        LDD     $CA5C,Y
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2           ;BULLET TEMP POSITION
        LDD     $CA60,Y
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB4           ;ENDPOINT TEMP POSITION


        LDD     #$181A
        PSHS    Y
        LDX     $CAB2           ;LDX
        LDY     $CAB4           ;LDY
        JSR     $F8FF
        PULS    Y
        BLO     RSET
        JMP     JMPLOOP
RSET    LDA     #$00            ;TURN THE MISSILE OFF
        STA     $CA5B,Y
        LDD     $CAB4
        ADDA    #$7F
        ADDB    #$7F
        STD     $CAB4
        JSR     GETEXP          ;SET AN EXPLOSION
JMPLOOP LEAY    7,Y
        CMPY    #$54
        BMI     SKPSW2A
        RTS
*----------------------------------------------------------------------------
LFTMIS  LDA     $C911
        CMPA    #$00
        BNE     LFTMIS0
        LDU     #MUSIC3
        JSR     SON
        RTS
LFTMIS0 LDX     #$00            ;FIND AN UNUSED MISSILE
LFTMIS1 CMPX    #$53            ;NO MORE MISSILES TO FIRE
        BMI     LFTMIS2         ;
        RTS                     ;
LFTMIS2 DEC     $C911
        LDA     $C911
        CMPA    #$FF
        BPL     LFTM2A
        LDA     #$00
        STA     $C911
        RTS
LFTM2A  PSHS    X
        LDU     #MUSIC2
        JSR     SON
        PULS    X
        LDA     $CA5B,X         ;
        CMPA    #$00
        BEQ     LFTMIS3         ;FOUND AN UNUSED MISSILE
        LEAX    7,X             ;
        JMP     LFTMIS1
LFTMIS3 LDA     #$01            ;STORE THE MISSILE INFO HERE
        STA     $CA5B,X
        LDA     #$EA            ;LAUNCHER Y
        STA     $CA5C,X         ;STORE Y HERE
        LDA     #$02            ;LAUNCHER X
        STA     $CA5D,X         ;STORE X HERE
        LDA     $C900
        STA     $CA60,X         ;ENDPOINT Y
        LDA     $C901
        STA     $CA61,X         ;ENDPOINT X
        LDA     $CA5C,X
        SBCA    $C900           ;Y SLOPE
        LSRA
        LSRA
        LSRA
        LSRA
        STA     $CA5E,X         ;STORE Y SLOPE
        LDA     $C901
        SBCA    $CA5D,X         ;X SLOPE
        LSRA
        LSRA
        LSRA
        LSRA
        NEGA
        STA     $CA5F,X         ;STORE X SLOPE
        LDA     $C900
        STA     $CA05           ;STORE THE ENDPOINT OF THE LINE
        LDA     $C901
        STA     $CA06           ;ALSO THE EXPLOSION START
        RTS
*----------------------------------------------------------------------------
RGTMIS  LDA     $C912
        CMPA    #$00
        BNE     RGTMIS0
        LDU     #MUSIC3
        JSR     SON
        RTS
RGTMIS0 LDX     #$00            ;FIND AN UNUSED MISSILE
RGTMIS1 CMPX    #$53            ;NO MORE MISSILES TO FIRE
        BMI     RGTMIS2         ;
        RTS                     ;ADD AN "EMPTY LAUNCHER" SOUND HERE
RGTMIS2 DEC     $C912
        LDA     $C912
        CMPA    #$FF
        BPL     RGTM2A
        LDA     #$00
        STA     $C912
        RTS
RGTM2A  PSHS    X
        LDU     #MUSIC2
        JSR     SON
        PULS    X
        LDA     $CA5B,X         ;
        CMPA    #$00
        BEQ     RGTMIS3         ;FOUND AN UNUSED MISSILE
        LEAX    7,X             ;
        JMP     RGTMIS1
RGTMIS3 LDA     #$01            ;STORE THE MISSILE INFO HERE
        STA     $CA5B,X
        LDA     #$EA            ;LAUNCHER Y
        STA     $CA5C,X         ;STORE Y HERE
        LDA     #$00            ;LAUNCHER X
        STA     $CA5D,X         ;STORE X HERE
        LDA     $C900
        STA     $CA60,X         ;ENDPOINT Y
        LDA     $C901
        STA     $CA61,X         ;ENDPOINT X
        LDA     $CA5C,X
        SBCA    $C900           ;Y SLOPE
        LSRA
        LSRA
        LSRA
        LSRA
        STA     $CA5E,X         ;STORE Y SLOPE
        LDA     $CA5D,X
        SBCA    $C901           ;X SLOPE
        LSRA
        LSRA
        LSRA
        LSRA
        STA     $CA5F,X         ;STORE X SLOPE
        LDA     $C900
        STA     $CA05           ;STORE THE ENDPOINT OF THE LINE
        LDA     $C901
        STA     $CA06           ;ALSO THE EXPLOSION START
        RTS
*----------------------------------------------------------------------------
GETEXP  LDX     #$00            ;THIS FINDS AN UNUSED EXPLOSION
GETEXP1 CMPX    #$50            ;AND ASSIGNS IT TO THE ENDPOINT OF
        BNE     GETEXP2         ;A MISSILE
        RTS                     ;FINISHED CHECKING, RETURN FROM SUB
GETEXP2 LDA     $CA0C,X         ;CHECK IF EXPLOSION IS UNUSED
        CMPA    #$00
        BEQ     GETEXP3         ;FOUND ONE ! PROCEED TO SET COORDS
        LEAX    4,X             ;INCREASE X
        JMP     GETEXP1
GETEXP3 LDU     #EXPL1
        JSR     SON
        LDA     #$00
        STA     $CA0D,X         ;SET DIRECTION TO INCREASE
        LDA     #$02
        STA     $CA0C,X         ;TURN THE EXPLOSION ON
        LDD     $CAB4
        STD     $CA0A,X         ;STORE THE EXPLOSION COORDS
GETEXP4 RTS
*----------------------------------------------------------------------------
MOVEPL  JSR     DOJOY
        LDA     $C81B
        CMPA    #$00
        BEQ     CHKY            ;X IS CENTERED, CHECK Y
        CMPA    #$00
        BPL     JRIGHT          ;JOYSTICK IS MOVED RIGHT
        LDA     $C901
        SBCA    $C93D
        STA     $C901
        LDA     $C901
        CMPA    #$10
        BPL     CHKY
        CMPA    #$00
        BMI     CHKY
        LDA     $C901
        ADDA    $C93D
        STA     $C901
        JMP     CHKY
JRIGHT  LDA     $C901           ;MOVE SITE RIGHT
        ADDA    $C93D
        STA     $C901
        LDA     $C901
        CMPA    #$FF
        BPL     CHKY
        CMPA    #$F0
        BMI     CHKY
        LDA     $C901
        SBCA    $C93D
        STA     $C901
CHKY    LDA     $C81C           ;CHECK Y VALUE OF STICK
        CMPA    #$00
        BEQ     JRET            ;CENTERED, RETURN FROM SUB
        CMPA    #$00
        BPL     JUP             ;STICK IS MOVED UP
        LDA     $C900
        ADDA    $C93D
        STA     $C900
        LDA     $C900
        CMPA    #$FF
        BPL     JRET
        CMPA    #$CE
        BMI     JRET
        LDA     $C900
        SBCA    $C93D
        STA     $C900
        RTS
JUP     LDA     $C900
        SBCA    $C93D
        STA     $C900
        LDA     $C900
        CMPA    #$10
        BPL     JRET
        CMPA    #$00
        BMI     JRET
        LDA     $C900
        ADDA    $C93D
        STA     $C900
JRET    RTS
*----------------------------------------------------------------------------
DRWSPRT LDA     #$5F            ;SITE DRAWING ROUTINE
        JSR     ZAXTOA
        LDD     $C900
        NEGA
        STD     $C902
        JSR     SETPEN
        LDX     #SITE
        LDB     #$30
        JSR     DRWL1B
        JSR     RES0RF
        RTS
*----------------------------------------------------------------------------
SHRTCUT JMP     EXPRTS
*----------------------------------------------------------------------------
EXPROUT LDY     #$00
EXP20   LDA     $CA0C,Y         ;IS THE EXPLOSION ON ?
        CMPA    #$00
        BEQ     SHRTCUT
        PSHS    Y
        LDA     #$7F            ;DRAW THE EXPLOSION
        LDB     $CA0D,Y
        CMPB    #$01
        BNE     EXP20A
        LDA     $CA0C,Y
        ASLA
        ADDA    #$20
EXP20A  JSR     ZAXTOA
        PULS    Y
        LDD     $CA0A,Y
        NEGA
        STD     $C902           ;THE STANDARD TO VECTREX YX CONVERTER
        STD     $CAB4           ;TEMP HOLDING FOR EXPLOSION YX
        JSR     SETPEN
        LDB     $CA0C,Y
        PSHS    Y
        LDX     #OCT
        JSR     DRWL1B
        JSR     RES0RF
        PULS    Y
        PSHS    Y
        LDD     $CAB4           ;CONVERT TARGET BACK TO
        STD     $C93E
        SBCA    #$7F            ;VECTREX YX COORDS SO THE STUPID
        SBCB    #$7F            ;COLLISION DETECTION WILL WORK
        STD     $CAB4           ;PROPERLY
        JSR     SBCHK           ;SEE IF EXPLOSION HITS A SMARTBOMB
        PULS    Y
        LDD     $C93E
        STD     $CAB4
        LDA     $CA0D,Y
        CMPA    #$01
        BEQ     DECEXPL
        INC     $CA0C,Y         ;INCREASE THE EXPLOSION
        INC     $CA0C,Y
        LDA     #$01
        STA     $C956
        LDA     $CA0C,Y
        CMPA    #$10
        BEQ     GURGLE
        LDA     #$00
        STA     $C956
        LDA     $CA0C,Y
        CMPA    #$2A            ;CHECK TO SEE IF EXPLOSION "PEAKS"
        BNE     EXPRTS
        LDA     #$01
        STA     $CA0D,Y         ;EXPLOSION HAS PEAKED, REVERSE ITS DIRECTION
GURGLE  PSHS    Y
        LDD     $CAB4           ;CONVERT TARGET BACK TO
        SBCA    #$7F            ;VECTREX YX COORDS SO THE STUPID
        SBCB    #$7F            ;COLLISION DETECTION WILL WORK
        STD     $CAB4           ;PROPERLY
        STD     $C93E
        JSR     COLCHK          ;SEE IF EXPLOSION HAS HIT ANY MISSILES
        PULS    Y
        PSHS    Y
        LDD     $C93E
        STD     $CAB4
        JSR     CITYCHK         ;SEE IF EXPLOSION HAS HIT A CITY
        PULS    Y
        PSHS    Y
        LDD     $C93E
        STD     $CAB4
        JSR     LNCHCHK         ;SEE IF EXPLOSION HAS HIT A LAUNCHER
        PULS    Y
        PSHS    Y
        LDD     $C93E
        STD     $CAB4
        JSR     TARGCHK         ;SEE IF EXPLOSION HAS HIT A FLYING TARGET
        PULS    Y
        JMP     EXPRTS
DECEXPL DEC     $CA0C,Y
        LDA     $CA0C,Y
        CMPA    #$00
        BPL     EXPRTS
        LDA     #$00
        STA     $CA0C,Y
EXPRTS  LEAY    4,Y
        CMPY    #$50            ;4C
        BEQ     EXPFIN
        JMP     EXP20
EXPFIN  RTS
*----------------------------------------------------------------------------
CITYCHK LDY     #$00
CITYCH1 LDA     $CABB,Y         ;CHECK IF EXPLOSION HIT A CITY
        CMPA    #$00
        BNE     CITYCH3
CITYCH2 LEAY    3,Y
        CMPY    #$12
        BNE     CITYCH1
        RTS
CITYCH3 LDD     #$040F          ;AREA TO CHECK
        LDD     $CABC,Y
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        PSHS    Y
        LDD     #$040F
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        PULS    Y
        BLO     CITYCH4
        JMP     CITYCH2
CITYCH4 LDA     #$00
        STA     $CABB,Y
        LDA     #$01
        STA     $C95B,Y
        LDD     $CABC,Y
        DECA
        DECA
        STD     $C959,Y
        LDU     #NUKESND
        JSR     PON
        JMP     CITYCH2
*----------------------------------------------------------------------------
LNCHCHK LDA     $C923
        CMPA    #$7F
        BNE     LNCHCH1
        LDD     $CACD
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        LDD     #$0612
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        BLO     LEFTHIT
        JMP     LNCHCH1
LEFTHIT LDA     #$7E
        STA     $C923
        LDA     #$00
        STA     $C911
        LDU     #SPINNY
        JSR     PON
LNCHCH1 LDA     $C924
        CMPA    #$7F
        BEQ     LNCHCH2
        RTS
LNCHCH2 LDD     $CACF
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        LDD     #$0612
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        BLO     RGTHIT
        RTS
RGTHIT  LDA     #$7E
        STA     $C924
        LDA     #$00
        STA     $C912
        LDU     #SPINNY
        JSR     PON
        RTS
*----------------------------------------------------------------------------
TARGCHK LDA     $C939
        CMPA    #$6F
        BEQ     TC2
        RTS
TC2     LDD     $C935
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        LDD     #$0F14
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        BLO     TARGHIT
        RTS
TARGHIT LDD     $C935
        NEGA
        STD     $CAB4
        JSR     GETEXP
        LDA     #$6E
        STA     $C939
        LDD     #$0025
        JSR     ADD2SC
        RTS
*----------------------------------------------------------------------------
SBCHK   PSHS    Y
        LDY     #$00
SBCHK1  LDA     $C929,Y
        CMPA    #$00
        BNE     SB2
SBRTS   LEAY    5,Y
        CMPY    #$0F
        BNE     SBCHK1
        PULS    Y
        RTS
SB2     LDD     $C925,Y
        SBCA    #$8A
        SBCB    #$7F
        STD     $CAB2
        LDD     #$0A0A
        PSHS    Y
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        PULS    Y
        BLO     SBHIT
        LDD     $C925,Y
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        LDD     #$0F0F
        PSHS    Y
        LDX     $CAB2
        LDY     $CAB4
        JSR     $F8FF
        PULS    Y
        BLO     SBHIT2
        BRA     SBRTS
SBHIT   INC     $C925,Y
        INC     $C925,Y
        BRA     SBRTS
SBHIT2  LDD     $C925,Y
        NEGA
        STD     $CAB4
        PSHS    Y
        JSR     GETEXP
        PULS    Y
        LDA     #$00
        STA     $C929,Y
        LDD     #$0050
        JSR     ADD2SC
        BRA     SBRTS
*----------------------------------------------------------------------------
COLCHK  LDY     #$00
COLCHK1 LDA     $C980,Y
        CMPA    #$01
        BNE     COLCHK0
        LDA     $C981,Y         ;CHECK TO SEE IF MISSILE IS ON
        CMPA    #$4F
        BEQ     COLCHK2         ;MISSILE IS ON, CHECK COLLISION
COLCHK0 LEAY    8,Y
        CMPY    #$80
        BNE     COLCHK1
        RTS
COLCHK2 LDA     $C982,Y
        CMPA    #$00
        BEQ     COLFIX1
        LDD     $C984,Y         ;THIS ROUTINE ADDS THE
        SBCA    $C982,Y
        LSLA                    ;OFFSET TO THE START POINTS
        LSLB
        ADDA    $C982,Y         ;THE PROPER YX COORDS FOR THE
        ADDB    $C983,Y
        BRA     COLFIX2
COLFIX1 LDD     $C984,Y         ;THIS ROUTINE ADDS THE
        LSLA                    ;OFFSET TO THE START POINTS
        LSLB                    ;OF THE MISSILES TO GIVE YOU
        ADDA    $C982,Y         ;THE PROPER YX COORDS FOR THE
        ADDB    $C983,Y         ;MISSILES ENDPOINTS
COLFIX2 STD     $CAB2
        PSHS    Y
        LDD     $CAB2           ;CONVERT BULLET BACK TO STANDARD
        SBCA    #$7F            ;VECTREX YX COORDS SO THE STUPID
        SBCB    #$7F            ;COLLISION DETECTION WILL
        STD     $CAB2           ;WORK PROPERLY !
        LDX     $CAB2           ;MISSILE TEMP YX
        LDY     $CAB4           ;EXPLOSION TEMP YX
        LDA     $C956
        CMPA    #$01
        BNE     COLFIX3
        LDD     #$0808
        BRA     COLFIX4
COLFIX3 LDD     #$1212
COLFIX4 JSR     $F8FF
        PULS    Y
        BLO     MISHIT
        JMP     COLCHK0
MISHIT  LDD     $CAB4
        STD     $CAE4           ;SAVE WHAT'S IN $CAB4
        LDA     #$4E
        STA     $C981,Y
        LDD     $C984,Y         ;THIS ROUTINE ADDS THE
        LSLA                    ;OFFSET TO THE START POINTS
        LSLB                    ;OF THE MISSILES TO GIVE YOU
        NEGA
        ADDA    $C982,Y         ;THE PROPER YX COORDS FOR THE
        ADDB    $C983,Y         ;MISSILES ENDPOINTS
        STD     $CAB4
        PSHS    Y
        JSR     GETEXP
        LDD     $CAE4
        STD     $CAB4
        LDD     #$0010
        JSR     ADD2SC
        PULS    Y
MISHIT1 JMP     COLCHK0
*----------------------------------------------------------------------------
SETPEN  PSHS    Y               ;THIS ROUTINE CONVERTS STANDARD YX
        LDA     $C902
        SBCA    #$81            ;MOVE Y OVER
        STA     $C904
        LDA     $C903
        ADDA    #$80            ;MOVE X OVER
        STA     $C905
        LDX     #$C904
        JSR     MVD85
        PULS    Y
        RTS
*----------------------------------------------------------------------------
DOSWTS  CLRA                    ;NORMAL SWITCH MODE
        JSR     SWITCHS         ;READ SWITCHES
        RTS
*----------------------------------------------------------------------------
DOJOY   LDA     #$4F
        STA     JOYTYP
        JSR     JOYSTK          ;READ THE STICK
        RTS
*----------------------------------------------------------------------------
JOYSET  LDX     #JOYENS
        LDA     #1              ;CONSOLE 1, LEFT/RIGHT
        STA     ,X+
        LDA     #3              ;CONSOLE 1, UP/DOWN
        STA     ,X+
        CLRA                    ;IGNORE THE OTHER TWO
        STA     ,X+
        STA     ,X+
        RTS
*----------------------------------------------------------------------------
ALLMIS  LDY     #$00            ;SET UP ALL MISSILES FOR LEVEL
MOREM   LDA     #$00
        STA     $C980,Y          ;1 ENEMY MISSILE TEST
        STA     $C981,Y
        STA     $C982,Y
        STA     $C983,Y
        STA     $C984,Y
        STA     $C985,Y
        STA     $C986,Y
        STA     $C987,Y
        PSHS    Y
        JSR     $F511
        CMPA    #$FF
        BNE     MIFIXED
        LDA     #$FE
MIFIXED PULS    Y
        STA     $C983,Y
        LDA     #$02
        STA     $C986,Y
        LDA     #$01
        STA     $C987,Y
        JSR     RND
        STA     $C980,Y
        LDA     #$4F
        STA     $C981,Y
        LEAY    8,Y
        CMPY    #$80
        BNE     MOREM

        LDY     #$00
MOREN   LDA     $C983,Y
        CMPA    #$00
        BMI     MOREP
MOREO   LEAY    8,Y
        CMPY    #$80
        BNE     MOREN
        JMP     MOREQ
MOREP   LDA     $C987,Y
        NEGA
        STA     $C987,Y
        JMP     MOREO

MOREQ   LDY     #$00
MORER   JSR     YESNO
        CMPB    #$01
        BEQ     MORES
        JSR     YESNO
        CMPB    #$01
        BNE     MORET
        INC     $C986,Y
MORET   LEAY    8,Y
        CMPY    #$80
        BNE     MORER
        JMP     MOREU
MORES   LDA     #$00
        STA     $C987,Y
        JMP     MORET
MOREU   RTS
*----------------------------------------------------------------------------
MINI    LDY     #$00
MINI1   LDA     $C980,Y
        CMPA    #$00
        BEQ     MINI3
MINI2   LEAY    8,Y
        CMPY    #$80
        BNE     MINI1
        RTS
MINI3   LDD     $C935
        NEGA
        STD     $C982,Y
        LDA     #$00
        STA     $C984,Y
        STA     $C985,Y
        JSR     MINIR
        LDA     #$01
        STA     $C980,Y
        RTS
*----------------------------------------------------------------------------
ONEMIS  NOP
AOREM   LDA     #$00            ;IT UP WITH INFORMATION TO LAUNCH
        STA     $C982,Y
        STA     $C984,Y
        STA     $C985,Y
        PSHS    Y
        JSR     $F511
        CMPA    #$FF
        BNE     AIFIXED
        LDA     #$FE
AIFIXED PULS    Y
        STA     $C983,Y
MINIR   LDA     #$02
        STA     $C986,Y
        LDA     #$01
        STA     $C987,Y
        JSR     RND
        STA     $C980,Y
        LDA     #$4F
        STA     $C981,Y
AOREN   LDA     $C983,Y
        CMPA    #$00
        BMI     AOREP
        JMP     AORER
AOREP   LDA     $C987,Y
        NEGA
        STA     $C987,Y
AORER   JSR     YESNO
        CMPB    #$01
        BEQ     AORES
        JSR     YESNO
        CMPB    #$01
        BNE     AOREU
        INC     $C986,Y
        JMP     AOREU
AORES   LDA     #$00
        STA     $C987,Y
AOREU   RTS
*----------------------------------------------------------------------------
YESNO   PSHS    Y
        JSR     $F511           ;GENERATE A 1=YES, 0=NO
        PULS    Y
        CMPA    #$00            ;RETURN VALUE IN THE B ACCUMULATOR
        BPL     YESNO1
        LDB     #$00
        RTS
YESNO1  CMPA    #$7F
        BMI     YESNO2
        LDB     #$00
        RTS
YESNO2  LDB     #$01
        RTS
*----------------------------------------------------------------------------
RND     PSHS    Y
        JSR     $F511           ;GENERATE A RANDOM NUMBER FROM
        PULS    Y
        CMPA    $CAE6           ;1 TO n
        BMI     RND2            ;AND STORE IT IN THE ACCUMULATOR
        JMP     RND
RND2    CMPA    #$01            ;n IS THE MISSILE START POSITION
        BPL     RND3            ;AND DECREASES ON SKILL LEVEL INCREASE
        JMP     RND
RND3    RTS
*----------------------------------------------------------------------------
CHKSMRT INC     $C941
        LDA     $C941
        CMPA    #$04
        BNE     CHKSMR2
        LDA     #$00
        STA     $C941
        INC     $C942
        LDA     $C942
        CMPA    #$A1
        BEQ     CHKSMR3
        CMPA    #$A2
        BEQ     CHKSMR3
        LDB     $CAE7                   ;CHECK LEVEL
        CMPB    #$02
        BMI     CHKSMR2
        CMPA    #$80
        BEQ     CHKSMR1
        CMPB    #$03
        BMI     CHKSMR2
        CMPA    #$90
        BEQ     CHKSMR1
        CMPB    #$05
        BMI     CHKSMR2
        CMPA    #$A0
        BEQ     CHKSMR3
        RTS
CHKSMR1 JSR     SETSMRT
CHKSMR2 RTS
CHKSMR3 LDA     $C94F
        STA     $C942
        BRA     CHKSMR1
*----------------------------------------------------------------------------
SMART   LDY     #$00
SMART0  LDA     $C929,Y
        CMPA    #$01
        BEQ     SMART2
SMART1  LEAY    5,Y
        CMPY    #$0F
        BNE     SMART0
        RTS
SMART2  LDD     $C925,Y
        STD     $C902
        SBCA    #$7F
        SBCB    #$7F
        STD     $CAB2
        PSHS    Y
        JSR     SETPEN
        JSR     ZAXTO7F
        LDB     #$30
        LDX     #SB
        JSR     DRWL1B           ;DRAW SMART BOMB
        JSR     RES0RF
        PULS    Y
        DEC     $C925,Y
SLOG1   LDA     $C928,Y
        LSRA
        STA     $C940
        LDA     $C926,Y
        LSRA
        CMPA    $C940
        BMI     SLOG2
        DEC     $C926,Y
        BRA     SLOG3
SLOG2   INC     $C926,Y
SLOG3   LDA     $C925,Y
        CMPA    #$00
        BPL     SLOG4
        BRA     SLOG6
SLOG4   CMPA    #$16
        BPL     SLOG6
SLOG5   LDD     $C925,Y
        NEGA
        STD     $CAB4
        LDA     #$00
        STA     $C929,Y
        PSHS    Y
        JSR     GETEXP
        PULS    Y
SLOG6   PSHS    Y
        LDY     #$00
SMART4  LDA     $CA0C,Y
        CMPA    #$00
        BEQ     SMAREND
        LDD     $CA0A,Y
*       SBCA    #$7F
        SBCB    #$7F
        STD     $CAB4
        PSHS    Y
        LDX     $CAB2
        LDY     $CAB4
        LDD     #$0F0F
        JSR     $F8FF
        PULS    Y
        BLO     SMART5
        BRA     SMAREND
SMART5
SMAREND LEAY    4,Y
        CMPY    #$50
        BNE     SMART4
        PULS    Y
        BRA     SMART1
*----------------------------------------------------------------------------
SHOWLEV JSR     ZAXTO7F
        LDD     #$10CA          ;DISPLAY LEVEL
        JSR     $F2FC
        LDU     #$C8D0
        LDD     #$FC47
        STD     $C82A
        JSR     $F495
        LDA     #$FC
        STA     $C82A
        LDU     #LEVEL
        LDD     #0000
        LDA     #$20
        LDB     #$E8
        JSR     $F37A
        RTS
*----------------------------------------------------------------------------
SHOWSCR JSR     ZAXTO7F
        LDD     #$80DA          ;DISPLAY SCORE
        JSR     $F2FC
        LDU     #$C8B0
        LDD     #$FC47
        STD     $C82A
        JSR     $F495
        RTS
*----------------------------------------------------------------------------
BIGEXP  LDA     #$7F
        JSR     ZAXTOA
        LDX     #$C943
        JSR     MVD85
        LDX     #OCT
        LDB     $C945
        JSR     DRWL1B
        JSR     RES0RF
        LDA     $C946
        CMPA    #$01
        BEQ     REVS
        INC     $C945
        LDA     $C945
        CMPA    #$FF
        BNE     BIGRTS
        LDA     #$01
        STA     $C946
        RTS
REVS    DEC     $C945
        LDA     $C945
        CMPA    #$00
        BNE     BIGRTS
        LDA     #$FF
        STA     $C948
BIGRTS  RTS
*----------------------------------------------------------------------------
GO      LDU     #$CBEB
        LDX     #$C8B0
        JSR     $F8D8
GO0     JSR     DPTOC8
        LDU     $C91D           ;SOUND POINTER
        JSR     $F687
        JSR     WAITRCL
        LDA     $C948
        CMPA    #$FF
        BNE     GO000
        JMP     $F000
GO000   LDA     $C947
        CMPA    #$00
        BEQ     GOSK
        JSR     EXPROUT
        JSR     BIGEXP
        JSR     $F511
        STA     $CAB4
        JSR     $F511
        STA     $CAB5
        LDA     $C946
        CMPA    #$01
        BEQ     GOSK
        JSR     GETEXP
GOSK    JSR     SHOWSCR
        JSR     $F289
        LDA     #$7F
        LDB     $C946
        CMPB    #$00
        BEQ     GOSK1
        LDA     $C945
        LSRA
GOSK1   JSR     ZAXTOA
        LDA     $C920
        STA     $C82A
        LDA     #$01
        STA     $C947
        LDU     #OVER
        LDD     #0000
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
        LDA     $C920
        CMPA    #$FD
        BEQ     GO0
        NEGA
        STA     $C82A
        LDU     #OVER
        LDD     #0000
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
        LDA     $C920
        CMPA    #$FD
        BNE     GO1
        JMP     GO0
GO1     INC     $C920
        LDA     #$00
        STA     $C947
        JMP     GO0
*----------------------------------------------------------------------------
ADD2SC  STD     $C94C
        LDA     $CAE7
        CMPA    #$06
        BMI     ADD2SC1
        LDA     #$05                    ;LEVEL = BONUS MULTIPLIER
ADD2SC1 PSHS    A
        LDD     $C94C
        LDX     #$C8B0
        JSR     $F87C
        PULS    A
        DECA
        CMPA    #$00
        BPL     ADD2SC1
        LDA     $C954
        CMPA    #$06                    ;MAX 6 FREE CITIES PER GAME
        BPL     FREECT1
        LDA     $C8B1
        CMPA    $C950
        BNE     FREECT0
        BRA     FREECT1
FREECT0 LDA     #$01
        STA     $C953
        LDA     $C8B1
        STA     $C950
        INC     $C954
        INC     $C955
FREECT1 RTS
*----------------------------------------------------------------------------
SETSMRT LDA     $C911
        CMPA    #$00
        BNE     SETSM0
        LDA     $C912
        CMPA    #$00
        BNE     SETSM0
        RTS
SETSM0  PSHS    Y
        LDY     #$00
SETSM1  LDA     $C929,Y
        CMPA    #$00
        BEQ     GOTSM
GOTT    LEAY    5,Y
        CMPY    #$0F
        BNE     SETSM1
SSBRTS  PULS    Y
        RTS
GOTSM   JSR     $F511
        STA     $C926,Y
        LDA     #$FF
        STA     $C925,Y
        LDA     #$01
        STA     $C929,Y
        LDX     #$00
        JSR     $F511
        LSRA
        CMPA    #$0F
        BPL     QFIX1
        JMP     GOTSM7
QFIX1   CMPA    #$1F
        BPL     QFIX2
        JMP     GOTSM6
QFIX2   CMPA    #$6F
        BPL     GOTSM5
        CMPA    #$5F
        BPL     GOTSM4
        CMPA    #$4F
        BPL     GOTSM3
        CMPA    #$3F
        BPL     GOTSM2
        CMPA    #$2F
        BPL     GOTSM1
GOTSM0  LDA     $CABB
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM0A
        BRA     GOTSM1
GOTSM0A LDD     $CABC
        STD     $C927,Y
        JMP     FINSM
GOTSM1  LDA     $CABE
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM1A
        BRA     GOTSM2
GOTSM1A LDD     $CABF
        STD     $C927,Y
        JMP     FINSM
GOTSM2  LDA     $CAC1
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM2A
        BRA     GOTSM3
GOTSM2A LDD     $CAC2
        STD     $C927,Y
        JMP     FINSM
GOTSM3  LDA     $CAC4
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM3A
        BRA     GOTSM4
GOTSM3A LDD     $CAC5
        STD     $C927,Y
        JMP     FINSM
GOTSM4  LDA     $CAC7
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM4A
        BRA     GOTSM5
GOTSM4A LDD     $CAC8
        STD     $C927,Y
        JMP     FINSM
GOTSM5  LDA     $CACA
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM5A
        BRA     GOTSM6
GOTSM5A LDD     $CACB
        STD     $C927,Y
        JMP     FINSM
GOTSM6  LDA     $C911
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM6A
        BRA     GOTSM7
GOTSM6A LDD     #$160A
        STD     $C927,Y
        JMP     FINSM
GOTSM7  LDA     $C912
        LEAX    1,X
        CMPA    #$00
        BNE     GOTSM7A
        JMP     GOTSM8
GOTSM7A LDD     #$16FA
        STD     $C927,Y
        JMP     FINSM
GOTSM8  CMPX    #$08
        BPL     GOTSM9
        JMP     GOTSM1
GOTSM9  LDA     #$00
        STA     $C929,Y
        JMP     SSBRTS
FINSM   LDU     #MUSIC6
        JSR     PON
        JMP     SSBRTS

*----------------------------------------------------------------------------
SETTARG LDA     $C911
        CMPA    #$00
        BNE     LOK
        RTS
LOK     LDA     $C912
        CMPA    #$00
        BNE     ROK
        RTS
ROK     LDX     #PLANE1
        STX     UFO
        LDA     #$FA
        STA     $C936
        LDA     #$00
        STA     $C938
        JSR     YESNO
        CMPB    #$01
        BNE     SETTA0
        LDX     #PLANE
        STX     UFO
        LDA     #$01
        STA     $C936
        STA     $C938
SETTA0  LDA     #$6F
        STA     $C939
        JSR     $F511
        CMPA    #$7F
        BPL     SETTA1
        NEGA
SETTA1  SUBA    #$10
        STA     $C935
        LDU     #MUSIC5
        JSR     PON
        RTS
*----------------------------------------------------------------------------
TARG    LDA     $C939
        CMPA    #$00
        BNE     TARG1
        INC     $C93A
        LDA     $C93A
        CMPA    #$FF
        BNE     TARG0
        JSR     SETTARG
TARG0   RTS
TARG1   CMPA    #$6F
        BEQ     TARG2
        DEC     $C939
        DEC     $C939
TARG2   JSR     ZAXTOA
        LDD     $C935
        STD     $C902
        JSR     SETPEN
        LDB     #$40
        LDX     UFO
        JSR     DRWL1B
        JSR     RES0RF
        LDA     $C939
        CMPA    #$6F
        BNE     TARG3
        LDA     $C938
        CMPA    #$01
        BEQ     TARG21A
        DEC     $C936
        BRA     TARG21B
TARG21A INC     $C936
TARG21B LDA     $C936
        CMPA    #$00
        BEQ     TARGIGN
        CMPA    #$FC
        BEQ     TARGIGN
        BRA     TARG2A
TARGIGN LDA     #$00
        STA     $C939
        STA     $C93A
TARG2A  JSR     $F511
        CMPA    #$00
        BPL     TARG2B
        BRA     TARG3
TARG2B  CMPA    #$10
        BMI     TARG2C
        BRA     TARG3
TARG2C  JSR     MINI
TARG3   RTS

INC934  INC     $C934
        LDA     $C934
        CMPA    #$08
        BMI     RT934
        LDA     #$00
        STA     $C934
RT934   RTS

LEVEL   db      'LEVEL',$80
OVER    db      'GAME OVER',$80
PAWS    db      'GAME PAUSED',$80
BT      db      'BONUS CITY AWARDED',$80
HEAD1   db      'g 1996',$80
HEAD2   db      'BY JOHN DONDZILA',$80
HEAD3   db      'HIGH SCORE',$80
HEAD4   db      'PRESS BUTTON 1 TO PLAY',$80
HEAD5   db      'SPECIAL THANKS TO',$80
HEAD6   db      '   SEAN KELLY',$80
HEAD7   db      'MIKE ETLER AND VECTREX',$80
HEAD8   db      'LOVERS EVERYWHERE',$80
HEAD9   db      'CUSTOM PRODUCED FOR',$80
HEAD0   db      '                   ',$80

FAKE    fcb     $00,$00,$00
        fcb     1

SB      fcb      $00, $4, $0
        fcb      $FF, $FC, $4
        fcb      $FF, $FC, $FC
        fcb      $FF, $4, $FC
        fcb      $FF, $4, $4
        fcb      1

LINE    fcb     $FF,$00,$7F
        fcb     1

MV1     fcb      $FF, $FA, $4
        fcb      $FF, $6, $4
        fcb     1

MV2     fcb      $FF, $FA, $0
        fcb      $FF, $6, $4
        fcb      $FF, $FA, $4
        fcb     1

LAUNCH  fcb      $00, $F6, $FC
        fcb      $FF, $14, $0
        fcb      $FF, $0, $8
        fcb      $FF, $EC, $0
        fcb      $FF, $0, $F8
        fcb     1

SITE    fcb      $00, $A, $0
        fcb      $FF, $EC, $0
        fcb      $00, $A, $F6
        fcb      $FF, $0, $14
        fcb     1

XXXX    fcb      $00, $A, $0
        fcb      $FF, $EC, $14
        fcb      $00, $A, $F6
        fcb      $FF, $EC, $14
        fcb     1

CITY    fcb      $00, $0, $F0
        fcb      $FF, $E, $10
        fcb      $FF, $F2, $10
        fcb     1

OCT     fcB      0, 20, 40
        fcB      $FF, 20, $EC
        fcB      $FF, 0, $D8
        fcB      $FF, $EC, $EC
        fcb      $FF, $D8, 0
        fcb      $FF, $EC, 20
        fcb      $FF, 0, 40
        fcb      $FF, 20, 20
        fcb      $FF, 40, 0
        fcb      1

PLANE1  fcb      $00, $0, $F0
        fcb      $FF, $0, $1A
        fcb      $FF, $6, $4
        fcb      $FF, $0, $4
        fcb      $00, $FA, $E8
        fcb      $FF, $FC, $6
        fcb      $FF, $0, $8
        fcb      1

PLANE   fcb      $00, $4, $F6
        fcb      $FF, $F8, $F8
        fcb      $FF, $0, $A
        fcb      $FF, $FC, $4
        fcb      $FF, $0, $8
        fcb      $FF, $4, $4
        fcb      $FF, $0, $A
        fcb      $FF, $8, $F8
        fcb      $FF, $0, $EE
        fcb      1

EXPL1   FDB     $FD69
        FDB     $FD79
        fcb     $7F,$40
        FCB     0, $80


PING1   FDB     $FD69
        FDB     $FD79
        FCB     $20,$0A
        FCB     0, $80

PING2   FDB     $FD69
        FDB     $FD79
        FCB     $0A,$0A
        FCB     0, $80

PING3   FDB     $FD69
        FDB     $FD79
        FCB     $28,$0A
        FCB     0, $80

PING4   FDB     $FD69
        FDB     $FD79
        FCB     5,3,1,3,5,3,1,3,5,3,1,3,5,3,1,3,5,3,1,3,5,3,1,3,5,3,1,3
        FCB     0, $80

NUKESND FDB     $FD69
        FDB     $FD79
        fcb     $74,1,$75,1,$76,1,$77,1,$78,1,$79,1,$7A,1,$7B,1
        fcb     $7C,1,$7D,1,$7E,1,$7F,30,0,$80

MUSI    FDB     $FD69
        FDB     $FD79
        FCB     $7F,$03
        FCB     0, $80

MUSIC1  FDB     $FEE8
        FDB     $FEB6
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     $32, 1, $2F, 1, $2C, 1, $29, 1, $26, 1
        FCB     $23, 1, $20, 1, $1D, 1, $1A, 1, $17, 1
        FCB     $14, 1, $11, 1, $E, 1, $B, 1, $8, 1, $5, 1
        FCB     0, $80

MUSIC2  FDB     $FEE8
        FDB     $FEB6
        FCB     $6E,1,$7A,1,$78,1,$76,1,$74,1,$72,1,$70,1
        FCB     0, $80

MUSIC3  FDB     $FEE8
        FDB     $FEB6
        FCB     $30,1,$35,1,$3A,1,$40,1
        FCB     0, $80

MUSIC4  FDB     $FEE8
        FDB     $FEB6
        FCB     $10,1,$25,1,$30,1,$10,1,$25,1,$30,1
        FCB     0, $80

MUSIC5  FDB     $FEE8
        FDB     $FEB6
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     $10,1,$12,1,$14,1,$16,1,$18,1,$1A,1
        FCB     0, $80

MUSIC6  FDB     $FEE8
        FDB     $FEB6
        FCB     $2A,1,$28,1,$26,1,$24,1,$22,1,$20,1
        FCB     $22,1,$24,1,$26,1,$28,1,$2A,1,$2C,1
        FCB     $2A,1,$28,1,$26,1,$24,1,$22,1,$20,1
        FCB     $22,1,$24,1,$26,1,$28,1,$2A,1,$2C,1
        FCB     0, $80

MUSIC7  FDB     $FEE8
        FDB     $FEB6
        FCB     $20,5,0,5,$20,5,0,5
        FCB     0, $80

MUSIC8  FDB     $FEE8
        FDB     $FEB6
        FCB     $20,5,$10,5,$30,4,$5,2,$30,5,$25,2,$20,5,$15,2,$10,2
        FCB     $17,5,$11,5,$15,4,$4,2,$25,5,$12,2,$30,5,$32,2,$20,2
        FCB     $27,5,$21,5,$25,4,$7,2,$15,5,$32,2,$20,5,$12,2,$30,2
        FCB     0, $80

PPP     fcb      $FF, $22, $0
        fcb      $FF, $0, $E
        fcb      $FF, $FC, $4
        fcb      $FF, $F4, $0
        fcb      $FF, $FC, $FC
        fcb      $FF, $0, $F2
        fcb     1

AAA     fcb      $FF, $22, $A
        fcb      $FF, $DE, $A
        fcb      $00, $E, $FC
        fcb      $FF, $0, $F4
        fcb     1

TTT     fcb      $00, $0, $A
        fcb      $FF, $22, $0
        fcb      $00, $0, $F6
        fcb      $FF, $0, $14
        fcb     1

RRR     fcb      $FF, $22, $0
        fcb      $FF, $0, $E
        fcb      $FF, $FC, $4
        fcb      $FF, $F4, $0
        fcb      $FF, $FC, $FC
        fcb      $FF, $0, $F2
        fcb      $FF, $F2, $12
        fcb     1

III     fcb      $FF, $0, $14
        fcb      $00, $0, $F6
        fcb      $FF, $22, $0
        fcb      $00, $0, $F6
        fcb      $FF, $0, $14
        fcb     1

OOO     fcb      $00, $4, $0
        fcb      $FF, $FC, $4
        fcb      $FF, $0, $C
        fcb      $FF, $4, $4
        fcb      $FF, $1A, $0
        fcb      $FF, $4, $FC
        fcb      $FF, $0, $F4
        fcb      $FF, $FC, $FC
        fcb      $FF, $E6, $0
        fcb     1

SSS     fcb      $00, $4, $0
        fcb      $FF, $FC, $4
        fcb      $FF, $0, $C
        fcb      $FF, $4, $4
        fcb      $FF, $A, $0
        fcb      $FF, $4, $FC
        fcb      $FF, $0, $F4
        fcb      $FF, $4, $FC
        fcb      $FF, $8, $0
        fcb      $FF, $4, $4
        fcb      $FF, $0, $C
        fcb      $FF, $FC, $4
        fcb     1

POINT   fcb     $00,$06,$0
        fcb     1

BOOM    fcb      $00, $0, $F6
        fcb      $FF, $4, $4
        fcb      $FF, $E, $0
        fcb      $FF, $8, $F6
        fcb      $FF, $C, $0
        fcb      $FF, $6, $6
        fcb      $FF, $0, $14
        fcb      $FF, $FA, $6
        fcb      $FF, $F4, $0
        fcb      $FF, $F8, $F6
        fcb      $FF, $F2, $0
        fcb      $FF, $FC, $4
        fcb     1

SPINNY  FDB     $FEE8
        FDB     $FEB6
        fcb     $74,1,4,1,$75,1,3,1,$76,1,2,1,$77,20
        FCB     0, $80

HEADER  LDA     #$00
        STA     $C900
        STA     $C901
        STA     $C913
        STA     $C914
        STA     $C915
        STA     $C916
        LDA     #$00
        LDB     #$04
        LDX     #$03
TFILL   STA     $C900,X
        STB     $C901,X
        ADDA    #$05
        LEAX    2,X
        CMPX    #$13
        BNE     TFILL

TLOOP   JSR     DPTOC8
        JSR     WAITRCL
        JSR     DOSWTS
        TST     SW11
        BNE     PLAYPAT
        BRA     TLOOPP
PLAYPAT JMP     NEWGAME
TLOOPP  LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C903
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C904
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C904
        LDX     #SSS
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C905
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C906
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C906
        LDX     #TTT
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C907
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C908
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C908
        LDX     #OOO
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C909
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C90A
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C90A
        LDX     #III
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C90B
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C90C
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C90C
        LDX     #RRR
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C90D
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C90E
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C90E
        LDX     #TTT
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C90F
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C910
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C910
        LDX     #AAA
        JSR     DRWL1B
        JSR     RES0RF

        LDX     #$C900
        JSR     MVD85
        LDX     #LINE
        LDA     $C911
        LDU     #$CA00
        JSR     $F61F
        LDA     #$00
        JSR     ZAXTOA
        LDB     $C912
        LDX     #$CA00
        JSR     DRWL1B
        LDA     $C914
        JSR     ZAXTOA
        LDB     $C912
        LDX     #PPP
        JSR     DRWL1B
        JSR     RES0RF

        LDA     $C904
        CMPA    #$50
        BMI     DITA
        BRA     DIT0
DITA    JMP     PASST
DIT0    LDA     $C916
        CMPA    #$7F
        BEQ     DIT
        INC     $C916
DIT     LDA     $C916
        JSR     ZAXTOA
        INC     $C957
        LDA     $C957
        CMPA    #$7F
        BNE     DSELEC
        LDA     #$00
        STA     $C957
        INC     $C958
        LDA     $C958
        CMPA    #$04
        BNE     DSELEC
        LDA     #$00
        STA     $C958
DSELEC  LDA     $C958
        CMPA    #$01
        BEQ     DIT4
        CMPA    #$02
        BEQ     DIT2
        CMPA    #$03
        BEQ     DIT3
        LDU     #HEAD1
        LDD     #$FA26
        STD     $C82A
        LDA     #$10
        LDB     #$F0
        JSR     $F37A
        LDU     #HEAD2
        LDD     #$FA26
        STD     $C82A
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
        JMP     HIGHD
DIT4    LDU     #HEAD9
        LDD     #$FA26
        STD     $C82A
        LDA     #$10
        LDB     #$D0
        JSR     $F37A
        LDU     #HEAD0
        LDD     #$FA26
        STD     $C82A
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
        JMP     HIGHD
DIT2    LDU     #HEAD5
        LDD     #$FA26
        STD     $C82A
        LDA     #$10
        LDB     #$D0
        JSR     $F37A
        LDU     #HEAD6
        LDD     #$FA26
        STD     $C82A
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
        JMP     HIGHD
DIT3    LDU     #HEAD7
        LDD     #$FA26
        STD     $C82A
        LDA     #$10
        LDB     #$C0
        JSR     $F37A
        LDU     #HEAD8
        LDD     #$FA26
        STD     $C82A
        LDA     #$00
        LDB     #$D2
        JSR     $F37A
HIGHD   LDD     #$7F0C          ;DISPLAY HIGH SCORE
        JSR     $F2FC
        LDU     #$CBEB
        LDD     #$FB26
        STD     $C82A
        JSR     $F495
        LDU     #HEAD3
        LDD     #$FB26
        STD     $C82A
        LDA     #$7F
        LDB     #$D2
        JSR     $F37A
        LDU     #HEAD4
        LDD     #$F830
        STD     $C82A
        LDA     #$80
        LDB     #$B0
        JSR     $F37A
PASST   INC     $C915
        LDA     $C915
        CMPA    #$01
        BEQ     ROTSOME
        JMP     TLOOP
ROTSOME INC     $C903
        INC     $C905
        INC     $C907
        INC     $C909
        INC     $C90B
        INC     $C90D
        INC     $C90F
        INC     $C911
        LDA     #$00
        STA     $C915

        LDA     $C914
        CMPA    #$7F
        BEQ     SIZER
        INC     $C914
        JMP     TLOOP
SIZER   INC     $C913
        LDA     $C913
        CMPA    #$0A
        BEQ     INCREA
        JMP     TLOOP
INCREA  LDA     $C904
        CMPA    #$50
        BPL     INCREAP
        INC     $C904
        INC     $C906
        INC     $C908
        INC     $C90A
        INC     $C90C
        INC     $C90E
        INC     $C910
        INC     $C912
INCREAP LDA     #$00
        STA     $C913
        JMP     TLOOP

SON     LDA     $C856
        CMPA    #$00
        BEQ     SON1
        LDA     $C94E
        CMPA    #$00
        BEQ     SON1
        RTS
SON1    LDA     #$00
        STA     $C94E
        STU     $C91D
        LDA     #$01
        STA     $C856
        RTS
PON     LDA     #$01
        STA     $C94E
        BEQ     SON1
        STU     $C91D
        LDA     #$01
        STA     $C856
        RTS

ELOOP   LDU     #MUSIC8
        JSR     PON
ELOOP1  JSR     DPTOC8
        LDU     $C91D           ;SOUND POINTER
        JSR     $F687
        JSR     WAITRCL
        JSR     $F289
        JSR     ZAXTO7F
        LDU     #BT
        LDD     #$FB24
        STD     $C82A
        LDA     #$10
        LDB     #$D0
        JSR     $F37A
        INC     $C953
        LDA     $C953
        CMPA    #$00
        BNE     ELOOP1
        RTS

FREECHK LDY     #$00            ;SEE IF FREE CITY CAN BE ADDED TO
EMPTY1  LDA     $CABB,Y         ;A DEAD CITY
        CMPA    #$00
        BNE     EMPTY2
        LDA     $C955
        CMPA    #$00            ;NO FREE CITIES TO AWARD
        BEQ     EMPTY2
        LDA     #$01
        STA     $CABB,Y
        DEC     $C955
EMPTY2  LEAY    3,Y
        CMPY    #$12
        BMI     EMPTY1
        RTS

BUSTBGN LDD     #$0000
        STD     $C8B0           ;PLAYER SCORE
        LDX     #$C8B0
        JSR     $F84F           ;INIT PLAYER SCORE
        LDA     #$03
        STA     $C992           ;BALLS LEFT
        STA     $C99D           ;PADDLE SPEED
        LDA     #$00
        STA     $C994
        LDA     #$7E
        STA     $C99A

NEWGUM  LDD     #$3075
        STD     $C83D           ;SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        STD     $8              ;START T2
        LDA     #$28
        STA     $C990           ;BLOCKS LEFT

        LDY     #$00
        LDX     #$0000
        LDA     #$6F            ;BLOCK Y
        LDB     #$80            ;BLOCK X
BFILL   STA     $C902,Y
        STB     $C903,Y
        PSHS    A
        LDA     #$7E
        STA     $C904,Y
        PULS    A
        ADDB    #$1A
        LEAX    1,X
        CMPX    #$0A
        BEQ     BINC
BFILL0  LEAY    3,Y
        CMPY    #$78
        BNE     BFILL
        BRA     NEWLEVB
BINC    LDB     #$80
        SUBA    #$12
        LDX     #$0000
        BRA     BFILL0

NEWLEVB JSR     >JOYSET         ;SET UP FOR JOYSTICK
        LDA     #$90
        STA     $C900           ;SITE Y COORD
        LDA     #$00
        STA     $C901           ;SITE X COORD

NEWBALL LDA     #$00
        STA     $C980           ;BALL 1 COORDS
        STA     $C981
        STA     $C993
        LDA     #$FD
        STA     $C982
        INCA
        STA     $C983

        LDA     #$80            ;SET BOTTOM BOUNDARY
        STA     $C98C
        LDA     #$00
        STA     $C98D
        STA     $C991

BRLOOP  JSR     DPTOC8
        LDU     $C995
        JSR     $F687
        JSR     WAITRCL         ;WAIT FOR END OF CYCLE
        JSR     $F289
        JSR     DRW0000         ;DRAW SPRITES
        JSR     MOVEBPL         ;PLAYER MOVEMENT ROUTINES
        LDA     $C993
        CMPA    #$00
        BEQ     BRLOOP0
        DEC     $C993
        CMPA    #$01
        BNE     BRLOOP
        BRA     NEWBALL
BRLOOP0 LDA     $C991
        CMPA    #$00
        BEQ     BRLOOP1
        JSR     BALLM           ;MOVE BALLS
        LDA     $C994
        CMPA    #$00
        BEQ     BRLOOP1
        JSR     BALLM           ;MOVE BALLS FASTER
BRLOOP1 JSR     RES0RF
        JSR     SHOWSCR
        LDA     $C992
        CMPA    #$00
        BNE     BRCONT
        LDU     #OVER
        LDD     #0000
        LDA     #$F0
        LDB     #$D2
        JSR     $F37A
        JMP     BRLOOP
BRCONT  JSR     DOSWTS
        TST     SW11
        BEQ     NBUTT
        LDA     #$01
        STA     $C991
OBUTT   JMP     BRLOOP

PBUTT   CLR     $C99E
        JMP     BRLOOP

NBUTT   TST     SW12
        BEQ     PBUTT
        LDA     $C99E
        CMPA    #$01
        BEQ     OBUTT
        TST     SW12
        BEQ     OBUTT
        LDA     #$01
        STA     $C99E
        INC     $C99D
        LDA     $C99D
        CMPA    #$0F
        BNE     OBUTT
        LDA     #$03
        STA     $C99D
        BRA     OBUTT

MOVEBPL JSR     DOJOY
        LDA     $C81B
        CMPA    #$00
        BEQ     JOY2RTS
        CMPA    #$00
        BPL     JOY2R
        LDA     $C99D
SIGH1   LDB     $C901
        CMPB    #$80
        BEQ     JOY2RTS
        DEC     $C901
        DECA
        CMPA    #$00
        BNE     SIGH1
JOY2RTS RTS
JOY2R   LDA     $C99D
JOY2R0  LDB     $C901
        CMPB    #$7F
        BEQ     JOY2RTS
        INC     $C901
        DECA
        CMPA    #$00
        BNE     JOY2R0
        RTS

BALLM   LDA     $C982           ;Y OFFSET
        ADDA    $C980
        STA     $C980
        LDA     $C983           ;X OFFSET
        ADDA    $C981
        STA     $C981

        LDD     $C900
        SUBB    #$12
        STD     $CAB4
        LDX     $CAB4
        LDY     $C980
        LDD     #$0206
        JSR     $F8FF
        BLO     BHPAD1
        LDD     $C900
        ADDB    #$12
        STD     $CAB4
        LDX     $CAB4
        LDY     $C980
        LDD     #$0206
        JSR     $F8FF
        BLO     BHPAD2
        LDD     $C980
        STD     $CAB4
        LDX     $CAB4
        LDY     $C900
        LDD     #$0208
        JSR     $F8FF
        BLO     BHPAD3
        BRA     CHBOT
BHPAD1  LDA     $C982
        NEGA
        STA     $C982
        LDA     #$FC
        STA     $C983
        LDU     #PING2
        JSR     PONG
        LDA     $C982           ;Y OFFSET
        ADDA    $C980
        STA     $C980
        JMP     CHLFT
BHPAD2  LDA     $C982
        NEGA
        STA     $C982
        LDA     #$04
        STA     $C983
        LDU     #PING2
        JSR     PONG
        LDA     $C982           ;Y OFFSET
        ADDA    $C980
        STA     $C980
        JMP     CHLFT
BHPAD3  LDA     $C982
        NEGA
        STA     $C982
        LDU     #PING2
        JSR     PONG
        LDA     $C982           ;Y OFFSET
        ADDA    $C980
        STA     $C980
        JMP     CHLFT
CHBOT   LDA     $C980
        CMPA    #$81
        BEQ     HITBOT
        CMPA    #$82
        BEQ     HITBOT
        CMPA    #$83
        BEQ     HITBOT
        BRA     CHTOP
HITBOT  LDA     #$00
        STA     $C991
        DEC     $C992
        LDA     #$7F
        STA     $C993
        LDU     #PING4
        JSR     PONG
        BRA     RTNBAL
CHTOP   LDA     $C980
        CMPA    #$7C
        BEQ     HITTOP
        CMPA    #$7D
        BEQ     HITTOP
        CMPA    #$7E
        BEQ     HITTOP
        BRA     CHLFT
HITTOP  LDA     $C982
        NEGA
        STA     $C982
        LDA     #$01
        STA     $C994
        LDU     #PING1
        JSR     PONG
CHLFT   LDA     $C981
        CMPA    #$81
        BEQ     HITLFT
        CMPA    #$82
        BEQ     HITLFT
        CMPA    #$83
        BEQ     HITLFT
        BRA     CHRGT
HITLFT  LDA     $C983
        NEGA
        STA     $C983
        LDU     #PING1
        JSR     PONG
        JSR     BALLADD
        RTS
CHRGT   LDA     $C981
        CMPA    #$7C
        BEQ     HITRGT
        CMPA    #$7D
        BEQ     HITRGT
        CMPA    #$7E
        BEQ     HITRGT
        RTS
HITRGT  LDA     $C983
        NEGA
        STA     $C983
        LDU     #PING1
        JSR     PONG
        JSR     BALLADD
RTNBAL  RTS

BALLADD LDA     $C982           ;Y OFFSET
        ADDA    $C980
        STA     $C980
        LDA     $C983           ;X OFFSET
        ADDA    $C981
        STA     $C981
        RTS

DRW0000 LDX     #$C902          ;POINT TO START OF BLOCK COORDS
NEXTM   PSHS    X
        JSR     MVD85
        LDA     $00,X
        CMPA    #$3F
        BNE     NNEE
        ADDA    #$10
NNEE    JSR     ZAXTOA
        LDB     #$7F
        LDX     #BRIK
        JSR     DRWL1B
        JSR     RES0RF
        PULS    X
        LEAX    3,X
        CMPX    #$C97A
        BNE     NEXTM           ;DO NEXT BLOCK

        JSR     ZAXTO7F         ;DRAW BALL #1
        LDX     #$C980
        JSR     MVD85
        LDX     #OCT
        LDB     #$08
        JSR     DRWL1B
        JSR     RES0RF
        LDX     #$C900
        JSR     MVD85
        LDX     #PADDLE
        LDB     #$7F
        JSR     DRWL1B
        JSR     RES0RF

        LDY     #$00
B000    LDA     $C904,Y
        CMPA    #$00
        BEQ     B001
        LDD     $C902,Y
        STD     $CAB4
        PSHS    Y
        LDX     $C980
        LDY     $CAB4
        LDD     #$0A18
        JSR     $F8FF
        PULS    Y
        BLO     BLOKHT
B001    LEAY    3,Y
        CMPY    #$77
        BMI     B000
        RTS
BLOKHT  LDU     #PING3
        JSR     PONG
        LDA     $C904,Y
        SUBA    $C99A
        STA     $C904,Y
        LDA     $C982
        NEGA
        STA     $C982
        JSR     BALLADD
        LDA     $C904,Y
        CMPA    #$00
        BNE     BLOKPAS
        LDD     #$0001
        LDX     #$C8B0
        JSR     $F87C
        DEC     $C990
        LDA     $C990
        CMPA    #$00
        BEQ     GRUB
BLOKPAS RTS
GRUB    LDA     #$3F
        STA     $C99A
        JMP     NEWGUM

DOJOY2  LDA     #$FF              ;DO SIMPLE READING (+/0/-)
        STA     JOYTYP
        LDA     #$00
        STA     $C81A
        JSR     JOYSTK          ;READ THE STICK
        RTS

PONG    STU     $C995
        LDA     #$01
        STA     $C856
        RTS


BRIK    fcb      $FF,$0, $18
        fcb      $FF,$F4, $0
        fcb      $FF,$0, $E8
        fcb      $FF,$C, $0
        fcb     1

PADDLE  fcb      $00, $2, $0
        fcb      $FF, $0, $F4
        fcb      $FF, $FA, $0
        fcb      $FF, $0, $18
        fcb      $FF, $6, $0
        fcb      $FF, $0, $F4
        fcb     1

NUKE    PSHS    Y
        LDA     #$00
        STA     $C96B                   ;EXPLOSIONS LEFT FLAG
        LDY     #$00
NUKE1   LDA     $C95B,Y
        CMPA    #$00
        BNE     NUKE3
NUKE2   LEAY    3,Y
        CMPY    #$12
        BNE     NUKE1
        PULS    Y
        RTS
NUKE3   PSHS    Y
        INC     $C96B
        LDA     $C95B,Y
        NEGA
        SUBA    #$7A
        JSR     ZAXTOA
        LDD     $C959,Y
        STD     $C902
        JSR     SETPEN
        LDB     $C95B,Y
        ADDB    #$20
        LDX     #BOOM
        JSR     DRWL1B
        JSR     RES0RF
        PULS    Y
        INC     $C95B,Y
        INC     $C95B,Y
        LDA     $C95B,Y
        CMPA    #$7A
        BPL     NUKE4
        BRA     NUKE2
NUKE4   LDA     #$00
        STA     $C95B,Y
        BRA     NUKE2

SMS1    DB      'CONGRATULATIONS',$80
SMS2    DB      'YOU FOUND THE SECRET GAME',$80
SMS3    DB      'BUTTON 1 LAUNCHES BALL',$80
SMS4    DB      'BUTTON 2 CHANGES PADDLE SPEED',$80
SMS6    DB      'KEEP THE VECTREX ALIVE j JRD',$80

HIDDEN  JSR     CLRMEM
        LDA     #$00
        STA     $C99B
        STA     $C99C
SECLOOP JSR     DPTOC8
        JSR     WAITRCL
        LDU     #SMS1
        LDD     #$F822
        STD     $C82A
        LDA     #$6F
        LDB     #$D2
        JSR     $F37A
        LDU     #SMS2
        LDD     #$FA25
        STD     $C82A
        LDA     #$4F
        LDB     #$C2
        JSR     $F37A
        LDU     #SMS3
        LDD     #$FA25
        STD     $C82A
        LDA     #$1F
        LDB     #$C2
        JSR     $F37A
        LDU     #SMS4
        LDD     #$FA25
        STD     $C82A
        LDA     #$0F
        LDB     #$C2
        JSR     $F37A
        LDU     #SMS6
        LDD     #$FA25
        STD     $C82A
        LDA     #$AF
        LDB     #$C2
        JSR     $F37A
        INC     $C99B
        LDA     $C99B
        CMPA    #$00
        BEQ     HIDDEN1
HIDDEN0 JMP     SECLOOP
HIDDEN1 CLR     $C99B
        INC     $C99C
        LDA     $C99C
        CMPA    #$03
        BMI     HIDDEN0
        JMP     BUSTBGN

MUSIC   FDB     $FEE8
        FDB     $FEB6
        fcb     20,20,18,20
        fcb     16,20,14,20,16,10,18,10,20,10
        fcb     22,10,20,30
        FCB     0, $80

CLRMEM  LDX     #$C900
        JSR     $F545
        LDX     #$CA00
        JSR     $F545
        RTS

        NOP


