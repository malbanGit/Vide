;
;
;         IF      L.GBLN = OFF     ;-------------------------------------------
;         LIST    -L               ;--  GOBLIN  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  HANDLE GOBLIN GAME LOGIC
;  ========================
;
         direct   $D0
;        =====   ===
;
GOBLIN   LDU     #BRGTBL          ;  SET-UP TO SCAN GOBLIN TABLE
         LDA     #BRGCNT          ;  .    SET GOBLIN COUNT
         STA     TEMP1            ;  .    .
         CLR     GBLACT           ;  .    CLEAR GOBLIN ACTIVE FLAG
;
GBLN1    LDB     <<BRGFLG,U         ;  IS BRIGAND VISIBLE ?
         LBPL    GBLN7            ;  .
;
         LDA     GBLACT           ;  SET GOBLIN VISIBLE FLAG
         ORA     #$01             ;  .
         STA     GBLACT           ;  .
;
         LDY     BRGPTR,U         ;  FETCH BRIGAND PARAMETERS
;
         PSHS    Y,U,DP           ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     FRAM3            ;  MODERATE ANIMATION RATE
         BNE     GBLN5            ;  .
;
         INC     BRGTMR,U         ;  INCREMENT FRAME TIMER
;
         BITB    #$40             ;  RELEASE FLAMOID ?
         BNE     GBLN5            ;  .    HAS FLAMOID ALREADY BEEN RELEASED
;
         LDX     #BTHRW           ;  RELEASE FLAMOID ?
         LDA     BRGTMR,U         ;  .    TEST RELEASE TABLE
         LDA     A,X              ;  .    .
         BEQ     GBLN5            ;  .    .
;
         ORB     #$40             ;  RELEASE FLAMOID
         STB     <<BRGFLG,U         ;  .    SET FLAG
;
         JSR     RANDOM           ;  .    RANDOM FIRE OR DIRECTED ?
         BITA    #$70             ;  .    .
         BNE     GBLN3            ;  .    .
;
         ANDA    #$87             ;  .    RANDOM BRIGAND THROW
         BPL     GBLN2            ;  .    .
         ORA     #$F9             ;  .    .
GBLN2    ADDA    #$20             ;  .    .
         BRA     GBLN4            ;  .    .
;
GBLN3    LDA     BRGYT,Y          ;  .    DIRECTED BRIGAND THROW
         SUBA    WARYW            ;  .    .    CALCULATE DELTA 'Y'
         LDB     BRGXT,Y          ;  .    .    CALCULATE DELTA 'X'
         SUBB    WARXW            ;  .    .    .
         JSR     CMPASS           ;  .    .    CALCULATE ANGLE TO WARRIOR
         ADDA    #$10             ;  .    .    .    FUDGE ANGLE
;
GBLN4    LDX     BRGXT,Y          ;  .    SET-UP RELEASED FLAMOID
         LDB     BRGZT,Y          ;  .    .
         LDY     BRGYT,Y          ;  .    .
         JSR     SETFLM           ;  .    .
;
GBLN5    PULS    Y,U,DP           ;  SET 'DP' = I/O
         direct   $D0              ;  .
;
         LDA     BRGTMR,U         ;  FORM ANIMATION POINTER
         ASLA                     ;  .
         STA     TEMP2            ;  .
;
         LDA     BRGDRW,Y         ;  SET DRAWING FLAG
         STA     RFLAG            ;  .
;
         LDX     #TBRGN1          ;  DRAW FIRST PORTION OF BRIGAND
         LDA     TEMP2            ;  .    FETCH ANIMATION ADDRESS
         LDX     A,X              ;  .    .
         CMPX    #$FFFF           ;  .    .    SKIP THIS FRAME OF ANIMATION ?
         BEQ     GBLN7            ;  .    .    .
         CMPX    #$0000           ;  .    .    RESET BRIGAND ANIMATION ?
         BEQ     GBLN6            ;  .    .    .
;
         LDA     #$60             ;  .    SET INTENSITY
         LDB     BRGSIZ,Y         ;  .    SET SIZE
         STD     ETMP1            ;  .    .
         LEAY    <<BRGYW,Y          ;  .    SET ABSOLUTE POSITION
         STY     ETMP3            ;  .    .
         JSR     WDIFFY           ;  .    DRAW BRIGAND
;
         LDX     #TBRGN2          ;  DRAW SECOND PORTION OF BRIGAND
         LDA     TEMP2            ;  .    FETCH ANIMATION ADDRESS
         LDX     A,X              ;  .    .
         CMPX    #$FFFF           ;  .    .    SKIP THIS FRAME OF ANIMATION ?
         BEQ     GBLN7            ;  .    .    .
;
         LDD     ETMP1            ;  .    SET INTENSITY AND SIZE
         LDY     ETMP3            ;  .    SET ABSOLUTE POSITION
         JSR     WDIFFY           ;  .    DRAW BRIGAND
         BRA     GBLN7            ;  .
;
;
GBLN6    LDA     #$01             ;  RESET ANIMATION FOR THIS BRIGAND
         STA     <<BRGFLG,U         ;  .
         CLR     BRGTMR,U         ;  .    RESET ANIMATION TIMER
;
GBLN7    LEAU    BRGLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .
         LBNE    GBLN1            ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;         IF      L.GBLN = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
