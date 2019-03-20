;
;
;         IF      L.SPK = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GSPIKE  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SPIKER GAME LOGIC
;  =================
;
         direct   $C8
;        =====   ===
;
GSPIKE   LDA     FRAME            ;  ROTATE SPIKER EACH FRAME
         LSLA                     ;  .
         LSLA                     ;  .
         ANDA    #$3F             ;  .
;
;==========================================================================JJH
;        LDB     #$08             ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
         LDX     #PSPIKE          ;  .
         LDU     #RSPKR           ;  .
;
;==========================================================================JJH
         LDB     ,X+               ;  CODE ADDED - REV. B CHANGES     ======JJH
         STB     ,U+               ;  .                               ======JJH
;==========================================================================JJH
;
         JSR     DROT             ;  .
;
         LDA     LFLAG            ;  SET-UP SPIKER BOUNCE TABLE POINTER
         CMPA    #$01             ;  .    WHICH LEVEL ?
         BEQ     GSPK0            ;  .    .
;
         LDX     #SPBN0           ;  .    LEVEL'S #0 & #2
         BRA     GSPK0A           ;  .    .
;
GSPK0    LDX     #SPBN1           ;  .    LEVEL #1
GSPK0A   STX     BNCTBL           ;  .    .
;
;
         LDA     #GUARDS + 4      ;  FIND ACTIVE SPIKER
         STA     TEMP1            ;  .
         LDU     #SPKTBL          ;  .
;
GSPK1    LDA     SPKFLG,U         ;  .    SPIKER ACTIVE ?
         LBEQ    GSPK10           ;  .    .
         LBMI    GSPK10           ;  .    .    STILL HELD BY GUARDIAN ?
;
         JSR     MOVOBJ           ;  CALCULATE NEW SPIKER POSITION
         LBVS    GSPK11           ;  .    MOVED OFF-SCREEN ?
         LBCS    GSPK11           ;  .    .
         LDA     SPKYW,U          ;  .    .    SET-UP FOR SHIELD COLLISION TEST
         LDB     SPKXW,U          ;  .    .    .
         STD     TEMP4            ;  .    .    .
;
;
         PSHS    U                ;  SPIKER HITTING WAR-BIRD SHIELD ?
         LDA     #BIRDS           ;  .
         STA     TEMP2            ;  .
         LDU     #BRDTBL          ;  .
;
GSPK2    LDA     BRDFLG,U         ;  .    WAR-BIRD IN SHIELD MODE ?
         BMI     GSPK4            ;  .    .
;
GSPK3    LEAU    BRDLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .
         BNE     GSPK2            ;  .    .
         PULS    U                ;  .    CONTINUE GAME LOGIC FOR THIS SPIKER
         BRA     GSPK6            ;  .    .
;
GSPK4    LDX     TEMP4            ;  .    WAR-BIRD SHIELD FOUND
         LDY     BRDYX,U          ;  .    .    SET-UP SHIELD POSITION
         LDD     BRDBOX,U         ;  .    .    SET-UP COLLISION BOX
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         BCS     GSPK5            ;  .    .    .
         BRA     GSPK3            ;  .    .    TRY NEXT WAR-BIRD SHIELD
;
GSPK5    PULS    U                ;  .    WAR-BIRD SHIELD COLLISION DETECTED
         BRA     GSPK11           ;  .    .
;
;
GSPK6    LDX     #G_SIZ           ;  UPDATE PERSPECTIVE INFO
         LDA     SPKYW,U          ;  .    FETCH VERTICAL POSITION
         JSR     PRSPCT           ;  .    CALCULATE NEW POINTER
         STA     TEMP4            ;  .    .
         STB     SPKSIZ,U         ;  .    SAVE SPIKER SIZE
; 
         LDA     SPKFLG,U         ;  .    SPLIT SPIKER ?
         ANDA    #$40             ;  .    .
         BEQ     GSPK7            ;  .    .
         LSRB                     ;  .    .    SPLIT SPIKERS ARE HALF SIZE
         STB     SPKSIZ,U         ;  .    .    .
;
;
GSPK7    LDA     KILFLG           ;  PERFORM SPIKER BOUNCE TEST
         BNE     GSPK9A           ;  .    KILLER SEQUENCE ?
;
         LDA     SPKHLD,U         ;  .    SPIKER BOUNCE HOLD-OFF PENDING ?
         BNE     GSPK8            ;  .    .
;
         JSR     COLIDE           ;  .    PERFORM WALL COLLISION TEST
         BVS     GSPK11           ;  .    .    IS SPIKER OUT-BOUND ?
         BCC     GSPK9            ;  .    .    DID WALL COLLISION OCCUR ?
;
         LDA     #SPKSPD          ;  .    FORM NEW SPIKER DISPLACEMENTS
         JSR     CALDSP           ;  .    .    CALCULATE NEW DISPLACEMENTS
;
         LDA     #$04             ;  .    SET SPIKER BOUNCE HOLD-OFF
         STA     SPKHLD,U         ;  .    .
         BRA     GSPK9            ;  .    .
;
;
GSPK8    DEC     SPKHLD,U         ;  DECREMENT SPIKER BOUNCE HOLD-OFF COUNTER
;
;
GSPK9    LDA     SPKXW,U          ;  IS SPIKER HIDDEN BY WALL ?
         LDX     #CHRLIM          ;  .    RIGHT WALL ?
         LDB     TEMP4            ;  .    .
         CMPA    B,X              ;  .    .
         BGT     GSPK10           ;  .    .
         LDX     #CHLLIM          ;  .    LEFT WALL ?
         CMPA    B,X              ;  .    .
         BLT     GSPK10           ;  .    .
;
GSPK9A   PSHS    DP               ;  DISPLAY FALLING SPIKER
         LDA     #$D0             ;  .    SET "DP" TO I/O
         TFR     A,DP             ;  .    .
         JSR     INT3Q            ;  .    SET SPIKER INTENSITY
;
;==========================================================================JJH
;        LDD     SPKYX,U          ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RSPKR           ;  .                               ======JJH
;        LDA     #$08             ;  .                               ======JJH
;        LDB     SPKSIZ,U         ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDX     #RSPKR           ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDY     SPKYX,U          ;  .                               ======JJH
         LDB     SPKSIZ,U         ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;==========================================================================JJH
;
         PULS    DP               ;  .    SET "DP" TO RAM
;
;
GSPK10   LEAU    SPKLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    END-OF-SPIKER TABLE ?
         LBNE    GSPK1            ;  .    .
         RTS                      ;  .    RETURN TO CALLER
;
;
GSPK11   CLR     SPKFLG,U         ;  THIS ENTRY HAS MOVED OFF-SCREEN
         DEC     CSPK             ;  .    DECREMENT ACTIVE SPIKE COUNTER
         BRA     GSPK10           ;  .    .
;
;
;
;
;  FIND AND RELEASE ACTIVE SPIKER
;  ==============================
;
RELSPK   LDA     #GUARDS          ;  FIND A SPIKER TO RELEASE
         STA     ETMP1            ;  .
;
         JSR     RANDOM           ;  .    FIND A RANDOM SPIKER ENTRY
         ANDA    #$07             ;  .    .
         ADDA    #$02             ;  .    .
RSPK0    STA     ETMP2            ;  .    .
         CMPA    #GUARDS          ;  .    .    WITH-IN RANGE ?
         BLS     RSPK1            ;  .    .    .
         CLRA                     ;  .    .    TO BIG - START OVER
         BRA     RSPK0            ;  .    .    .
;
RSPK1    DEC     ETMP1            ;  .    TRIED ALL THE SPIKER ENTRIES ?
         BEQ     DROP9            ;  .    .    NO SPIKERS FOUND
;
         LDB     #SPKLEN          ;  .    CALCULATE SPIKER ENTRY
         MUL                      ;  .    .
         ADDD    #SPKTBL          ;  .    .
         TFR     D,Y              ;  .    .
;
         LDA     SPKFLG,Y         ;  .    SPIKER ACTIVE ?
         BMI     RSPK2            ;  .    .
;
         LDA     ETMP2            ;  .    TRY NEXT ENTRY
         INCA                     ;  .    .
         BRA     RSPK0            ;  .    .
;
RSPK2    LDA     BLSTY            ;  .    IS SPIKER BELOW BLASTER ?
         ADDA    #$10             ;  .    .
         CMPA    SPKYW,Y          ;  .    .
         BGE     DROP9            ;  .    .
;
;
DRPSPK   TFR     Y,U              ;  DROP SPIKER
         LDA     #$01             ;  .    SET SPIKER FLAG
         STA     SPKFLG,U         ;  .    .
;
         JSR     SWING            ;  .    SET SPIKER DISPLACEMENT VALUES
         ADDB    #$20             ;  .    .    SET INITIAL SPIKER ANGLE
         STB     SPKANG,U         ;  .    .    .
;
         LDA     #SPKSPD          ;  .    .    SET INITIAL VELOCITY
         JSR     CALDSP           ;  .    .    CALCULATE DISPLACEMENTS
;
         CLR     SPKHLD,U         ;  .    CLEAR SPIKER BOUNCE HOLD-OFF COUNTER
;
         TFR     U,Y              ;  RETURN TO CALLER
DROP9    RTS                      ;  .
;
;
;         IF      L.SPK = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
