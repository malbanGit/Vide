;
;
;         IF      L.INV = OFF      ;-------------------------------------------
;         LIST    -L               ;--  INVENT  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  INVENTORY PAGE HANDLER
;  ======================
;
         direct   $00
;        =====   ===
;
INVENT   LDA     #$D0             ;  SET 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         JSR     INTMAX           ;  SET MAXIMUM INTENSITY
;
         LDA     INVNTY           ;  INVENTORY PAGE REQUESTED ?
         LBEQ    FWAIT            ;  .    IS INVENTORY KEY DEPRESSED ?
         LDA     TSTAT            ;  .    IS TUNE OR SOUND EFFECT PENDING ?
;==========================================================================JJH
         ORA     STEPS            ;  CODE ADDED - REV. A CHANGES     ======JJH
         ORA     BOXSQK           ;  .                               ======JJH
         ORA     THRSND           ;  .                               ======JJH
         ORA     EXPBRG           ;  .                               ======JJH
         ORA     EXPWAR           ;  .                               ======JJH
;==========================================================================JJH
         LBNE    FWAIT            ;  .    .
;
         PSHS    DP               ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
;
         LDA     #$80             ;  CLEAR SOUND CHANNEL
         JSR     CLRSND           ;  .
;
         PULS    DP               ;  SET 'DP' = I/O
;
;
         LDD     #$64A0           ;  DISPLAY PLAYERS SCORE
         JSR     POSITD           ;  .    POSITION MESSAGE
         LDD     #$F638           ;  .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .
         LDU     #PLAYER          ;  .    DISPLAY HEADER MESSAGE
         JSR     RASTER           ;  .    .
;
         LDD     #$4CA0           ;  DISPLAY ACQUIRED TREASURES
         JSR     POSITD           ;  .    POSITION MESSAGE
         LDD     #$F638           ;  .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .
         LDU     #M_TRES          ;  .    DISPLAY HEADER MESSAGE
         JSR     RASTER           ;  .    .
;
         LDD     #$38B8           ;  .    SET INITIAL MESSAGE POSITION
         STD     TEMP3            ;  .    .
;
         LDA     TROOPS           ;  .    DISPLAY NUMBER OF RESERVE TROOPS
         BEQ     INVT3            ;  .    .    ANY TROOPS REMAINING ?
;
         LDD     TEMP3            ;  .    .    POSITION MESSAGE
         JSR     POSITD           ;  .    .    .
         LDD     #$F838           ;  .    .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .    .
;
         LDU     #MEN             ;  .    .    SKIP LEADING ZEROES
INVT1    LDA     ,U               ;  .    .    .
         ORA     #$10             ;  .    .    .
         CMPA    #$30             ;  .    .    .
         BNE     INVT2            ;  .    .    .
         LEAU    1,U              ;  .    .    .
         BRA     INVT1            ;  .    .    .
;
INVT2    JSR     RASTER           ;  .    .    DISPLAY TROOPS MESSAGE
;
         LDD     TEMP3            ;  .    .    MOVE TO NEXT MESSAGE LINE
         SUBA    #$10             ;  .    .    .
         STD     TEMP3            ;  .    .    .
;
;
INVT3    LDD     TEMP3            ;  .    DISPLAY NUMBER OF GOLD BAGS
         JSR     POSITD           ;  .    .    POSITION MESSAGE
         LDD     #$F838           ;  .    .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .    .
;
         LDU     #GOLD            ;  .    .    SKIP LEADING ZEROES
INVT4    LDA     ,U               ;  .    .    .
         ORA     #$10             ;  .    .    .
         CMPA    #$30             ;  .    .    .
         BNE     INVT5            ;  .    .    .
         LEAU    1,U              ;  .    .    .
         BRA     INVT4            ;  .    .    .
;
INVT5    JSR     RASTER           ;  .    .    DISPLAY BAGS MESSAGE
;
         LDD     TEMP3            ;  .    .    MOVE TO NEXT MESSAGE LINE
         SUBA    #$10             ;  .    .    .
         STD     TEMP3            ;  .    .    .
;
;
         LDD     #$FA38           ;  .    SET-UP FOR TREASURE DISPLAY
         STD     SIZRAS           ;  .    .    SET RASTER SIZE
         LDA     #$07             ;  .    .    SET TREASURE COUNT
         STA     TEMP1            ;  .    .    .
         LDY     #GLDKEY          ;  .    . 
         CLR     TEMP2            ;  .    .
;
INVT6    LDA     TEMP2            ;  .    TEST TREASURE FLAG
         LDA     A,Y              ;  .    .
         BEQ     INVT7            ;  .    .
;
         LDD     TEMP3            ;  .    POSITION MESSAGE
         JSR     POSITD           ;  .    .
;
         LDU     #TRSMSG          ;  .    SELECT TREASURE MESSAGE
         LDA     TEMP2            ;  .    .
         LSLA                     ;  .    .
         ADDA    #$02             ;  .    .
         LDU     A,U              ;  .    .
         JSR     RASTER           ;  .    DISPLAY TREASURE MESSAGE
;
         LDA     TEMP3            ;  .    BUMP TO NEXT TREASURE
         SUBA    #$10             ;  .    .    CALCULATE NEW MESSAGE POSITION
         STA     TEMP3            ;  .    .    .
INVT7    INC     TEMP2            ;  .    .    INCREMENT TREASURE POINTER
         DEC     TEMP1            ;  .    .    DECREMENT TREASURE COUNTER
         BNE     INVT6            ;  .    .    .
;
         JSR     FRWAIT           ;  WAIT FOR FRAME BOUNDARY
         JSR     DEFLOK           ;  .    PREVENT SCAN COLLAPSE
         JSR     DEFLOK           ;  .    .
         JSR     DEFLOK           ;  .    .
;
         JSR     RANDOM           ;  STIR RANDOM NUMBER GENERATOR
;
         LDA     SBTN             ;  READ CONSOLE BUTTONS
         JSR     DBNCE            ;  .
;
         JMP     INVENT           ;  .
;
;         IF      L.INV = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
