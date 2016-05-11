DRWL1B              EQU      $F40E                ;DRAW LINE, MAG IN B 
ZAXTO7F             EQU      $F2A9                ;SET Z AXIS INTENSITY TO 7F 
ZAXTOA              EQU      $F2AB                ;SET Z AXIS INTENSITY TO A 
SWITCHS             EQU      $F1B4                ;READ SWITCHES 
JOYSTK              EQU      $F1F8                ;READ JOYSTICK 
RES0RF              EQU      $F354                ;RESET ZERO REFERENCE 
MVD85               EQU      $F30C                ;MOVE DOT WITH MEDIUM INTEGRATION F30C 
WAITRCL             EQU      $F192                ;WAIT FOR T2 TIMEOUT, RECALIBRATE 
DPTOD0              EQU      $F1AA                ;SET DP TO D0 (I/O) 
DPTOC8              EQU      $F1AF                ;SET DP TO C8 (RAM) 
SW11                EQU      $C812                ;SWITCH 1, CONSOLE 1 
SW12                EQU      $C813                ; " 2, " 1 
SW13                EQU      $C814                ; " 3, " 1 
SW14                EQU      $C815                ; " 4, " 1 
JOYVLS              EQU      $C81B                ;JOYSTICK VALUES (4 BYTES) 
JOYENS              EQU      $C81F                ;JOYSTICK ENABLES (4 BYTES) 
JOYTYP              EQU      $C823                ;JOYSTICK CONVERSION TYPE 
                    ORG      0 
                    db       'g GCE 1996',$80
                    FDB      $FEC6 
                    FcB      $F6,$46,$2F,$AA 
                    db       'ROCKAROIDS REMIX',$80,$00
RSTART              LDD      #$3075               ;SET T2, INIT MEMORY, ETC ETC ETC ! 
                    STD      $C83D                ;SET T2 TIMER FOR 20 MSEC 
                    STD      $8                   ;START T2 
                    JSR      $F272                ;RESET SOUND CHIP 
                    LDA      #$01 
                    STA      $C900 
                    LDX      #$0800 
                    STX      $CA00 
RTIT                JSR      DPTOD0 
                    JSR      WAITRCL 
                    JSR      ZAXTO7F 
                    LDD      #$FC47 
                    STD      $C82A 
                    LDX      $CA00 
                    LEAX     100,X 
                    STX      $CA00 
                    CMPX     #$0800 
                    BPL      RTIT0 
                    JMP      RTITLE4 

RTIT0               LDD      #$20E6 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$20 
                    LDX      #RSPR4 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDD      #$10E6 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$30 
                    LDX      #RSPR2 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDD      #$F6E6 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$60 
                    LDX      #RSPR4 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDD      #$D0E6               ;SAUCER 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$20 
                    LDX      #RSPR6 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDD      #$C0E6               ;SAUCER 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$40 
                    LDX      #RSPR6 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDU      #RTXT8 
                    JSR      $F38A 
                    BRA      RTGO 

RTITLE4             LDU      #RTXT13 
                    JSR      $F38A 
                    LDD      #$6000 
                    STD      $C930 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDB      #$40 
                    LDX      #RSPR1 
                    JSR      DRWL1B 
                    JSR      RES0RF 
RTGO                JSR      MDOSWTS 
                    TST      SW14 
                    BEQ      RTITLE2 
                    LDA      $C900 
                    CMPA     #$01 
                    BEQ      RTITLE3 
                    JMP      RBEGIN 

RTITLE2             LDA      #$00 
                    STA      $C900 
RTITLE3             JMP      RTIT 

RBEGIN              LDD      #$0000 
                    STD      $C880                ;PLAYER SCORE 
                    LDX      #$C880 
                    JSR      $F84F                ;INIT PLAYER SCORE 
                    JSR      MJOYSET 
                    LDD      #$0000 
                    STD      $C880                ;PLAYER SCORE 
                    STD      $C990                ;BONUS SHIP SCORE 
                    LDX      #$C880 
                    JSR      $F84F                ;INIT PLAYER SCORE 
                    LDA      #$03 
                    STA      $C96E                ;SHIPS REMAINING 
                    LDA      #$04 
                    STA      $CAFF                ;ASTEROIDS IN LEVEL 
                    LDD      #$0000 
                    STD      $C930                ;SHIP YX 
                    STA      $C932 
                    LDX      #$C990 
                    JSR      $F84F                ;INIT BONUS SHIP SCORE 
                    LDD      #$9999 
                    LDX      #$C990 
                    JSR      $F87C 
                    JSR      RNEWS 
RNEWLEV             LDB      $C96E 
                    LDX      #$C933 
                    LDA      #$00 
RNEWL1              STA      $00,X 
                    LEAX     1,X 
                    CMPX     #$C98F 
                    BNE      RNEWL1 
                    STB      $C96E 
                    LDA      #$00 
                    STA      $C937 
                    LDX      #$CA00 
RNEWL1A             STA      $00,X 
                    LEAX     1,X 
                    CMPX     #$CAFE 
                    BNE      RNEWL1A 
                    LDB      $CAFF 
                    LDX      #$CA00 
RNEWL2              PSHS     B 
                    PSHS     X 
RB1                 JSR      $F511 
                    CMPA     #$5F 
                    BPL      RB2 
                    BRA      RB1 

RB2                 CMPA     #$A0 
                    BMI      RB3 
                    BRA      RB1 

RB3                 PULS     X 
                    STA      $00,X 
                    PSHS     X 
RC1                 JSR      $F511 
                    CMPA     #$5F 
                    BPL      RC2 
                    BRA      RC1 

RC2                 CMPA     #$A0 
                    BMI      RC3 
                    BRA      RC1 

RC3                 PULS     X 
                    STA      $01,X 
                    JSR      RRND3 
                    STA      $02,X 
                    JSR      RRND3 
                    STA      $03,X 
                    LDA      #$01 
                    STA      $04,X 
                    JSR      RANDOM2 
                    ADDA     $04,X 
                    STA      $04,X 
                    LDD      $02,X 
                    CMPA     #$00 
                    BNE      RNEWL3 
                    CMPB     #$00 
                    BNE      RNEWL3 
                    LDA      #$01 
                    STA      $03,X 
RNEWL3              LEAX     5,X 
                    PULS     B 
                    DECB     
                    CMPB     #$00 
                    BNE      RNEWL2 
                    LDD      #$0080 
                    STD      $C95E 
                    LDA      #$20 
                    STA      $C963 
                    LDA      #$01 
                    STA      $C965 
                    JSR      RPPP 
RNEWL4              LDA      #$01 
                    STA      $C979 
                    LDU      #RSDAT2 
                    JSR      $F27D 
                    LDA      #$34 
                    STA      $C97E 
                    INCA     
                    INCA     
                    STA      $C97F 
                    LDA      #$03 
                    STA      $C981 
                    LDA      $C932 
                    STA      $C9B5 
                    LDA      #$01 
                    STA      $C94D 
RLOOP               JSR      DPTOD0 
                    JSR      WAITRCL 
                    LDA      $C97A 
                    CMPA     #$00 
                    BEQ      RLOO000 
                    JSR      ZAXTO7F 
                    LDD      #$FC47 
                    STD      $C82A 
                    LDU      #RTXT1 
                    LDD      #$00C0 
                    JSR      $F37A 
                    LDA      #$00 
                    STA      $C96E 
                    INC      $C97A 
                    LDA      $C97A 
                    CMPA     #$FF 
                    BNE      RLOOP00 
                    LDX      #$C880 
                    LDU      #$CBEB 
                    JSR      $F8D8 
                    JMP      $F000 

RLOO000             LDA      $C96F 
                    CMPA     #$00 
                    BEQ      RLOOP0 
                    JSR      RDIE 
                    BRA      RLOOP00 

RLOOP0              JSR      RDRAW 
                    JSR      RINPUT 
RLOOP00             JSR      RSHOWSC 
                    JSR      RFIRE 
                    JSR      REXPLO 
                    JSR      RROCKS 
                    JSR      RWHECK 
                    JSR      RSAUC 
                    JSR      RSOUND1 
                    INC      $C954 
                    LDA      $C954 
                    CMPA     #$02 
                    BNE      RLOOP1 
                    LDA      #$00 
                    STA      $C954 
RLOOP1              LDA      $C95D                ;CHECK END OF LEVEL FLAG 
                    CMPA     #$00 
                    BEQ      RLOOP 
                    LDB      $C960                ;CHECK IF SAUCER IS STILL AROUND 
                    CMPB     #$00 
                    BNE      RLOOP 
                    INC      $C95D                ;INCREASE EOL FLAG TO KILL SOME TIME 
                    LDA      $C95D 
                    CMPA     #$FF 
                    BNE      RLOOP 
                    LDA      $CAFF                ;CHECK MAX ASTEROIDS PER LEVEL 
                    CMPA     #$09 
                    BPL      RLOOP2 
                    INC      $CAFF                ;INCREASE LEVEL 
RLOOP2              LDA      $C96E 
                    CMPA     #$00 
                    BNE      RLOOP3 
                    JMP      RSTART 

RLOOP3              JMP      RNEWLEV 

RSOUND              PSHS     D 
                    PSHS     X 
                    PSHS     Y 
                    LDU      #RSDAT1 
                    JSR      $F27D 
                    PULS     Y 
                    PULS     X 
                    PULS     D 
                    RTS      

RSOUND1             LDA      $C986 
                    CMPA     #$00 
                    BEQ      RSOUN10 
                    JSR      REXTRA 
                    RTS      

RSOUN10             LDB      $C983 
                    CMPB     #$00 
                    BEQ      RSOUN1A 
                    LDA      #$00 
                    JSR      $F256 
                    INC      $C983 
                    INC      $C983 
                    INC      $C983 
                    INC      $C983 
                    INC      $C983 
                    INC      $C983 
                    LDA      $C983 
                    CMPA     #$90 
                    BMI      RSOUN1A 
                    LDA      #$00 
                    STA      $C983 
                    LDD      #$0000 
                    JSR      $F256 
RSOUN1A             LDB      $C97B 
                    CMPB     #$00 
                    BNE      RSOUND2 
                    BRA      RSOUND3 

RSOUND2             LDA      #$00 
                    JSR      $F256 
                    INC      $C97B 
                    INC      $C97B 
                    INC      $C97B 
                    INC      $C97B 
                    LDA      $C97B 
                    CMPA     #$72 
                    BMI      RSOUND3 
                    LDA      #$00 
                    STA      $C97B 
                    LDD      #$0000 
                    JSR      $F256 
RSOUND3             JSR      RSHI 
                    LDA      $C960 
                    CMPA     #$00 
                    BEQ      RSSSSS 
                    JMP      RSSOUN 

RSSSSS              JSR      RSCHK 
                    INC      $C97D 
                    LDA      $C97D 
                    CMPA     $C97E 
                    BMI      RSOUND5 
                    CMPA     $C97F 
                    BNE      RSOUN3B 
                    LDA      #$00 
                    STA      $C97D 
                    INC      $C97C 
                    RTS      

RSOUN3B             LDA      $C97C 
                    CMPA     #$02 
                    BNE      RSOUN3A 
                    LDA      #$00 
                    STA      $C97C 
RSOUN3A             LDB      #$E0 
                    CMPA     #$01 
                    BPL      RSOUND4 
                    LDB      #$FF 
RSOUND4             LDA      #$02                 ;*02 
                    JSR      $F256 
                    LDA      #$03 
                    LDB      #$03 
                    JSR      $F256 
                    RTS      

RSOUND5             LDD      #$0200 
                    JSR      $F256 
                    LDD      #$0300 
                    JSR      $F256 
                    RTS      

REXTRA              LDA      $C987 
                    CMPA     #$00 
                    BPL      REXTRA2 
                    LDD      #$0200 
                    BRA      REXTRA3 

REXTRA2             LDB      #$20 
                    LDA      #$02 
REXTRA3             JSR      $F256 
                    LDA      #$03 
                    LDB      #$00 
                    JSR      $F256 
                    LDA      $C987 
                    ADDA     #$20 
                    STA      $C987 
                    RTS      

RSSOUN              LDA      #$02                 ;SAUCER WARBLING SOUND 
                    LDB      $C981 
                    JSR      $F256 
                    LDA      $C960 
                    CMPA     #$01 
                    BNE      RSPL1 
                    LDD      #$0301 
                    BRA      RSPL2 

RSPL1               LDD      #$0300 
RSPL2               JSR      $F256 
                    LDA      $C982 
                    CMPA     #$01 
                    BEQ      RSSOUN2 
                    INC      $C981 
                    INC      $C981 
                    INC      $C981 
                    INC      $C981 
                    INC      $C981 
                    BRA      RSSOUN3 

RSSOUN2             DEC      $C981 
                    DEC      $C981 
                    DEC      $C981 
                    DEC      $C981 
                    DEC      $C981 
RSSOUN3             LDA      $C981 
                    CMPA     #$B0 
                    BMI      RSSOUN4 
                    LDA      #$00 
                    STA      $C982 
                    RTS      

RSSOUN4             CMPA     #$C5 
                    BPL      RSSOUN5 
                    LDA      #$01 
                    STA      $C982 
RSSOUN5             RTS      

RSCHK               LDA      $C980 
                    CMPA     #$01 
                    BPL      RSCHKS 
                    LDA      $C95C 
                    CMPA     #$04 
                    BPL      RSCHK0 
                    LDA      #$08 
                    STA      $C97E 
                    ADDA     #$02 
                    STA      $C97F 
                    RTS      

RSCHK0              LDA      #$10 
                    STA      $C97E 
                    ADDA     #$02 
                    STA      $C97F 
                    RTS      

RSCHK1              LDA      #$20 
                    STA      $C97E 
                    ADDA     #$02 
                    STA      $C97F 
                    RTS      

RSCHKS              LDA      #$34 
                    STA      $C97E 
                    ADDA     #$02 
                    STA      $C97F 
                    RTS      

RSHI                LDA      $C97D 
                    DECA     
                    DECA     
                    CMPA     $C97E 
                    BPL      RSHI1 
                    CMPA     #$FE 
                    BMI      RSHI1 
                    RTS      

RSHI1               LDA      #$00 
                    STA      $C97D 
                    RTS      

RSFIRE              LDA      $C967 
                    CMPA     #$00 
                    BNE      RCD 
                    LDA      $C960 
                    CMPA     #$02 
                    BEQ      RSFIRE0 
RSFIREA             LDA      #$28                 ;LENGTH OF FIRE 
                    STA      $C967 
                    JSR      $F511 
                    STA      $C966 
                    JSR      DPTOC8 
                    LDA      #$04                 ;FIRE SPEED 
                    LDB      $C966 
                    JSR      $F601 
                    STD      $C968 
                    JSR      DPTOD0 
                    LDD      $C95E 
                    STD      $C96A 
                    LDA      #$60 
                    STA      $C983 
                    LDA      $C96A 
                    ADDA     $C968 
                    STA      $C96A 
                    LDA      $C96B 
                    ADDA     $C969 
                    STA      $C96B 
                    LDA      $C96A 
                    ADDA     $C968 
                    STA      $C96A 
                    LDA      $C96B 
                    ADDA     $C969 
                    STA      $C96B 
RCD                 JMP      RSFIRE1 

RSFIRE0             JSR      RANDOM2 
                    CMPA     #$01 
                    BEQ      RSFIREA 
                    JSR      DPTOC8 
                    JSR      RRND3 
                    LDA      $C930 
                    SUBA     $C95E 
                    LDB      $C931 
                    SUBB     $C95F 
                    JSR      $F593 
                    SUBA     #$10 
                    SUBB     #$10 
                    LDA      #$03                 ;FIRE SPEED 
                    JSR      $F601 
                    STD      $C968 
                    JSR      DPTOD0 
                    LDA      #$24                 ;LENGTH OF FIRE 
                    STA      $C967 
                    LDD      $C95E 
                    STD      $C96A 
                    LDA      #$60 
                    STA      $C983 
                    LDA      $C96A 
                    ADDA     $C968 
                    STA      $C96A 
                    LDA      $C96B 
                    ADDA     $C969 
                    STA      $C96B 
                    JMP      RSFIRE1 

RSFIRE1             LDX      #$C96A 
                    JSR      MVD85 
                    JSR      ZAXTO7F 
                    JSR      $F2C5 
                    JSR      RES0RF 
                    LDA      $C96A 
                    ADDA     $C968 
                    STA      $C96A 
                    LDA      $C96B 
                    ADDA     $C969 
                    STA      $C96B 
                    DEC      $C967 
                    LDA      $C96F 
                    CMPA     #$00 
                    BNE      RSFIRE2              ;CHECK IF SHIP ALREADY DEAD 
                    LDA      $C985 
                    CMPA     #$00 
                    BNE      RSFIRE2              ;CHECK IF IN HYPERSPACE 
                    LDA      $C979 
                    CMPA     #$00 
                    BNE      RSFIRE2              ;CHECK IF INVINCIBLE 
                    LDD      #$0808 
                    LDY      $C96A 
                    LDX      $C930 
                    JSR      $F8FF                ;CHECK SAUCER FIRE AGAINST SHIP 
                    BLO      RSFIRE3 
RSFIRE2             RTS      

RSFIRE3             JSR      RSETDIE 
                    LDA      #$01 
                    STA      $C967 
                    RTS      

RPPP                LDX      #$01FF 
                    LDA      $CAFF 
                    CMPA     #$08 
                    BMI      RPPQ 
                    LDX      #$00FF 
RPPQ                STX      $C961 
                    RTS      

RSAUC               LDA      $C960 
                    CMPA     #$00 
                    BNE      RSAUC1 
                    LDX      $C961 
                    LEAX     -1,X 
                    STX      $C961 
                    CMPX     #$0000 
                    BNE      RSAUC0 
                    JSR      RANDOM2 
                    LDA      #$01 
                    ADDA     $C957 
                    STA      $C960 
                    JSR      RPPP 
RSM                 LDA      #$00 
                    STA      $C967 
                    JSR      $F511 
                    STA      $C95E 
                    LDD      $C95E 
                    STD      $C96A 
                    JSR      RANDOM2 
                    CMPA     #$01 
                    BEQ      RSAUC00 
                    LDA      #$82                 ;$80 
                    STA      $C95F 
                    LDA      #$01 
                    STA      $C96D 
                    LDA      #$FD 
                    STA      $C96C 
                    RTS      

RSAUC00             LDA      #$7D                 ;$7F 
                    STA      $C95F 
                    LDA      #$FF 
                    STA      $C96D 
                    LDA      #$FD 
                    STA      $C96C 
RSAUC0              RTS      

RSAUC1              JSR      RSFIRE 
                    LDA      #$60 
                    JSR      ZAXTOA 
                    LDX      #$C95E 
                    JSR      MVD85 
                    LDB      #$30 
                    LDA      $C960 
                    CMPA     #$02 
                    BNE      RSAUC2 
                    LDB      #$1A 
RSAUC2              LDX      #RSPR6 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDA      $C96D 
                    ADDA     $C95F 
                    STA      $C95F 
                    LDA      $C96F 
                    CMPA     #$00 
                    BNE      RSAUC2B              ;CHECK NOT TO COLLIDE WITH SAUCER 
                    LDX      $C930                ;IF ALREADY DEAD 
                    LDY      $C95E 
                    LDD      #$0404 
                    JSR      $F8FF 
                    BLO      RSAUC2A 
                    BRA      RSAUC2B 

RSAUC2A             JSR      RSETDIE 
                    LDA      #$00 
                    STA      $C96D 
                    STA      $C960 
                    RTS      

RSAUC2B             DEC      $C96C 
                    LDA      $C96C 
                    CMPA     #$00 
                    BNE      RSAUCN 
                    LDA      #$00 
                    STA      $C960 
                    RTS      

RSAUCN              LDA      $C95E 
                    ADDA     $C965 
                    STA      $C95E 
                    DEC      $C963 
                    LDA      $C963 
                    BNE      RSAUCZ 
                    LDA      #$20 
                    STA      $C963 
                    JSR      RNDII 
                    STA      $C965 
RSAUCZ              RTS      

RWHECK              LDA      $C95D 
                    BEQ      RWHECK0 
                    RTS      

RWHECK0             LDA      $C95C 
                    CMPA     #$00 
                    BNE      RWHECK1 
                    LDA      #$01 
                    STA      $C95D 
RWHECK1             RTS      

REXPLO              JSR      ZAXTO7F 
                    LDX      #$CAF0 
REXPLO1             LDA      $02,X 
                    CMPA     #$00 
                    BNE      REXPLO2 
REXPLO0             LEAX     3,X 
                    CMPX     #$CAFC 
                    BNE      REXPLO1 
                    RTS      

REXPLO2             PSHS     X 
                    LDD      $00,X 
                    STD      $C94B 
                    LDX      #$C94B 
                    JSR      MVD85 
                    PULS     X 
                    LDB      $02,X 
                    PSHS     X 
                    LDX      #RSPR5 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    PULS     X 
                    LDA      $02,X 
                    ADDA     #$0C 
                    STA      $02,X 
                    LDA      $02,X 
                    CMPA     #$7F 
                    BMI      REXPLO3 
                    LDA      #$00 
                    STA      $02,X 
REXPLO3             BRA      REXPLO0 

RSETX               PSHS     X 
                    LDX      #$CAF0 
RSETX0              LDA      $02,X 
                    CMPA     #$00 
                    BEQ      RSETX1 
                    LEAX     3,X 
                    CMPX     #$CAFC 
                    BNE      RSETX0 
                    PULS     X 
                    RTS      

RSETX1              LDD      $C94B 
                    STD      $00,X 
                    LDA      #$02 
                    STA      $02,X 
                    PULS     X 
                    RTS      

RCHECK              LDX      $C930                ;CHECK ASTEROID COLLISIONS W/SHIP 
                    LDY      $C94B 
                    CMPB     #$05 
                    BMI      RCHECK1 
                    LDD      #$0404 
                    BRA      RCHECK5 

RCHECK1             CMPB     #$03 
                    BMI      RCHECK2 
                    LDD      #$0808 
                    BRA      RCHECK5 

RCHECK2             LDD      #$0C0C 
RCHECK5             STD      $C9A0 
                    LDA      $C979 
                    CMPA     #$00 
                    BNE      RCHEC5Z 
                    LDA      $C96F 
                    CMPA     #$00 
                    BNE      RCHEC5Z 
                    LDA      $C97A 
                    CMPA     #$00 
                    BNE      RCHEC5Z 
                    LDD      $C9A0 
                    JSR      $F8FF 
                    BLO      RCHECK6 
RCHEC5Z             LDA      $C960 
                    CMPA     #$00 
                    BEQ      RCHEC5C 
                    LDX      $C95E 
                    LDY      $C94B 
                    LDD      $C9A0 
                    JSR      $F8FF                ;CHECK ASTEROIDS COLL W/SAUCER 
                    BLO      RCHEC5B 
RCHEC5A             RTS      

RCHEC5B             LDA      #$00 
                    STA      $C960 
                    JSR      RSOUND 
                    LDD      $C95E 
                    STD      $C94B 
                    JSR      RSETX 
RCHEC5C             RTS      

RCHECK6             JSR      RSETDIE 
                    RTS      

RROCKS              LDA      #$00 
                    STA      $C95C 
                    STA      $C980 
                    JSR      RANDOM2 
RROCK00             LDA      #$30 
                    JSR      ZAXTOA 
                    LDX      #$CA00 
RROCKS0             LDA      $04,X 
                    CMPA     #$00 
                    BNE      RROCKS2 
RROCKS1             LEAX     5,X 
                    CMPX     #$CAF0 
                    BNE      RROCKS0 
                    RTS      

RROCKS2             CMPA     #$02 
                    BPL      RROCCCC 
                    INC      $C980 
RROCCCC             INC      $C95C 
                    PSHS     X 
                    LDD      $00,X 
                    STD      $C94B 
                    LDX      #$C94B 
                    JSR      MVD85 
                    PULS     X 
                    LDA      $04,X 
                    LDB      $04,X 
                    PSHS     X 
                    PSHS     A 
                    JSR      RCHECK 
                    PULS     A 
                    CMPA     #$01 
                    BEQ      RROCKX 
                    CMPA     #$03 
                    BEQ      RROCKX 
                    CMPA     #$05 
                    BEQ      RROCKX 
                    LDX      #RSPR2 
                    BRA      RROCKY 

RROCKX              LDX      #RSPR4 
RROCKY              LDB      #$80                 ;SIZE OF ROCKS 
                    CMPA     #$01 
                    BEQ      RROCKD 
                    CMPA     #$02 
                    BEQ      RROCKD 
                    LDB      #$40 
                    CMPA     #$03 
                    BEQ      RROCKD 
                    CMPA     #$04 
                    BEQ      RROCKD 
                    LDB      #$20 
RROCKD              JSR      DRWL1B 
                    JSR      RES0RF 
                    PULS     X 
                    LDA      $04,X 
                    CMPA     #$02 
                    BPL      RBS1                 ;** 
                    LDA      $C954 
                    CMPA     #$01 
                    BNE      RROCK2A 
RBS1                LDA      $02,X 
                    ADDA     $00,X 
                    STA      $00,X 
                    LDA      $03,X 
                    ADDA     $01,X 
                    STA      $01,X 
                    LDD      $00,X 
                    STD      $C94B 
RROCK2A             PSHS     X 
                    STX      $C951 
                    LDA      $C960 
                    CMPA     #$00 
                    BEQ      RROCK2E 
                    LDD      #$0808 
                    LDY      $C96A 
                    LDX      $C94B 
                    JSR      $F8FF 
                    BLO      RROCK2B 
                    BRA      RROCK2E 

RROCK2B             JSR      RSOUND               ;SAUCER MISSILE HIT ASTEROID ? 
                    LDA      #$01 
                    STA      $C967 
                    LDD      $C96A 
                    STD      $C94B 
                    LDD      $C95E 
                    STD      $C96A 
                    JSR      RSETX 
                    LDX      $C951                ;CURRENT ROCK GETTING HIT 
                    LDA      $04,X 
                    CMPA     #$05 
                    BMI      RROCK2C              ;THIS IS A SMALL ROCK, SO 
                    LDA      #$00                 ;DESTROY IT 
                    STA      $04,X 
                    BRA      RROCK2E 

RROCK2C             JSR      RNEWRK 
RROCK2E             LDY      #$C933 
RROCKS3             LDA      $04,Y                ;CHECK COLLISIONS W/BULLETS 
                    CMPA     #$00 
                    BNE      RROCKS6              ;THIS BULLET IS ACTIVE ! 
RROCKS4             LEAY     6,Y 
                    CMPY     #$C94B 
                    BNE      RROCKS3 
RROCKS5             PULS     X 
                    JMP      RROCKS1 

RROCKS6             PSHS     Y 
                    LDD      $00,Y 
                    STD      $C94F 
                    LDA      $04,Y 
                    CMPA     #$02 
                    BPL      RROCK6A 
                    LDD      #$0A0A               ;YOUR FIRE 
                    BRA      RROCK6D 

RROCK6A             CMPA     #$04 
                    BPL      RROCK6B 
                    LDD      #$0808 
                    BRA      RROCK6D 

RROCK6B             LDD      #$0202 
RROCK6D             LDX      $C94B 
                    LDY      $C94F 
                    JSR      $F8FF 
                    PULS     Y 
                    BLO      RROCKS7 
                    BRA      RROCKS4 

RROCKS7             JSR      RSOUND 
                    LDA      #$00 
                    STA      $04,Y 
                    LDD      $00,Y 
                    STD      $C94B 
                    PSHS     Y 
                    JSR      RSETX 
                    PULS     Y 
                    LDX      $C951                ;CURRENT ROCK GETTING HIT 
                    LDA      $04,X 
                    CMPA     #$01 
                    BEQ      RROCKS9              ;THIS IS A BIG ROCK 
                    CMPA     #$02 
                    BEQ      RROCKS9              ;THIS IS A BIG ROCK 
                    CMPA     #$03 
                    BEQ      RROCKS8              ;THIS IS A MEDIUM ROCK 
                    CMPA     #$04 
                    BEQ      RROCKS8              ;THIS IS A MEDIUM ROCK 
                    LDA      #$00 
                    STA      $04,X 
                    JSR      RADD50               ;ADD 50 POINTS 
                    BRA      RROCKS4 

RROCKS8             JSR      RADD20               ;ADD 20 POINTS 
                    BRA      RROCK10 

RROCKS9             JSR      RADD10               ;ADD 10 POINTS 
RROCK10             JSR      RNEWRK 
                    BRA      RROCKS4 

RNEWRK              LDX      $C951 
                    LDA      $04,X 
                    CMPA     #$03 
                    BMI      RNEWRK1              ;THIS WAS A BIG ROCK, SO MAKE A 
                    LDA      #$05                 ;MEDIUM NOW 
                    ADDA     $C957 
                    BRA      RNEWRK2 

RNEWRK1             LDA      #$03 
                    ADDA     $C957 
RNEWRK2             STA      $04,X 
                    PSHS     Y 
                    JSR      RNEWGT               ;GET A NEW ROCK 
                    LDD      $00,X 
                    STD      $00,Y 
                    LDA      $04,X 
                    JSR      RINVT 
                    STA      $04,Y 
                    JSR      RRND3 
                    STA      $02,X 
                    JSR      RRND3 
                    STA      $03,X 
                    JSR      RRND3 
                    STA      $02,Y 
                    JSR      RRND3 
                    STA      $03,Y 
                    LDD      $02,X 
                    JSR      RCOMP 
                    STD      $02,X 
                    LDD      $02,Y 
                    JSR      RCOMP 
                    STD      $02,Y 
                    PULS     Y 
                    RTS      

RINVT               CMPA     #$01 
                    BNE      RINVT1 
                    LDA      #$02 
                    RTS      

RINVT1              CMPA     #$02 
                    BNE      RINVT2 
                    LDA      #$01 
                    RTS      

RINVT2              CMPA     #$03 
                    BNE      RINVT3 
                    LDA      #$04 
                    RTS      

RINVT3              CMPA     #$04 
                    BNE      RINVT4 
                    LDA      #$03 
                    RTS      

RINVT4              CMPA     #$05 
                    BNE      RINVT5 
                    LDA      #$06 
                    RTS      

RINVT5              LDA      #$05 
                    RTS      

RNEWGT              NOP                           ;THIS GETS AN EMPTY LOCATION 
                    LDY      #$CA00               ;FOR A NEW ROCK 
RNEWGT1             LDA      $04,Y 
                    CMPA     #$00                 ;WARNING ! IF ALL LOCATIONS ARE 
                    BEQ      RNEWGT2              ;IN USE IT WILL PROBABLY CAUSE 
                    LEAY     5,Y                  ;A SMALL MESS ! 
                    CMPY     #$CAF0 
                    BNE      RNEWGT1 
RNEWGT2             RTS      

RCOMP               CMPA     #$00                 ;THIS COMPARES 'A' AND 'B' 
                    BNE      RCOMPZ               ;IF A=0 AND B=0 THEN IT RE-ASSIGNS 
                    CMPB     #$00                 ;A VALUE OF 1 TO A 
                    BNE      RCOMPZ 
                    LDA      #$01 
RCOMPZ              RTS      

RINPUT              LDA      $C985 
                    CMPA     #$00 
                    BEQ      RINP000 
                    LDA      #$01 
                    STA      $C979                ;TURN ON INVINCIBILITY TO 
                    DEC      $C985                ;PREVENT COLLISIONS 
                    LDA      $C985 
                    CMPA     #$00 
                    BNE      RCOMPZ 
                    JSR      RNEWS 
                    JSR      $F511 
                    STA      $C930 
                    STA      $C9A5 
                    JSR      $F511 
                    STA      $C931 
                    STA      $C9A7 
                    LDA      #$00 
                    STA      $C979                ;TURN OFF INVINCIBILITY 
                    JSR      RNDII 
                    CMPA     #$01 
                    BNE      RINP000 
                    JSR      RSETDIE 
                    RTS      

RINP000             JSR      RDOJOY 
                    LDA      $C81C 
                    CMPA     #$00 
                    BEQ      RINP001 
                    LDA      $C984 
                    CMPA     #$01 
                    BEQ      RINPUT0 
                    LDA      $C81C 
                    CMPA     #$FF 
                    BPL      RINPUT0 
                    LDA      #$70 
                    STA      $C985 
                    LDA      #$01 
                    STA      $C984 
                    BRA      RINPUT0 

RINP001             LDA      #$00 
                    STA      $C984 
RINPUT0             JSR      MDOSWTS 
RINPUT2             TST      SW14 
                    BEQ      RINPUT3 
                    LDA      $C94D 
                    CMPA     #$01 
                    BEQ      RINPUT4 
                    LDA      #$01 
                    STA      $C94D 
                    JSR      RSETFR 
                    BRA      RINPUT4 

RINPUT3             LDA      #$00 
                    STA      $C94D 
RINPUT4 
RPLAY               TST      SW11 
                    BEQ      RPLAY1 
                    INC      $C932 
RPLAY1              TST      SW12 
                    BEQ      RPLAY4 
                    DEC      $C932 
RPLAY4              TST      SW13 
                    BEQ      RNOMOVE 
                    LDD      #$02FF 
                    JSR      $F256 
                    LDD      #$0303 
                    JSR      $F256 
                    INC      $C9C0 
                    LDA      $C9C0 
                    CMPA     #$04 
                    BMI      RNOMOVE 
                    LDA      #$00 
                    STA      $C9C0 
                    LDA      #$02 
                    STA      $C9C1 
                    lda      $C932 
                    cmpa     $C9B3 
                    beq      RE2A0 
                    cmpa     $C9B5 
                    beq      RPLAY5 
                    lda      $C9B2 
                    beq      RE2A0 
                    lda      $C9B4 
                    bne      RNOMOVE 
RPLAY5              lda      $C9B4 
                    adda     #$0C                 ;0C 
                    cmpa     #$7F 
                    bhi      RNOMOVE 
                    sta      $C9B4 
                    lda      $C932 
                    sta      $C9B5 
                    bra      RNOMOVE 

RE2A0               lda      $C9B2 
                    adda     #$0C                 ;0C 
                    cmpa     #$7F 
                    bhi      RNOMOVE 
                    sta      $C9B2 
                    lda      $C932 
                    sta      $C9B3 
RNOMOVE             LDA      #$00 
                    INC      $C9C1 
                    LDB      $C9C1 
                    CMPB     #$03 
                    BNE      RNO1 
                    LDB      #$00 
                    STB      $C9C1 
                    LDA      #$02 
RNO1                STA      $C9C2 
                    LDA      $C9B2 
                    beq      RE2C2 
                    suba     $C9C2                ;02,01 
                    sta      $C9B2 
                    ldb      $C9B3 
                    jsr      RCALC 
                    sty      $C9A9 
                    stx      $C9AB 
RE2C2               lda      $C9B4 
                    beq      RE2D4 
                    suba     $C9C2                ;02,01 
                    sta      $C9B4 
                    ldb      $C9B5 
                    jsr      RCALC 
                    sty      $C9AD 
                    stx      $C9AF 
RE2D4               ldd      $C9A5 
                    addd     $C9A9 
                    addd     $C9AD 
                    std      $C9A5 
                    ldd      $C9A7 
                    addd     $C9AB 
                    addd     $C9AF 
                    std      $C9A7 
                    LDA      $C9A5 
                    STA      $C930 
                    LDA      $C9A7 
                    STA      $C931 
                    RTS      

RCALC               PSHS     A 
                    LDA      #$C8 
                    TFR      A,DP 
                    LDA      $CAFD 
                    PULS     A 
                    pshs     a,b,x,y 
                    jsr      $F601 
                    sta      4,s 
                    sex      
                    aslb     
                    rola     
                    aslb     
                    rola     
                    aslb     
                    rola     
                    std      2,s 
                    ldb      4,s 
                    sex      
                    aslb     
                    rola     
                    aslb     
                    rola     
                    aslb     
                    rola     
                    std      4,s 
                    LDA      #$D0 
                    TFR      A,DP 
                    puls     a,b,x,y,pc 
                    RTS      

RFIRE               JSR      ZAXTO7F 
                    LDX      #$C933 
RFIRE0              LDA      $04,X 
                    CMPA     #$01 
                    BEQ      RFIRE1 
RFIRE0A             LEAX     6,X 
                    CMPX     #$C94B 
                    BNE      RFIRE0 
                    RTS      

RFIRE1              LDD      $00,X 
                    STD      $C94B 
                    PSHS     X 
                    LDX      #$C94B 
                    JSR      MVD85 
                    JSR      $F2C5 
                    JSR      RES0RF 
                    PULS     X 
                    LDD      $00,X 
                    STD      $C94F 
                    STX      $C951 
                    LDA      $C960 
                    CMPA     #$00 
                    BEQ      RFIRE2 
                    LDX      $C94F 
                    LDY      $C95E 
                    LDD      #$0606 
                    JSR      $F8FF 
                    BLO      RFIRE3 
                    BRA      RFIRE2 

RFIRE3              LDD      $C95E 
                    STD      $C94B 
                    LDB      $C960 
                    LDA      #$00 
                    STA      $C960 
                    JSR      RSOUND 
                    PSHS     B 
                    JSR      RSETX 
                    JSR      RADD200 
                    PULS     B 
                    CMPB     #$01 
                    BEQ      RFIRE4 
                    JSR      RADD800 
RFIRE4              LDX      $C951 
                    LDA      #$00 
                    STA      $04,X 
RFIRE2              LDX      $C951 
                    LDA      $02,X 
                    ADDA     $00,X 
                    STA      $00,X 
                    LDA      $03,X 
                    ADDA     $01,X 
                    STA      $01,X 
                    INC      $05,X 
                    LDA      $05,X 
                    CMPA     #$26                 ;LENGTH OF FIRE 
                    BNE      RFIRE0A 
                    LDA      #$00 
                    STA      $04,X 
                    BRA      RFIRE0A 

RSETFR              LDX      #$C933 
RSETFR0             LDA      $04,X 
                    CMPA     #$00 
                    BEQ      RSETFR1              ;FOUND AN EMPTY MISSILE TO USE ! 
                    LEAX     6,X 
                    CMPX     #$C94B 
                    BNE      RSETFR0 
                    RTS      

RSETFR1             PSHS     X 
                    LDA      #$40                 ;MAKE A FIRING SOUND 
                    STA      $C97B 
                    PULS     X 
                    LDD      $C930 
                    STD      $00,X 
                    LDA      #$01 
                    STA      $04,X 
                    STA      $05,X 
                    JSR      DPTOC8 
                    LDB      $C932 
                    LDA      #$05                 ;04 
                    PSHS     X 
                    JSR      $F601 
                    PULS     X 
                    STD      $02,X 
                    LDA      $02,X 
                    ADDA     $00,X 
                    STA      $00,X 
                    LDA      $03,X 
                    ADDA     $01,X 
                    STA      $01,X 
                    JSR      DPTOD0 
                    RTS      

RDRAW               LDA      $C985 
                    CMPA     #$00 
                    BEQ      RDRAWA 
                    RTS      

RDRAWA              LDA      #$60 
                    LDB      $C979 
                    CMPB     #$00 
                    BEQ      RDRAWE 
                    INC      $C979 
                    LDA      $C9C3 
                    ADDA     #$08 
                    STA      $C9C3 
                    CMPA     #$70 
                    BMI      RDRAWD 
                    LDA      #$00 
                    STA      $C9C3 
                    LDA      #$60 
RDRAWD              LDA      $C9C3 
RDRAWE              JSR      ZAXTOA 
RDRAW00             LDX      #RSPR1 
                    LDU      #$C900 
                    LDA      $C932 
                    JSR      $F61F 
                    LDX      #$C930 
                    JSR      MVD85 
                    LDX      #$C900 
                    LDB      #$1A                 ;SHIP SIZE ? 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    TST      SW13 
                    BEQ      RDRAWB 
                    LDX      #RSPR3 
                    LDU      #$C900 
                    LDA      $C932 
                    JSR      $F61F 
                    LDX      #$C930 
                    JSR      MVD85 
                    JSR      $F511 
                    LSRA     
                    JSR      ZAXTOA 
                    LDX      #$C900 
                    LDB      #$1A 
                    JSR      DRWL1B 
                    JSR      RES0RF 
RDRAWB              RTS      

RSETDIE             JSR      RSOUND 
                    LDD      $C930 
                    STD      $C94B 
                    JSR      RSETX 
                    LDD      $C930 
                    STD      $C970 
                    STD      $C972 
                    STD      $C974 
                    STD      $C976 
                    LDA      #$01 
                    STA      $C96F 
                    STA      $C978 
                    LDA      #$00 
                    STA      $C958 
                    STA      $C9C0 
                    STA      $C9C1 
                    DEC      $C96E                ;DECREMENT SHIPS LEFT 
                    LDA      $C96E 
                    CMPA     #$00 
                    BNE      RSETDI0 
                    LDA      #$01 
                    STA      $C97A                ;OUT OF SHIPS, SET GAME OVER 
RSETDI0             RTS      

RDIE                LDA      #$40 
                    JSR      ZAXTOA 
                    LDX      #$C970 
                    JSR      MVD85 
                    LDX      #RSPR7 
                    LDB      #$20 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDX      #$C972 
                    JSR      MVD85 
                    LDX      #RSPR8 
                    LDB      #$20 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDX      #$C974 
                    JSR      MVD85 
                    LDX      #RSPR9 
                    LDB      #$20 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    LDX      #$C976 
                    JSR      MVD85 
                    LDX      #RSPR10 
                    LDB      #$20 
                    JSR      DRWL1B 
                    JSR      RES0RF 
                    INC      $C96F 
                    LDA      $C96F 
                    CMPA     #$FF 
                    BNE      RDIE0 
                    LDA      #$00 
                    STA      $C96F 
                    LDA      #$01 
                    STA      $C979 
                    JSR      RNEWS 
                    RTS      

RDIE0               INC      $C978 
                    LDA      $C978 
                    CMPA     #$07 
                    BEQ      RDIE1 
                    RTS      

RDIE1               LDA      #$00 
                    STA      $C978 
                    INC      $C970 
                    INC      $C971 
                    INC      $C971 
                    DEC      $C972 
                    DEC      $C973 
                    DEC      $C974 
                    DEC      $C974 
                    DEC      $C974 
                    INC      $C975 
                    INC      $C976 
                    DEC      $C977 
                    DEC      $C977 
                    RTS      

RRND3               PSHS     X 
                    JSR      $F511 
                    LSRA     
                    CMPA     #25 
                    BPL      RRND4 
                    LDA      #$FE 
                    BRA      RRNDZ 

RRND4               CMPA     #50 
                    BPL      RRND5 
                    LDA      #$FF 
                    BRA      RRNDZ 

RRND5               CMPA     #75 
                    BPL      RRND6 
                    LDA      #$00 
                    BRA      RRNDZ 

RRND6               CMPA     #100 
                    BPL      RRND7 
                    LDA      #$01 
                    BRA      RRNDZ 

RRND7               LDA      #$02 
RRNDZ               PULS     X 
                    RTS      

RANDOM2             INC      $C957 
                    LDA      $C957 
                    CMPA     #$02 
                    BNE      RANDOM3 
                    LDA      #$00 
                    STA      $C957 
RANDOM3             INC      $C988 
                    LDB      $C988 
                    CMPB     #$06 
                    BMI      RANDOM4 
                    LDB      #$00 
                    STB      $C988 
RANDOM4             RTS      

RNDII               JSR      $F511 
                    LSRA     
                    CMPA     #42 
                    BPL      RNDII0 
                    LDA      #$FF 
                    RTS      

RNDII0              CMPA     #84 
                    BPL      RNDII1 
                    LDA      #$00 
                    RTS      

RNDII1              LDA      #$01 
                    RTS      

RADD10              PSHS     X 
                    PSHS     Y 
                    LDD      #$0010 
                    LDX      #$C880 
                    JSR      RADD2SC 
                    BRA      RADDRTS 

RADD20              PSHS     X 
                    PSHS     Y 
                    LDD      #$0020 
                    LDX      #$C880 
                    JSR      RADD2SC 
                    BRA      RADDRTS 

RADD50              PSHS     X 
                    PSHS     Y 
                    LDD      #$0050 
                    LDX      #$C880 
                    JSR      RADD2SC 
                    BRA      RADDRTS 

RADD200             PSHS     X 
                    PSHS     Y 
                    LDD      #$0200 
                    LDX      #$C880 
                    JSR      RADD2SC 
RADDRTS             PULS     Y 
                    PULS     X 
                    RTS      

RADD800             PSHS     X 
                    PSHS     Y 
                    LDD      #$0800 
                    LDX      #$C880 
                    JSR      RADD2SC 
                    BRA      RADDRTS 

RADD2SC             JSR      $F87C 
                    LDX      #$C880 
                    LDU      #$C990 
                    JSR      $F8C7 
                    CMPA     #$01 
                    BEQ      RADD2SD 
                    RTS      

RADD2SD             INC      $C96E 
                    LDD      #$5000 
                    LDX      #$C990 
                    JSR      $F87C 
                    LDD      #$5000 
                    LDX      #$C990 
                    JSR      $F87C 
                    LDA      #$02 
                    STA      $C986 
                    RTS      

RDOJOY              LDA      #$00                 ;DO SIMPLE READING (+/0/-) 
                    STA      JOYTYP 
                    LDA      #$20 
                    STA      $C81A 
                    JSR      JOYSTK               ;READ THE STICK 
                    RTS      

RSHOWSC             LDA      #$40 
                    JSR      ZAXTOA 
                    LDD      #$7FFA               ;DISPLAY SCORE 
                    JSR      $F2FC 
                    LDU      #$C880 
                    LDD      #$FE49 
                    STD      $C82A 
                    JSR      $F495 
                    LDX      #$7FB0 
                    LDA      $C986 
                    CMPA     #$00 
                    BEQ      RSHOWS1 
                    JSR      ZAXTO7F 
                    LDD      #$FA43               ;$FE49 
                    STD      $C82A 
                    INC      $C986 
                    INC      $C986 
RSHOWS1             LDA      #$68 
                    LDB      $C96E 
                    JSR      $F393 
RSHOWS9             RTS      

RNEWS               LDA      #$00 
                    STA      $C930 
                    STA      $C931 
                    LDX      #$C9A5 
RFIL                STA      $00,X 
                    LEAX     1,X 
                    CMPX     #$C9B6 
                    BNE      RFIL 
                    RTS      

RTXT1               db       '  GAME OVER',$80
RTXT8               db       $20,$F0, '= 50 PTS',$80
                    db       $10,$F0, '= 20 PTS',$80
                    db       $F6,$F0, '= 10 PTS',$80
                    db       $D0,$F0, '= 1000 PTS',$80
                    db       $C0,$F0, '=  200 PTS',$80
                    db       $70,$B2, 'ROCKAROIDS REMIX:',$80
                    db       $60,$BF, 'ROCK FASTER !',$80
                    db       $50,$90, 'g 1996 BY JOHN DONDZILA',$80
                    db       $90,$96, 'ROCK IT WITH BUTTON 4 !',$80,$00
RTXT13              db       $31,$96, 'BTN # 1 = ROTATE LEFT',$80
                    db       $21,$96, 'BTN # 2 = ROTATE RIGHT',$80
                    db       $11,$96, 'BTN # 3 = THRUST',$80
                    db       $01,$96, 'BTN # 4 = FIRE',$80
                    db       $C0,$8D, 'STICK DOWN FOR HYPERSPACE',$80
                    db       $90,$9A, 'BONUS EVERY 10000 PTS',$80,$00
RSPR1               fcb      $FF, $FA, $F0 
                    fcb      $FF, $F8, $6 
                    fcb      $FF, $0, $14 
                    fcb      $FF, $8, $6 
                    fcb      $FF, $6, $F0 
                    fcb      $00, $F2, $F6 
                    fcb      $FF, $1E, $A 
                    fcb      $FF, $E2, $A 
                    fcb      1 
IDC                 db       'K'
RSPR2               fcb      $FF, $A, $F8 
                    fcb      $FF, $F2, $F8 
                    fcb      $FF, $F8, $A 
                    fcb      $FF, $0, $A 
                    fcb      $FF, $6, $6 
                    fcb      $FF, $A, $0 
                    fcb      $FF, $FC, $F6 
                    FCB      1 
RSPR3               fcb      $00, $F2, $A 
                    fcb      $FF, $FA, $F6 
                    fcb      $FF, $6, $F6 
                    fcb      1 
RSPR4               fcb      $00, $C, $FE 
                    fcb      $FF, $FA, $F8 
                    fcb      $FF, $FC, $2 
                    fcb      $FF, $FA, $FA 
                    fcb      $FF, $F8, $E 
                    fcb      $FF, $8, $A 
                    fcb      $FF, $A, $0 
                    fcb      $FF, $6, $F4 
                    fcb      1 
RSPR5               fcb      $00, $6, $FA 
                    fcb      $FF, $0, $0 
                    fcb      $00, $FE, $C 
                    fcb      $FF, $00, $0 
                    fcb      $00, $FA, $2 
                    fcb      $FF, $00, $0 
                    fcb      $00, $0, $F6 
                    fcb      $FF, $00, $0 
                    fcb      $00, $FE, $FC 
                    fcb      $FF, $00, $0 
                    fcb      1 
RSPR6               fcb      $00, $0, $10 
                    fcb      $FF, $F8, $F8 
                    fcb      $FF, $0, $F0 
                    fcb      $FF, $8, $F8 
                    fcb      $FF, $0, $20 
                    fcb      $FF, $C, $F4 
                    fcb      $FF, $0, $F8 
                    fcb      $FF, $F4, $F4 
                    fcb      $00, $8, $8 
                    fcb      $FF, $0, $10 
                    fcb      1 
RSPR7               fcb      $FF, $C, $6 
                    fcb      $FF, $FA, $4 
                    fcb      1 
RSPR8               fcb      $FF, $EA, $A 
                    fcb      $FF, $6, $F6 
                    fcb      1 
RSPR9               fcb      $FF, $4, $FC 
                    fcb      $FF, $FA, $F8 
                    fcb      1 
RSPR10              fcb      $FF, $FC, $FA 
                    fcb      $FF, $12, $8 
                    fcb      1 
RSDAT1              fcb      $00,$0 
                    fcb      $01,$0 
                    fcb      $04,$00 
                    fcb      $05,$00 
                    fcb      $06,$1F 
                    fcb      $07,$1C              ;1C 
                    fcb      $08,$0F 
                    fcb      $09,$0F              ;0F 
                    fcb      $0A,$10 
                    fcb      $0B,$10 
                    fcb      $0C,$10 
                    fcb      $0D,$00 
                    fcb      $0E,$20 
                    fcb      $FF 
RSDAT2              fcb      $00,$0 
                    fcb      $01,$0 
                    fcb      $02,$00 
                    fcb      $03,$00 
                    fcb      $04,$00 
                    fcb      $05,$00 
                    fcb      $07,$1C              ;1C 
                    fcb      $08,$0F 
                    fcb      $09,$0F              ;0F 
                    fcb      $0A,$10 
                    fcb      $0B,$10 
                    fcb      $0C,$10 
                    fcb      $0D,$00 
                    fcb      $0E,$20 
                    fcb      $FF 
MDOSWTS             CLRA                          ;NORMAL SWITCH MODE 
                    JSR      SWITCHS              ;READ SWITCHES 
                    RTS      

MJOYSET             LDX      #JOYENS 
                    LDA      #1                   ;CONSOLE 1, LEFT/RIGHT 
                    STA      ,X+ 
                    LDA      #3                   ;CONSOLE 1, UP/DOWN 
                    STA      ,X+ 
                    CLRA                          ;IGNORE THE OTHER TWO 
                    STA      ,X+ 
                    STA      ,X+ 
                    RTS      
