;
;
;         IF      L.TWR = OFF      ;-------------------------------------------
;         LIST    -L               ;--  TOWER  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***************************************************************
;  ***************************************************************
;  ***                                                         ***
;  ***          D A R K   T O W E R   S U B - P L O T          ***
;  ***                                                         ***
;  ***************************************************************
;  ***************************************************************
;
;  DARK-TOWER KEY RIDDLE
;  =====================
;
         direct   $C8
;        =====   ===
;
TOWER    PSHS    Y,U,DP           ;  SAVE ENTRY VALUES
;
         JSR     SAVGRD           ;  SAVE GRID SCAN VALUES
         JSR     WRKCLR           ;  CLEAR OVER-LAYED STORAGE
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         CLR     RFLAG            ;  CLEAR DRAW REVERSE FLAG
;
RIDL1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
;
         LDA     NXTKEY           ;  MOVE KEY POINTER RIGHT ?
         BEQ     RIDL2            ;  .
;
         LDB     RKPTR            ;  .    MOVE KEY POINTER RIGHT
         INCB                     ;  .    .
         ANDB    #$03             ;  .    .
         STB     RKPTR            ;  .    .
;
RIDL2    LDA     INCKEY           ;  CHANGE KEY SELECTION UPWARD ?
         BEQ     RIDL4            ;  . 
;
         LDU     #RKEY0           ;  .    WHICH HAS BEEN SELECTED ?
         LDA     #$03             ;  .    .
         SUBA    RKPTR            ;  .    .
         LEAU    A,U              ;  .    .
         LDB     ,U               ;  .    .
;
         INCB                     ;  .    MOVE KEY SELECTION UP
         CMPB    #$04             ;  .    .
         BLS     RIDL3            ;  .    .
         LDB     #$01             ;  .    .
RIDL3    STB     ,U               ;  .    .
;
;
RIDL4    LDA     TRYKEY           ;  TEST KEY COMBINATION ?
         LBNE    RDLTST           ;  .
;
;
RIDL5    JSR     INTMAX           ;  DISPLAY RIDDLE MESSAGE
         LDU     #M_RIDL          ;  .
         JSR     DSMESS           ;  .
;
         LDD     #$C0C4           ;  DRAW TOWER DOOR
         JSR     POSITD           ;  .    POSITION DOOR FRAME
         LDB     #$E0             ;  .    DRAW TOWER DOOR FRAME
         LDX     #TWRDR1          ;  .    .
         JSR     ZDIFFY           ;  .    .
;
         JSR     INT3Q            ;  .    SET INTENSITY FOR KEY HOLE
         LDD     #$1020           ;  .    POSITION KEY HOLE
         JSR     POSITD           ;  .    .
         LDB     #$A0             ;  .    DRAW TOWER DOOR KEY-HOLE
         LDX     #TWRDR2          ;  .    .
         JSR     ZDIFFY           ;  .    .
;
;
         LDD     #$B290           ;  DRAW KEY SYMBOLS (4 TOTAL)
         STD     TEMP1            ;  .    SET INITIAL KEY SYMBOL POSITION
         LDD     #$A880           ;  .    SET INITIAL KEY MESSAGE POSITION
         STD     TEMP3            ;  .    .
         LDA     #$03             ;  .    SET KEY COUNTER
         STA     TEMP5            ;  .    .
;
RIDL6    JSR     INT3Q            ;  .    DRAW KEY SYMBOLS
         LDD     TEMP1            ;  .    .    POSITION KEY SYMBOL
         ADDB    #$2E             ;  .    .    .    CALCULATE NEW POSITION
         STD     TEMP1            ;  .    .    .    .
         JSR     POSITD           ;  .    .    .
         LDB     #$38             ;  .    .    DRAW KEY SYMBOL
         LDX     #PKEY            ;  .    .    .
         JSR     ZDIFFY           ;  .    .    .
;
         LDD     #$FC30           ;  .    DRAW KEY MESSAGE
         STD     SIZRAS           ;  .    .    SET RASTER MESSAGE SIZE
;
         JSR     INTMAX           ;  .    .    POSITION KEY MESSAGE
         LDD     TEMP3            ;  .    .    .    CALCULATE NEW POSITION
         ADDB    #$2E             ;  .    .    .    .
         STD     TEMP3            ;  .    .    .    .
         JSR     POSITD           ;  .    .    .
         LDU     #RKEY0           ;  .    .    DISPLAY KEY TYPE MESSAGE
         LDA     TEMP5            ;  .    .    .    WHICH KEY TO DISPLAY ?
         LDA     A,U              ;  .    .    .    .
         LDU     #RK_TBL          ;  .    .    .    FETCH KEY MESSAGE
         ASLA                     ;  .    .    .    .
         LDU     A,U              ;  .    .    .    .
         JSR     RASTER           ;  .    .    .
;
         DEC     TEMP5            ;  .    TRY NEXT SYMBOL ?
         BPL     RIDL6            ;  .    .
;
         LDU     #APOINT          ;  POSITION AND DRAW KEY POINTER
         LDA     RKPTR            ;  .    DETERMINE KEY POINTER POSITION
         LDB     A,U              ;  .    .
         LDA     #$98             ;  .    .
         JSR     POSITD           ;  .    POSITION KEY POINTER
         LDB     #$14             ;  .    DRAW KEY POINTER
         LDX     #PPOINT          ;  .    .
         JSR     ZDIFFY           ;  .    .
;
         JMP     RIDL1            ;  .
;
;
;
RDLTST   LDX     #KRIDL0          ;  COMPARE RIDDLE AND KEY SETTINGS
         LDU     #RKEY0           ;  .
         LDB     #$03             ;  .
;
         LDA     ,U               ;  .    HAVE ALL THE KEYS BEEN DEFINED ?
         ADDA    1,U              ;  .    .
         ADDA    2,U              ;  .    .
         ADDA    3,U              ;  .    .
         CMPA    #$0A             ;  .    .
         LBNE    RIDL5            ;  .    .
;
RDLTS1   LDA     B,X              ;  .    COMPARE AGAINST RIDDLE SETTINGS
         CMPA    B,U              ;  .    .
         BNE     BADKEY           ;  .    .
         DECB                     ;  .    .
         BPL     RDLTS1           ;  .    .
         JMP     KEYDON           ;  .    .    KEYS MATCH RIDDLE
;
;
;
;
;  FAILED KEY TEST - DISPLAY CORRECT KEYS
;  ======================================
;
;
BADKEY   LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         CLR     RFLAG            ;  CLEAR DRAW REVERSE FLAG
;
         LDA     #$50             ;  SET DELAY TIMER
         STA     CBXDLY           ;  .
;
BDKEY1   JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         JSR     INTMAX           ;  DRAW TOWER DOOR
         LDD     #$C0C4           ;  .    POSITION DOOR FRAME
         JSR     POSITD           ;  .    .
         LDB     #$E0             ;  .    DRAW TOWER DOOR FRAME
         LDX     #TWRDR1          ;  .    .
         JSR     ZDIFFY           ;  .    .
;
         JSR     INT3Q            ;  .    SET INTENSITY FOR KEY HOLE
         LDD     #$1020           ;  .    POSITION KEY HOLE
         JSR     POSITD           ;  .    .
         LDB     #$A0             ;  .    DRAW TOWER DOOR KEY-HOLE
         LDX     #TWRDR2          ;  .    .
         JSR     ZDIFFY           ;  .    .
;
         LDD     #$B290           ;  DRAW CORRECT KEYS
         STD     TEMP1            ;  .    SET INITIAL KEY SYMBOL POSITION
         LDD     #$A880           ;  .    SET INITIAL KEY MESSAGE POSITION
         STD     TEMP3            ;  .    .
         LDA     #$03             ;  .    SET KEY COUNTER
         STA     TEMP5            ;  .    .
         LDD     #$FC30           ;  .    SET RASTER MESSAGE SIZE
         STD     SIZRAS           ;  .    .
;
BDKEY2   LDD     TEMP1            ;  .    SET NEW KEY SYMBOL POSITION
         ADDB    #$2E             ;  .    .
         STD     TEMP1            ;  .    .
;
         LDD     TEMP3            ;  .    SET NEW KEY MESSAGE POSITION
         ADDB    #$2E             ;  .    .
         STD     TEMP3            ;  .    .
;
         JSR     INT3Q            ;  .    DRAW KEY SYMBOLS
         LDD     TEMP1            ;  .    .    POSITION KEY SYMBOL
         JSR     POSITD           ;  .    .    .
         LDB     #$38             ;  .    .    DRAW KEY SYMBOL
         LDX     #PKEY            ;  .    .    .
         JSR     ZDIFFY           ;  .    .    .
;
         LDX     #KRIDL0          ;  .    DOES THIS KEY MATCH RIDDLE ?
         LDA     TEMP5            ;  .    .
         LDB     A,X              ;  .    .
         LDX     #RKEY0           ;  .    .
         CMPB    A,X              ;  .    .
         BNE     BDKEY3           ;  .    .
;
         JSR     INTMAX           ;  .    DRAW KEY RASTER MESSAGE
         LDU     #KRIDL0          ;  .    .    FETCH RASTER MESSAGE FOR KEY
         LDA     TEMP5            ;  .    .    .
         LDA     A,U              ;  .    .    .
         LDU     #RK_TBL          ;  .    .    .
         ASLA                     ;  .    .    .
         LDU     A,U              ;  .    .    .
         LDD     TEMP3            ;  .    .    POSITION KEY MESSAGE
         JSR     POSITD           ;  .    .    .
         JSR     RASTER           ;  .    .    DISPLAY MESSAGE
;
BDKEY3   DEC     TEMP5            ;  .    TRY NEXT SYMBOL ?
         BPL     BDKEY2           ;  .    .
;
         DEC     CBXDLY           ;  DISPLAY TIME-OUT ?
         LBNE    BDKEY1           ;  .
;
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         JSR     WRKCLR           ;  CLEAR OVER-LAYED STORAGE
         JSR     GRDSCN           ;  RE-CALCULATE FOREST PROJECTIONS
         JSR     RSTGRD           ;  RESTORE RETAINED GRID VALUES
;
         PULS    Y,U,DP,PC        ;  RETURN TO CALLER
;
;
;
;
;  RIDDLE COMPLETED - SET-UP FOR VOLUME II
;  =======================================
;
;
KEYDON   LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDU     #BOXACT          ;  PASS PARAMETERS TO VOLUME II
         LDA     #$10             ;  .    SET NUMBER OF BLOCKS
         STA     TEMP2            ;  .    .
;
KYDN1    LDX     #GLDKEY          ;  .    START NEW BLOCK
         LDD     #$FF00           ;  .    .    SET START FLAG
         STD     ,U++              ;  .    .    .
         CLR     TEMP1            ;  .    .    CLEAR CHECK BYTE
;
KYDN2    LDA     ,X+               ;  .    MOVE PARAMETER TABLE
         STA     ,U+               ;  .    .
         ADDA    TEMP1            ;  .    .    FORM CHECK BYTE
         STA     TEMP1            ;  .    .    .
;
         CMPX    #TROOPS          ;  .    END OF BLOCK ?
         BLE     KYDN2            ;  .    .
;
         LDB     #$03             ;  .    .    SAVE ASCII GOLD VALUE
         LDY     #GOLD            ;  .    .    .
KYDN3    LDA     ,Y+               ;  .    .    .
         STA     ,U+               ;  .    .    .
         ADDA    TEMP1            ;  .    .    .
         STA     TEMP1            ;  .    .    .
         DECB                     ;  .    .    .
         BPL     KYDN3            ;  .    .    .
;
         LDB     #$03             ;  .    .    SAVE ASCII TROOPS VALUE
         LDY     #MEN             ;  .    .    .
KYDN4    LDA     ,Y+               ;  .    .    .
         STA     ,U+               ;  .    .    .
         ADDA    TEMP1            ;  .    .    .
         STA     TEMP1            ;  .    .    .
         DECB                     ;  .    .    .
         BPL     KYDN4            ;  .    .    .
;
         LDB     #$06             ;  .    .    SAVE ASCII PLAYERS SCORE
         LDY     #PLYSCR          ;  .    .    .
KYDN5    LDA     ,Y+               ;  .    .    .
         STA     ,U+               ;  .    .    .
         ADDA    TEMP1            ;  .    .    .
         STA     TEMP1            ;  .    .    .
         DECB                     ;  .    .    .
         BPL     KYDN5            ;  .    .    .
;
         LDA     TEMP1            ;  .    .    SAVE CHECK BYTE
         STA     ,U+               ;  .    .    .
;
         DEC     TEMP2            ;  .    DONE PASSING PARAMETERS ?
         BNE     KYDN1            ;  .    .
;
         LDU     #OPNING          ;  PLAY CLOSING TUNE
         JSR     SPLAY            ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO PLAYERS SCORE
         LDD     #$3000           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$FF             ;  SET-UP FOR WARRIORS ENTRANCE TO TOWER
         LDB     #SZ_WAR          ;  .
         STD     TEMP8            ;  .
         CLR     TEMP10           ;  .
;
         LDD     #$E000           ;  .    SET INITIAL WARRIOR POSITION
         STD     WARYW            ;  .    .
;
;
KYDN6    JSR     INVENT           ;  DISPLAY KEY RIDDLE DONE MESSAGE
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDU     #RK_DON          ;  .    DRAW RASTER STRING
         JSR     DSMESS           ;  .    .
;
         LDD     #$48FF           ;  SET-UP TO DRAW DARK TOWER
         STD     DRWINT           ;  .    SET INTENSITY AND SIZE
         LDD     #$F000           ;  .    SET POSITION
         STD     TEMP1            ;  .    .
         CLR     RFLAG            ;  .    RESET DRAW REVERSE FLAG
;
         LDD     #DTWR1           ;  DRAW DARK TOWER
         LDX     #DTWR2           ;  .    FETCH DARK TOWER ADDRESSES
         LDY     #TEMP1           ;  .    FETCH SCREEN POSITION
         JSR     CDIFFY           ;  .    DRAW BOTTOM OF BOX
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         DEC     TEMP8            ;  DISPLAY MARCHING WARRIOR
         LDA     TEMP8            ;  .    CALCULATE NEW INTENSITY
         BMI     KYDN7            ;  .    .    WARRIOR IDLE ?
         CMPA    #$20             ;  .    .    WARRIOR ENTRANCE DONE ?
         BLE     GMDON1           ;  .    .    .
         STA     DRWINT           ;  .    .
         LDD     TEMP9            ;  .    CALCULATE NEW SIZE
         SUBD    #$0020           ;  .    .
         STD     TEMP9            ;  .    .
         STA     DRWSIZ           ;  .    .
;
         JSR     WARR9            ;  .    DISPLAY WARRIOR
         BRA     KYDN6            ;  .    .
;
;
KYDN7    LDA     #$7F             ;  DISPLAY IDLE WARRIOR
         LDB     #SZ_WAR          ;  .
         STD     DRWINT           ;  .
;
         JSR     WARR11           ;  .    DISPLAY WARRIOR
         BRA     KYDN6            ;  .    .
;
;
;
GMDON1   JSR     INVENT           ;  HANDLE GAME OVER
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDD     #$48FF           ;  SET-UP TO DRAW DARK TOWER
         STD     DRWINT           ;  .    SET INTENSITY AND SIZE
         LDD     #$F000           ;  .    SET POSITION
         STD     TEMP1            ;  .    .
         CLR     RFLAG            ;  .    RESET DRAW REVERSE FLAG
;
         LDD     #DTWR1           ;  DRAW DARK TOWER
         LDX     #DTWR2           ;  .    FETCH DARK TOWER ADDRESSES
         LDY     #TEMP1           ;  .    FETCH SCREEN POSITION
         JSR     CDIFFY           ;  .    DRAW BOTTOM OF BOX
;
         JSR     GAMDON           ;  HANDLE GAME DONE LOGIC
;
         BRA     GMDON1           ;  .
;
;         IF      L.TWR = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
