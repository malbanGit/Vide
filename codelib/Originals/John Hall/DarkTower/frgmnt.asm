;
;
;         IF      L.FRAG = OFF     ;-------------------------------------------
;         LIST    -L               ;--  FRGMNT  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  HANDLE EXPLOSION FRAGMENTS
;  ==========================
;
         direct   $C8
;        =====   ===
;
FRGMNT   PSHS    DP               ;  SAVE ENTRY VALUES
         LDA     #$C8             ;  .    SETP 'DP' = RAM
         TFR     A,DP             ;  .    .
;
         CLR     RFLAG            ;  RESET DRAW REVERSE FLAG
         CLR     EXPEND           ;  RESET EXPLOSION PENDING FLAG
;
         LDU     #EXPTBL          ;  HANDLE FRAGMENT MOVEMENT
         LDA     #EXPCNT          ;  .
         STA     TEMP1            ;  .
;
FRAG1    LDA     <<EXPFLG,U         ;  .    IS ENTRY ACTIVE ?
         BEQ     FRAG3            ;  .    .
;
         DEC     EXPTMR,U         ;  .    DECREMENT EXPLOSION TIMER
         BEQ     FRAG2            ;  .    .
;
         LDA     EXPEND           ;  .    SET EXPLOSION PENDING FLAG
         ORA     EXPTMR,U         ;  .    .
         STA     EXPEND           ;  .    .
;
         JSR     MOVOBJ           ;  .    MOVE FRAGMENT ALONG 'Y / X' AXIS
         BVS     FRAG2            ;  .    .    HAS FRAGMENT MOVED OFF-SCREEN ?
         BCS     FRAG2            ;  .    .    .
;
         PSHS    U                ;  ROTATE FRAGMENT
         LDA     EXPROT,U         ;  .    FETCH ROTATION VALUE
         ADDA    EXPRAT,U         ;  .    .
         ANDA    #$3F             ;  .    .
         STA     EXPROT,U         ;  .    .
         LDX     EXPTR,U          ;  .    SET SOURCE POINTER
         LDU     #RFLAME          ;  .    SET DESTINATION POINTER
         LDB     ,X+               ;  .    FETCH NUMBER OF VECTORS
         STB     ,U+               ;  .    .
         ANDB    #$3F             ;  .    .
         JSR     DROT             ;  .    ROTATE FRAGMENT
         PULS    U                ;  .
;
         PSHS    DP               ;  DISPLAY FRAGMENT SEED
         LDA     #$D0             ;  .    SET 'DP' = I/O
         TFR     A,DP             ;  .    .
         direct   $D0              ;  .    .
;
         LDX     #RFLAME          ;  .    DISPLAY FRAGMENT
         LDA     EXPTMR,U         ;  .    .    SET INTENSITY
         ADDA    #$30             ;  .    .    .
         LDB     EXPSIZ,U         ;  .    .    SET SIZE
         LEAY    EXPYW,U          ;  .    .    SET ABSOLUTE POSITION
         JSR     WDIFFY           ;  .    .
;
         PULS    DP               ;  .    SET 'DP' = RAM
         BRA     FRAG3            ;  .    .
;
;
         direct   $C8
;
FRAG2    CLR     <<EXPFLG,U         ;  RESET CURRENT FRAGMENT ENTRY
;
FRAG3    LEAU    EXPLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .
         BNE     FRAG1            ;  .
;
         PULS    DP,PC            ;  RETURN TO CALLER
;
;         IF      L.FRAG = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
