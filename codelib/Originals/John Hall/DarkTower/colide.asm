;
;
;         IF      L.COLD = OFF     ;-------------------------------------------
;         LIST    -L               ;--  COLIDE  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  COLLISION HANDLER
;  =================
;
         direct   $C8
;        =====   ===
;
COLIDE   PSHS    DP               ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
;
         LDU     #FLMTBL          ;  SCAN FLAMOID TABLE
         LDA     #FLMCNT          ;  .
         STA     TEMP1            ;  .
;
CLID1    LDA     <<FLMFLG,U         ;  IS FLAMOID ACTIVE ?
         LBEQ    CLID6            ;  .
         LDA     FLMYW,U          ;  .    FORM FLAMOID POSITION
         LDB     FLMXW,U          ;  .    .
         STD     ETMP1            ;  .    .
;
         LDA     <<FLMFLG,U         ;  WARRIOR VS. FLAMOID COLLISION ?
         BITA    #$40             ;  .    SKIP TEST AGAINST WARRIOR ?
         BNE     CLID2            ;  .    .
         LDA     WARFLG           ;  .    HAS THE WARRIOR BEEN KILLED ALREADY ?
         BEQ     CLID2            ;  .    .
;
         LDX     ETMP1            ;  .    FETCH FLAMOID POSITION
         LDA     WARYW            ;  .    FETCH WARRIOR POSITION
         LDB     WARXW            ;  .    .    PROJECTED 'X'
         TFR     D,Y              ;  .    .
         LDD     #$0202           ;  .    SET WARRIOR COLLISION BOX
         JSR     BXTEST           ;  .    PERFORM BOX TEST
         BCC     CLID2            ;  .    .
;
         PSHS    X,Y,U            ;  .    COLLISION DETECTED
         CLRB                     ;  .    .    SET-UP WARRIOR FRAGMENT #1
         LDA     WARSCY           ;  .    .    .
         TFR     D,Y              ;  .    .    .
         LDA     WARSCX           ;  .    .    .
         TFR     D,X              ;  .    .    .
         LDA     #$3F             ;  .    .    .
         LDU     #EXWAR1          ;  .    .    .
         JSR     SETEXP           ;  .    .    .
         LDU     #EXWAR2          ;  .    .    SET-UP WARRIOR FRAGMENT #2
         JSR     SETEXP           ;  .    .    .
         LDU     #EXWAR3          ;  .    .    SET-UP WARRIOR FRAGMENT #3
         JSR     SETEXP           ;  .    .    .
         LDU     #EXWAR4          ;  .    .    SET-UP WARRIOR FRAGMENT #4
         JSR     SETEXP           ;  .    .    .
         CLR     WARFLG           ;  .    .    KILL WARRIOR
         LDA     #$7F             ;  .    .    .    SET-UP TIMER
         STA     TMR1             ;  .    .    .    .
         INC     EXPEND           ;  .    .    SET EXPLOSION FLAG
         LDA     #$80             ;  .    .    SET EXPLOSION SOUND FLAG
         STA     EXPWAR           ;  .    .    .
         PULS    X,Y,U            ;  .    .
         JMP     CLID5            ;  .    .    RESET THIS FLAMOID
;
;
CLID2    LDX     ETMP1            ;  COMPARE FLAMOID AGAINST WALLS
         LDY     #$52E0           ;  .    CHECK LEFT-FRONT WALL
         LDD     #$030A           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         LBCS    CLID5            ;  .    .    .
;
         LDX     ETMP1            ;  .    CHECK LEFT-MIDDLE WALL
         LDY     #$5EE8           ;  .    .    SET WALL POSITION
         LDD     #$0306           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         LBCS    CLID5            ;  .    .    .
;
         LDX     ETMP1            ;  .    CHECK LEFT-REAR WALL
         LDY     #$66E8           ;  .    .    SET WALL POSITION
         LDD     #$0309           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         LBCS    CLID5            ;  .    .    .
;
         LDX     ETMP1            ;  .    CHECK RIGHT-FRONT WALL
         LDY     #$5218           ;  .    .    SET WALL POSITION
         LDD     #$0302           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         LBCS    CLID5            ;  .    .    .
;
         LDX     ETMP1            ;  .    CHECK RIGHT-MIDDLE WALL
         LDY     #$5E18           ;  .    .    SET WALL POSITION
         LDD     #$0306           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         LBCS    CLID5            ;  .    .    .
;
         LDX     ETMP1            ;  .    CHECK RIGHT-REAR WALL
         LDY     #$6618           ;  .    .    SET WALL POSITION
         LDD     #$0308           ;  .    .    SET BOX SIZE
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         BCS     CLID5            ;  .    .    .
;
;
         LDY     #BRGTBL          ;  SCAN BRIGAND TABLE
         LDA     #BRGCNT          ;  .
         STA     TEMP2            ;  .
;
;
CLID3    LDA     <<BRGFLG,Y         ;  IS BRIGAND ENTRY ACTIVE ?
         BPL     CLID4            ;  .
;
         LDX     #BRGVIS          ;  IS BRIGAND VISIBLE ?
         LDA     BRGTMR,Y         ;  .
         LDA     A,X              ;  .
         BEQ     CLID4            ;  .
;
         LDA     <<FLMFLG,U         ;  IS THIS FLAMOID BRIGAND LAUNCHED ?
         BITA    #$40             ;  .
         BEQ     CLID4            ;  .
;
         PSHS    Y,U              ;  .
         LDX     BRGPTR,Y         ;  .
         LDA     BRGHTY,X         ;  .
         LDB     BRGHTX,X         ;  .
         LDX     BRGBOX,X         ;  .
         PSHS    X                ;  .
         TFR     D,Y              ;  .
         LDA     FLMYW,U          ;  .    FETCH FLAMOID POSITION
         LDB     FLMXW,U          ;  .    .
         TFR     D,X              ;  .    .
         PULS    D                ;  .
         JSR     BXTEST           ;  .    PERFORM BOX TEST
         PULS    Y,U              ;  .    .
         BCC     CLID4            ;  .    . 
;
         PSHS    Y,U              ;  .    COLLISION DETECTED
         LDX     BRGPTR,Y         ;  .    .    SET-UP BRIGAND FRAGMENT #1
         LDY     <<BRGYW,X          ;  .    .    .
         LDA     BRGSIZ,X         ;  .    .    .
         LDX     BRGXW,X          ;  .    .    .
         LDU     #EXBRG1          ;  .    .    .
         JSR     SETEXP           ;  .    .    .
         LDU     #EXBRG2          ;  .    .    SET-UP BRIGAND FRAGMENT #2
         JSR     SETEXP           ;  .    .    .
         LDU     #EXBRG3          ;  .    .    SET-UP BRIGAND FRAGMENT #3
         JSR     SETEXP           ;  .    .    .
         PULS    Y,U              ;  .    .
         CLR     <<FLMFLG,U         ;  .    .    KILL WARRIOR
         LDX     #PLYSCR          ;  .    .    ADD VALUE TO PLAYERS SCORE
         LDD     #$0125           ;  .    .    .
         JSR     SCRADD           ;  .    .    .
         INC     EXPEND           ;  .    .    SET EXPLOSION FLAG
         LDA     #$80             ;  .    .    SET EXPLOSION SOUND FLAG
         STA     EXPBRG           ;  .    .    .
;
;
         CLR     <<BRGFLG,Y         ;  RESET CURRENT BRIGAND
         DEC     CBXAMT           ;  .    DECREMENT BRIGAND COUNTER
         LDA     #$01             ;  .    SET LAST GOBLIN KILLED FLAG
         STA     GBLKIL           ;  .    .
;
;
CLID4    LEAY    BRGLEN,Y         ;  BUMP TO NEXT BRIGAND ENTRY
         DEC     TEMP2            ;  .
         BNE     CLID3            ;  .
;
         BRA     CLID6 
;
;
CLID5    CLR     <<FLMFLG,U         ;  RESET CURRENT FLAMOID
;
;
CLID6    LEAU    FLMLEN,U         ;  BUMP TO NEXT FLAMOID ENTRY
         DEC     TEMP1            ;  .
         LBNE    CLID1            ;  .
;
         PULS    DP,PC            ;  RETURN TO CALLER
;
;         IF      L.COLD = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
