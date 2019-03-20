;
;
;         IF      L.WIZ = OFF      ;-------------------------------------------
;         LIST    -L               ;--  WIZARD  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  DRAW WIZARD
;  ===========
;
         direct   $D0
;        =====   ===
;
WIZARD   LDA     FRAM7            ;  DISPLAY ANIMATED WIZARD
         BNE     WIZDSP           ;  .    LIMIT ANIMATION RATE
;
         INC     WZCNT            ;  .    INCREMENT FRAME BIAS
;
WIZDSP   LDA     WZCNT            ;  .    DISPLAY RIGHT SIDE OF MAGICIAN
         LSLA                     ;  .    .    FETCH LEFT SIDE ANIMATION
         LDX     #MAGIC2          ;  .    .    .
         LDX     A,X              ;  .    .    .
         STX     DRWLS2           ;  .    .    .
         LDX     #MAGIC1          ;  .    .    FETCH RIGHT SIDE ANIMATION
         LDX     A,X              ;  .    .    .
         STX     DRWLS1           ;  .    .    .
         BNE     DSPWZ1           ;  .    .    .    IF ZERO, RESTART ANIMATION
;
         DEC     WZCNT            ;  .    .    RESET ANIMATION
         LDA     #$01             ;  .    .    .    SET WIZARD DONE FLAG
         STA     WZDON            ;  .    .    .    .
         BRA     WIZDSP           ;  .    .    .
;
DSPWZ1   LDA     #$70             ;  .    .    SET INTENSITY
         SUBA    WZINT            ;  .    .    .    MODIFY FOR 'HYPER'
         CMPA    #$20             ;  .    .    .    .
         BLE     DSPWZ2           ;  .    .    .    .
         LDB     #$50             ;  .    .    .    SET SIZE
         STD     DRWINT           ;  .    .    .
;
         LDD     #$1000           ;  .    .    POSITION WIZARD ON SCREEN
         STD     TEMP1            ;  .    .    .
;
         LDD     #$0000           ;  .    .    DRAW USING 'DRWLS1/2'
         LDY     #TEMP1           ;  .    .    .
         JSR     CDIFFY           ;  .    .    DRAW WIZARD
;
DSPWZ2   RTS                      ;  RETURN TO CALLER
;
;         IF      L.WIZ = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
