;
;
;         IF      L.TMR = OFF      ;-------------------------------------------
;         LIST    -L               ;--  TIMERS  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***************************************************************
;  ***************************************************************
;  ***                                                         ***
;  ***          P R O G R A M M A B L E   T I M E R S          ***
;  ***                                                         ***
;  ***************************************************************
;  ***************************************************************
;
         direct   $C8
;        =====   ===
;
;        TIMER #1: GUARDIAN INSERTION
;        ----------------------------
;
GRDINS   PSHS    Y,U              ;  SAVE ENTRY VALUES
;
         LDA     TOTGRD           ;  END OF GUARDIAN PLANAX ?
         BEQ     GINS9            ;  .
;
         LDA     #GUARDS          ;  FIND OPENING FOR NEW GUARDIAN
         LDU     #GRDTBL          ;  .
         LDY     #SPKTBL          ;  .
;
GINS0    TST     GRDFLG,U         ;  .    GUARDIAN ACTIVE ?
         BNE     GINS2            ;  .    .
         TST     SPKFLG,Y         ;  .    SPIKER ACTIVE ?
         BEQ     GINS1            ;  .    .
;
GINS2    LEAU    GRDLEN,U         ;  .    SKIP THIS ENTRY
         LEAY    SPKLEN,Y         ;  .    .
         DECA                     ;  .    .
         BNE     GINS0            ;  .    .
         BRA     GINS8            ;  .    ALL GUARDIANS ARE ACTIVE
;
GINS1    LDA     GRDTYP           ;  ENTER NEW GUARDIAN ENTRY
         STA     GRDFLG,U         ;  .
         LDA     #$80             ;  .    ENABLE SPIKER FOR NEW GUARDIAN
         STA     SPKFLG,Y         ;  .    .
;
         LDD     #$5A00           ;  SET INITIAL GUARDIAN AND SPIKER POSITION
         STD     GRDYW,U          ;  .    'Y' POSITION
         STD     SPKYW,Y          ;  .    .
         LDD     #$0000           ;  .    'X' POSITION
         STD     GRDXW,U          ;  .    .
         STD     SPKXW,Y          ;  .    .
;
         JSR     RANDOM           ;  SET INITIAL GUARDIAN TIMER
         ANDA    #$3F             ;  .
         ADDA    #$02             ;  .    SET MINIMUM TIME
         STA     GRDTMR,U         ;  .
;
         LDA     #$07             ;  SET INITIAL ENERGY LEVELS
         STA     GRDERG,U         ;  .
;  
         LDX     #G_SIZ           ;  SET GUARDIAN / SPIKER SIZE
         LDA     GRDYW,U          ;  .
         JSR     PRSPCT           ;  .
         STB     GRDSIZ,U         ;  .
         STB     SPKSIZ,Y         ;  .
;
         LDD     GUARDY           ;  SET GUARDIAN / SPIKER 'Y' DISPLACEMENT
         STD     GRDYD,U          ;  .
         STD     SPKYD,Y          ;  .
;
         LDD     GUARDX           ;  SET GUARDIAN / SPIKER 'X' DISPLACEMENT
         STD     GRDXD,U          ;  .
         STD     SPKXD,Y          ;  .
;
         INC     CGRD             ;  INCREMENT GUARDIAN COUNTER
         INC     CSPK             ;  INCREMENT SPIKER COUNTER
         DEC     TOTGRD           ;  DECREMENT TOTAL GUARDIAN COUNTER
;
GINS8    JSR     RANDOM           ;  RESET PROGRAMMABLE TIMER
         ANDA    #$3F             ;  .
         ADDA    #$30             ;  .    ADD INSERTION BIAS
         STA     TMR1             ;  .
;
GINS9    PULS    Y,U,PC           ;  RETURN TO SEQUENCER
;
;
;
;        TIMER #2: WAR-BIRD INSERTION
;        ----------------------------
;
BRDINS   PSHS    U                ;  SAVE ENTRY VALUES
;
         LDA     TOTBRD           ;  END OF WAR-BIRD PLANAX ?
         BEQ     BINS9            ;  .
;
         LDA     #BIRDS           ;  FIND OPENING FOR NEW WAR-BIRD
         LDU     #BRDTBL          ;  .
;
BINS0    LDB     BRDFLG,U         ;  .    WAR-BIRD ACTIVE ?
         BEQ     BINS2            ;  .    .
;
         LEAU    BRDLEN,U         ;  .    SKIP THIS ENTRY
         DECA                     ;  .    .
         BNE     BINS0            ;  .    .
         BRA     BINS8            ;  .    ALL WAR-BIRDS ARE ACTIVE
;
BINS2    LDA     #$01             ;  SET WAR-BIRD FLAG
         STA     BRDFLG,U         ;  .
;
         LDD     #$5A00           ;  SET INITIAL WAR-BIRD POSITION
         STD     BRDYW,U          ;  .    'Y' POSITION
         LDD     #$0000           ;  .    'X' POSITION
         STD     BRDXW,U          ;  .    .
;
         JSR     RANDOM           ;  SET TIMER VALUE
         ANDA    #$3F             ;  .
         ORA     #$20             ;  .
         STA     BRDTMR,U         ;  .
;
         JSR     RANDOM           ;  SET NEW MOTION ANGLE
         JSR     LRCONE           ;  .
         STA     BRDANG,U         ;  .
;
         JSR     RANDOM           ;  CALCULATE NEW DISPLACEMENTS
         ANDA    #$3F             ;  .    SET NEW VELOCITY
         ADDA    #$10             ;  .    .
         LDB     BRDANG,U         ;  .    SET NEW ANGLE
         JSR     MLTY16           ;  .
         STY     BRDYD,U          ;  .
         STX     BRDXD,U          ;  .
;
         INC     CBRD             ;  INCREMENT WAR-BIRD COUNTER
         DEC     TOTBRD           ;  DECREMENT TOTAL WAR-BIRD COUNTER
;
BINS8    JSR     RANDOM           ;  RESET PROGRAMMABLE TIMER
         ANDA    #$3F             ;  .
         ADDA    #$10             ;  .    ADD INSERTION BIAS
         STA     TMR2             ;  .
;
BINS9    PULS    U,PC             ;  RETURN TO SEQUENCER
;
;
;         IF      L.TMR = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
