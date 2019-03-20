;
;
;         IF      L.BLST = OFF     ;-------------------------------------------
;         LIST    -L               ;--  GBLAST  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  HANDLE BLASTER GAME LOGIC
;  =========================
;
         direct   $C8
;        =====   ===
;
GBLAST   LDA     ABORT            ;  GAME ABORTED ?
         LBNE    DBLST3           ;  .
;
         LDA     BLSTMR           ;  DECREMENT BLASTER INHIBIT TIMER
         BEQ     BLST1            ;  .    TIMER = ZERO ?
;
;==========================================================================JJH
;        DECA                     ;  CODE DELETED - REV. B CHANGES   ======JJH
;        STA     BLSTMR           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         DEC     BLSTMR           ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
;
BLST1    CLR     BLSTYD           ;  CLEAR DISPLACEMENT VALUES
         CLR     BLSTXD           ;  .
;
         LDA     POT1             ;  HANDLE JOYSTICK ACTIVITY
         BEQ     BLST3            ;  .    UP / DOWN MOTION ?
         BMI     BLST2            ;  .    .    MOVE DOWN ?
;
         LDA     #$02             ;  .    .    MOVE BLASTER UP
         STA     BLSTYD           ;  .    .    .
         BRA     BLST3            ;  .    .    .
;
BLST2    LDA     #$FC             ;  .    .    MOVE BLASTER DOWN
         STA     BLSTYD           ;  .    .    .
;
BLST3    LDA     POT0             ;  .    LEFT / RIGHT MOTION ?
         BEQ     BLST7            ;  .    .    MOVE LEFT ?
         BMI     BLST5            ;  .    .    .
;
BLST4    LDA     #$03             ;  .    MOVE BLASTER RIGHT
         BRA     BLST6            ;  .    .
;
BLST5    LDA     #$FD             ;  .    MOVE BLASTER LEFT
BLST6    STA     BLSTXD           ;  .    .
;
;
BLST7    LDA     #BIRDS           ;  WAR-BIRD SHIELD(S) BLOCKING MOTION ?
         STA     TEMP1            ;  .
         LDU     #BRDTBL          ;  .
;
BLST8    LDA     BRDFLG,U         ;  .    WAR-BIRD IN SHIELD MODE ?
         BMI     BLST10           ;  .    .
;
BLST9    LEAU    BRDLEN,U         ;  .    TRY NEXT ENTRY
         DEC     TEMP1            ;  .    .
         BNE     BLST8            ;  .    .
         BRA     BLST11           ;  .    UPDATE BLASTER POSITION
;
BLST10   LDD     BLSTYX           ;  .    WAR-BIRD SHIELD FOUND
         ADDA    BLSTYD           ;  .    .    SET-UP NEXT BLASTER POSITION
         ADDB    BLSTXD           ;  .    .    .
         TFR     D,X              ;  .    .    .
         LDY     BRDYX,U          ;  .    .    SET-UP SHIELD POSITION
         LDD     BRDBOX,U         ;  .    .    SET-UP COLLISION BOX
         JSR     BXTEST           ;  .    .    PERFORM BOX TEST
         BCC     BLST9            ;  .    .    .
;
         CLR     BLSTYD           ;  .    WAR-BIRD SHIELD BLOCKING MOTION
         CLR     BLSTXD           ;  .    .    RESET POSITION UPDATE INFO
         BRA     BLST9            ;  .    .    .
;
;
BLST11   LDA     BLSTY            ;  UPDATE BLASTER POSITIONING
         ADDA    BLSTYD           ;  .    UPDATE 'Y' VALUE
         STA     BLSTY            ;  .    .
         CLR     BLSTY + 1        ;  .    .
;
         LDB     BLSTX            ;  .    UPDATE 'X' VALUE
         ADDB    BLSTXD           ;  .    .
         STB     BLSTX            ;  .    .
         CLR     BLSTX + 1        ;  .    .
;
         CMPA    #LLIMIT          ;  .    CHECK FOR MOTION LIMITS
         BGE     BLST12           ;  .    .    CHECK FOR LOWER-LIMIT
         LDA     #LLIMIT          ;  .    .    .    SET LOWER ROAD-WAY LIMIT
         BRA     BLST14           ;  .    .    .    .
;
BLST12   LDB     KILFLG           ;  .    .    CHECK FOR UPPER-LIMIT
         BNE     BLST44           ;  .    .    .    KILLER SEQUENCE ?
         LDB     ACTIVE           ;  .    .    .    GAME ACTIVITY PENDING ?
         BEQ     BLST13           ;  .    .    .    .
;
         CMPA    #ULIMIT          ;  .    .    .    PENDING ACTIVITY
         BLE     BLST14           ;  .    .    .    .
         LDA     #ULIMIT          ;  .    .    .    .    SET UPPER LIMIT
         BRA     BLST14           ;  .    .    .    .    .
;
BLST13   CMPA    #GLIMIT          ;  .    .    .    NO FURTHER ACTIVITY
         BLE     BLST14           ;  .    .    .    .
         LDA     #GLIMIT          ;  .    .    .    .    SET UPPER LIMIT
         BRA     BLST14           ;  .    .    .    .    .
;
BLST44   CMPA    #KLIMIT          ;  .    .    .    KILLER SEQUENCE
         BLE     BLST14           ;  .    .    .    .
         LDA     #KLIMIT          ;  .    .    .    .
;
BLST14   STA     BLSTY            ;  .    .    SET CURRENT 'Y' POSITION
         STA     BLSTYX           ;  .    .    .
;
;
         LDX     #CR_LIM          ;  .    UPDATE PERSPECTIVE INFO
         JSR     PRSPCT           ;  .    .    CALCULATE NEW POINTER
         STA     TEMP1            ;  .    .    .
         STB     BLSTR            ;  .    .    SAVE RIGHT WALL LIMIT
;
         LDX     #CL_LIM          ;  .    SET LEFT WALL LIMIT
         LDB     A,X              ;  .    .
         STB     BLSTL            ;  .    .
;
         ADDA    #BLBIAS          ;  .    SET BLASTER SIZE
         LDX     #G_SIZ           ;  .    .    BIAS SIZE VS. DEPTH
         LDB     A,X              ;  .    .
         STB     BLSTSZ           ;  .    .
;
         LDA     TEMP1            ;  .    SET COLLISION BOX
         LSLA                     ;  .    .
         LDX     #BL_BOX          ;  .    .
         LDX     A,X              ;  .    .
         STX     BLSTBX           ;  .    .
;
;
         LDA     BLSTX            ;  .    CHECK FOR MOTION LIMITS
         CMPA    BLSTR            ;  .    .    CHECK FOR RIGHT BORDER
         BLE     BLST15           ;  .    .    .
         LDA     BLSTR            ;  .    .    .
         BRA     BLST16           ;  .    .    .
;
BLST15   CMPA    BLSTL            ;  .    .    CHECK FOR LEFT BORDER
         BGE     BLST16           ;  .    .    .
         LDA     BLSTL            ;  .    .    .
BLST16   STA     BLSTX            ;  .    .    .
         STA     BLSTYX + 1       ;  .    .    .
;
;
         PSHS    DP               ;  SET "DP" TO I/O
         LDB     #$D0             ;  .
         TFR     B,DP             ;  .
         direct   $D0              ;  .
;
         LDX     #CHRLIM          ;  BLASTER HIDDEN BY WALL ?
         LDB     TEMP1            ;  .    RIGHT WALL ?
         CMPA    B,X              ;  .    .
         BGT     DBLST1           ;  .    .
         LDX     #CHLLIM          ;  .    LEFT WALL ?
         CMPA    B,X              ;  .    .
         BLT     DBLST1           ;  .    .
;
;
DBLAST   JSR     INT3Q            ;  DRAW BLASTER (VISIBLE ON ROADWAY
         BRA     DBLST2           ;  .
;
DBLST1   JSR     INT2Q            ;  DRAW BLASTER (HIDDEN BY WALL)
;
DBLST2   LDX     BLSTYX           ;  DRAW VECTOR STRING
         LDU     #XBLAST          ;  .
         LDA     BLSTSZ           ;  .
         JSR     SUPRDF           ;  .
;
         PULS    DP               ;  RETURN TO CALLER
DBLST3   PULS    PC               ;  .
;
;
;         IF      L.BLST = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
