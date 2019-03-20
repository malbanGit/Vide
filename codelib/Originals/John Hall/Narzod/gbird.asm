;
;
;         IF      L.BRD = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GBIRD  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  WAR-BIRD GAME LOGIC
;  ===================
;
         direct   $C8
;        =====   ===
;
GBIRD    LDA     #BIRDS           ;  FIND ACTIVE WAR-BIRD
         STA     TEMP1            ;  .
         LDU     #BRDTBL          ;  .
;
BRD1     LDA     BRDFLG,U         ;  .    WAR-BIRD ACTIVE ?
         LBEQ    NXTBRD           ;  .    .
         LBMI    BDYING           ;  .    .    WAR-BIRD SHIELD MODE ?
;
         JSR     MOVOBJ           ;  CALCULATE NEW WAR-BIRD POSITION
         LBCS    BRD3             ;  .    MOVED OFF-SCREEN ?
;
         LDA     BRDXW,U          ;  .    CHECK FOR MARGIN CROSS-OVER
         LDB     BRDXD,U          ;  .    .    MOVING RIGHT OR LEFT ?
         BPL     BRD11A           ;  .    .    .
;
         CMPA    #$A0             ;  .    .    OUTSIDE LEFT MARGIN ?
         BLT     BRD11            ;  .    .    .
         BRA     BRD11B           ;  .    .    .
;
BRD11A   CMPA    #$60             ;  .    .    OUTSIDE RIGHT MARGIN ?
         BGT     BRD11            ;  .    .    .
;
BRD11B   DEC     BRDTMR,U         ;  MOTION TIME-OUT ?
         BNE     BRD12            ;  .
;
BRD11    JSR     RANDOM           ;  SET NEW DIRECTION AND TIME
         ANDA    #$3F             ;  .    SET NEW TIMER VALUE
         ORA     #$20             ;  .    .
         STA     BRDTMR,U         ;  .    .
;
         LDA     BRDANG,U         ;  .    SET NEW MOTION ANGLE
         JSR     LRCONE           ;  .    .
         STA     BRDANG,U         ;  .    .
;
         JSR     RANDOM           ;  .    CALCULATE NEW DISPLACEMENTS
         ANDA    #$3F             ;  .    .    SET NEW VELOCITY
         ORA     #$10             ;  .    .    .
         JSR     CALDSP           ;  .    .
;
         LDA     #$80             ;  .    SET WAR-BIRD CRY
         STA     SQUAWK           ;  .    .
;
;
         LDA     GAMCMD           ;  FIRE WAR-BIRD CANNON AT BLASTER
         ANDA    #$80             ;  .    CANNON DISABLED ?
         BEQ     BRD12            ;  .    .
;
         LDY     #WARBLT          ;  .    SET-UP FOR CANNON FIRE
         LDA     #$04             ;  .    .
         STA     TEMP9            ;  .    .
;
BRD80    LDA     BLTFLG,Y         ;  .    BULLET ACTIVE ?
         BEQ     BRD82            ;  .    .
;
         LEAY    BLTLEN,Y         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP9            ;  .    .
         BNE     BRD80            ;  .    .
         BRA     BRD12            ;  .    NO ROOM FOR NEW BULLETS
;
BRD82    PSHS    Y,U              ;  .    SET-UP FOR NEW BULLET
;
         LDD     BLSTYX           ;  .    AIM BULLET AT BLASTER
         SUBA    BRDYW,U          ;  .    .    CALCULATE DELTA 'YX'
         SUBB    BRDXW,U          ;  .    .    .
         JSR     CMPASS           ;  .    .    CALCULATE ANGLE TO SHIP
         SUBA    #$10             ;  .    .    .
         CMPA    #$14             ;  .    .    .    IS ANGLE ACCEPTABLE
         BLT     BRD83            ;  .    .    .    .
         CMPA    #$2C             ;  .    .    .    .
         BLE     BRD84            ;  .    .    .    .
;
BRD83    PULS    Y,U              ;  .    .    .    CRAPPY ANGLE - SKIP IT
         BRA     BRD12            ;  .    .    .    .
;
BRD84    TFR     Y,U              ;  .    CALCULATE BULLET DISPLACEMENTS
         STA     BLTANG,U         ;  .    .    SET BULLET ANGLE
         LDA     #$7F             ;  .    .    SET BULLET SPEED
         JSR     CALDSP           ;  .    .
;
         PULS    Y,U              ;  .    SET BULLET FLAG
         LDA     #$01             ;  .    .
         STA     BLTFLG,Y         ;  .    .
;
         LDA     #$80             ;  .    SET BULLET SOUND
         STA     SHOOT            ;  .    .
;
         INC     CBLT             ;  .    INCREMENT ACTIVE BULLET COUNTER
;
         LDD     BRDYW,U          ;  .    SET WAR-BIRD POSITION
         STD     BLTYW,Y          ;  .    .
         LDD     BRDXW,U          ;  .    .
         STD     BLTXW,Y          ;  .    .
         LDD     BRDYX,U          ;  .    .
         STD     BLTYX,U          ;  .    .
;
         LDA     #$07             ;  .    SET ENERGY LEVELS
         STA     BLTERG,Y         ;  .    .
;
         LDA     #$04             ;  .    SET BOUNCE COUNTER
         STA     BLTBNC,Y         ;  .    .
;
;
BRD12    LDX     #BR_SIZ          ;  UPDATE PERSPECTIVE RELATED INFO
         LDA     BRDYW,U          ;  .    FETCH VERTICAL POSITION
         JSR     PRSPCT           ;  .    CALCULATE NEW POINTER
         STB     BRDSIZ,U         ;  .    SAVE WAR-BIRD SIZE
;
         LDX     #CL_LIM          ;  .    FETCH LEFT WALL LIMIT
         LDB     A,X              ;  .    .
         STB     TEMP2            ;  .    .
;
         LDX     #CR_LIM          ;  .    FETCH RIGHT WALL LIMIT
         LDB     A,X              ;  .    .
         STB     TEMP3            ;  .    .
;
         LDB     #$06             ;  .    SET COLLISION BOX
         STB     BRDBOX,U         ;  .    .
         LDX     #BR_BOX          ;  .    .
         LDB     A,X              ;  .    .
         STB     BRDBOX+1,U       ;  .    .
;
         LDA     BRDFLG,U         ;  .    IS WAR-BIRD OVER ROADWAY ?
         ANDA    #$BF             ;  .    .    RESET ROADWAY FLAG
         LDB     BRDXW,U          ;  .    .    LEFT WALL CHECK
         CMPB    TEMP2            ;  .    .    .
         BLT     BRD14            ;  .    .    .
         CMPB    TEMP3            ;  .    .    RIGHT WALL CHECK
         BGT     BRD14            ;  .    .    .
;
         ORA     #$40             ;  .    .    WAR-BIRD IS OVER ROADWAY
BRD14    STA     BRDFLG,U         ;  .    .    .
;
;
         PSHS    DP               ;  DISPLAY WAR-BIRD FOR THIS ENTRY
         LDA     #$D0             ;  .    SET "DP" TO I/O
         TFR     A,DP             ;  .    .
         direct   $D0              ;  .    .
;
         JSR     INT3Q            ;  .    SET WAR-BIRD INTENSITY
; 
         LDD     BRDYX,U          ;  .    DRAW LEFT-HALF OF WAR BIRD
         JSR     POSITD           ;  .    .
         LDX     #PBIRDL          ;  .    .    SELECT ANIMATION FRAME
         LDA     FRAME            ;  .    .    .    FETCH FRAME COUNT
         LSRA                     ;  .    .    .
         LSRA                     ;  .    .    .
         ANDA    #$06             ;  .    .    .
         PSHS    A                ;  .    .    .    SAVE COPY FOR OTHER SIDE
         LDX     A,X              ;  .    .    .    FETCH DUFFY POINTER
         LDA     #$08             ;  .    .
         LDB     BRDSIZ,U         ;  .    .
         JSR     TDUFFY           ;  .    .
;
         LDD     BRDYX,U          ;  .    DRAW RIGHT-HALF OF WAR BIRD
         JSR     POSITD           ;  .    .
         LDX     #PBIRDR          ;  .    .    SELECT ANIMATION FRAME
         PULS    A                ;  .    .    .    FETCH PRIOR POINTER
         LDX     A,X              ;  .    .    .    FETCH DUFFY POINTER
         LDA     #$08             ;  .    .
         LDB     BRDSIZ,U         ;  .    .
         JSR     TDUFFY           ;  .    .
         PULS    DP               ;  .    SET "DP" TO RAM
         direct   $C8              ;  .    .
;
;
NXTBRD   LEAU    BRDLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    END-OF-BIRD TABLE ?
         LBNE    BRD1             ;  .    .
;
         RTS                      ;  .    RETURN TO CALLER
;
;
BRD3     DEC     CBRD             ;  THIS ENTRY HAS MOVED OFF-SCREEN
BRD4     CLR     BRDFLG,U         ;  .    RESET WAR-BIRD ENTRY
         BRA     NXTBRD           ;  .    .
;
;
BDYING   LDA     BRDTMR,U         ;  DECAY WAR-BIRD SHIELD
         LDB     FRAME            ;  .    DECREMENT TIMER EVERY FOURTH FRAME
         ANDB    #$03             ;  .    .
         BNE     BDIE0            ;  .    .
;
         SUBA    #$01             ;  .    DECREMENT DECAY TIMER
         STA     BRDTMR,U         ;  .    .
         CMPA    #$3F             ;  .    .    END OF SHIELD DECAY ?
         BGE     BDIE0            ;  .    .    .
;
         JSR     BRDINS           ;  .    .    .    TRY TO INSERT NEW BIRD
         BRA     BRD4             ;  .    .    .    .
;
BDIE0    PSHS    DP               ;  DISPLAY WAR-BIRD SHIELD FOR THIS ENTRY
         LDB     #$D0             ;  .    SET "DP" TO I/O
         TFR     B,DP             ;  .    .
;
         JSR     INTENS           ;  .    SET WAR-BIRD SHIELD INTENSITY
;
;==========================================================================JJH
;        LDD     BRDYX,U          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #PSHLD           ;  .                               ======JJH
;        LDA     #$05             ;  .                               ======JJH
;        LDB     BRDSIZ,U         ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDY     BRDYX,U          ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDX     #PSHLD           ;  .                               ======JJH
         LDB     BRDSIZ,U         ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;==========================================================================JJH
;
         PULS    DP               ;  .    SET "DP" TO RAM
         BRA     NXTBRD           ;  .    TRY NEXT ENTRY
;
;
;         IF      L.BRD = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
