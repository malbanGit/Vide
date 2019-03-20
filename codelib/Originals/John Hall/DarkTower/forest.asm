;
;
;         IF      L.FRST = OFF     ;-------------------------------------------
;         LIST    -L               ;--  FOREST  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  *******************************************************
;  *******************************************************
;  ***                                                 ***
;  ***          F O R E S T   S U B - P L O T          ***
;  ***                                                 ***
;  *******************************************************
;  *******************************************************
;
;  FOREST SEQUENCER
;  ================
;
FOREST   JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
         PSHS    DP               ;  .    .
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     TMR1             ;  SET INITIALIZATION FLAG ?
         BNE     FRST1            ;  .
         COMA                     ;  .
         STA     INTFLG           ;  .    SET INITIALIZATION FLAG
;
FRST1    JSR     WARIOR           ;  HANDLE WARRIOR GAME LOGIC
;
         CLR     WARINH           ;  RESET WARRIOR MOTION INHIBIT
;
         JSR     SCENRY           ;  HANDLE FOREST SCENERY
;
         LDX     PLGLCK           ;  DOWN-COUNT PLAGUE LOCK-OUT TIMER
         BEQ     FRST2            ;  .    IS PLAGUE LOCK-OUT PENDING ?
         LEAX    -1,X             ;  .
         STX     PLGLCK           ;  .
;
FRST2    PULS    DP               ;  SET 'DP' = I/O
         direct   $D0              ;  .
;
         LDA     TMR1             ;  DISPLAY WARRIOR MESSAGE ?
         BEQ     FRST5            ;  .
;
         LDA     INTFLG           ;  .    FIRST THREE WARRIORS ?
         BNE     FRST3            ;  .    .
;
         LDU     #M_FRST          ;  .    DISPLAY FIRST WARRIORS MESSAGE
         BRA     FRST4            ;  .    .
;
FRST3    LDA     PLGLIM           ;  .    DISPLAY WARRIOR REPLACEMENT MESSAGE
         BNE     FRST5            ;  .    .    WAIT UNTIL PLAGUE IS OVER
         LDA     TROOPS           ;  .    .    IF NO TROOPS REMAINING - SKIP
         BEQ     FRST5            ;  .    .    .
         LDU     #M_NWAR          ;  .    .
;
FRST4    JSR     INTMAX           ;  .    .    SET INTENSITY
         JSR     DSMESS           ;  .    .
;
FRST5    JSR     FOG              ;  HANDLE FOG LOGIC
         JSR     PLAGUE           ;  HANDLE PLAGUE LOGIC
         JSR     GAMOVR           ;  HANDLE GAME-OVER LOGIC
;
         BRA     FOREST           ;  REPEAT FOREST SEQUENCE
;
;         IF      L.FRST = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
