;
;
;         IF      L.FLM = OFF      ;-------------------------------------------
;         LIST    -L               ;--  FLAMER  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  HANDLE FLAMOID GAME LOGIC
;  =========================
;
         direct   $C8
;        =====   ===
;
FLAMER   PSHS    DP               ;  SAVE ENTRY VALUES
         LDA     #$C8             ;  .    SETP 'DP' = RAM
         TFR     A,DP             ;  .    .
;
         LDX     #PFLAME          ;  ROTATE FLAMOID EACH FRAME
         LDU     #RFLAME          ;  .    SET DESTINATION POINTER
         LDA     FRAME            ;  .    FETCH FRAME FOR ROTATION VALUE
         LSLA                     ;  .    .    SPEED-UP ROTATION RATE
         LSLA                     ;  .    .    .
         LDB     ,X+               ;  .    FETCH NUMBER OF VECTORS
         STB     ,U+               ;  .    .
         JSR     DROT             ;  .    ROTATE FLAMOID
;
         LDD     #$0080           ;  SET SINE / COSINE FOR 'PRJCTN'
         STD     WSINE            ;  .
         LDD     #$FF81           ;  .
         STD     WCSINE           ;  .
;
         LDU     #FLMTBL          ;  HANDLE FLAMOID MOVEMENT
         LDA     #FLMCNT          ;  .
         STA     TEMP1            ;  .
;
FLMR1    LDA     <<FLMFLG,U         ;  .    IS ENTRY ACTIVE ?
         BEQ     FLMR3            ;  .    .
;
         JSR     MOVOBJ           ;  .    MOVE FLAMOID ALONG 'Y / X' AXIS
         BVS     FLMR2            ;  .    .    HAS FLAMOID MOVED OFF-SCREEN ?
         BCS     FLMR2            ;  .    .    .
;
         LDA     FLMYW,U          ;  .    PROJECT FLAMOID INTO 3-D
         LDB     FLMXW,U          ;  .    .
         STA     RZPOS            ;  .    .
         STB     RXPOS            ;  .    .
         LDA     FLMZW,U          ;  .    .
         STA     RYPOS            ;  .    .
         JSR     PRJCTN           ;  .    .    CALCULATE SCREEN CO-ORDINATES
         BVS     FLMR3            ;  .    .    .    SKIP IF OUT-OF-RANGE
;
;
         DEC     FLMTMR,U         ;  DISPLAY FLAMOID FLAMES
         BEQ     FLMR2            ;  .    RESET FLAMOID ?
;
         PSHS    DP               ;  .    SET 'DP' = I/O
         LDA     #$D0             ;  .    .
         TFR     A,DP             ;  .    .
         direct   $D0              ;  .    .
;
         LDX     #RFLAME          ;  .    DRAW FLAMOID
         LDD     #$7F7F           ;  .    .    SET INTENSITY
         SUBB    DRWSCZ           ;  .    .    SET SIZE
         LDY     #DRWSCY          ;  .    .    SET ABSOLUTE POSITION
         JSR     SDIFFY           ;  .    .
;
         PULS    DP               ;  .    SET 'DP' = RAM
         BRA     FLMR3            ;  .    .
;
;
         direct   $C8
;
FLMR2    CLR     <<FLMFLG,U         ;  RESET CURRENT FLAMOID ENTRY
;
FLMR3    LEAU    FLMLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .
         BNE     FLMR1            ;  .
;
         PULS    DP,PC            ;  RETURN TO CALLER
;
;         IF      L.FLM = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
