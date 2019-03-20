;
;
;         IF      L.TAIL = OFF     ;-------------------------------------------
;         LIST    -L               ;--  TAIL  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  TAIL-END OF GAME LOGIC SEQUENCE
;  ===============================
;
         direct   $C8
;        =====   ===
;
TAIL     LDA     ABORT            ;  END-OF-SEQUENCE ?
         BNE     TAIL4            ;  .    GAME ABORTED ?
;
         LDA     CGRD             ;  .    ALL GAME GAME COUNTERS SHOULD BE $00
         ORA     CSPK             ;  .    .    ACTIVE SPIKER COUNTER
         ORA     CBRD             ;  .    .    ACTIVE WAR-BIRD COUNTER
         ORA     TOTGRD           ;  .    .    TOTAL GUARDIAN COUNTER
         ORA     TOTBRD           ;  .    .    TOTAL WAR-BIRD COUNTER
         ORA     EXPLO1           ;  .    .    GUARDIAN EXPLOSION DONE ?
         ORA     EXPLO2           ;  .    .    BLASTER EXPLOSION DONE ?
         ORA     XACON            ;  .    .    .
         ORA     SQUAWK           ;  .    .    BIRD CRY PENDING ?
         ORA     SIZZLE           ;  .    .    SIZZLE PENDING ?
         STA     ACTIVE           ;  .    .
         BNE     TAIL2            ;  .    .    IF &gt;0, ACTIVITY PENDING
;
         LDA     GRDTYP           ;  .    IS GATE OPEN ?
         CMPA    #$11             ;  .    .    LAST GUARD TYPE = STOMPERS
         BLT     TAIL1            ;       .
;
         LDX     BLSTYX           ;  .    HAS BLASTER PASSED THRU GATE ?
         LDY     #$5C00           ;  .    .    SET GATE POSITION
         LDD     #$0404           ;  .    .    SET COLLISION BOX
         JSR     BXTEST           ;  .    .    DO BOX TEST
         BCC     TAIL2            ;  .    .    .
         LDA     POT1             ;  .    .    BLASTER AT GATE - GOING UP ?
         BEQ     TAIL2            ;  .    .    .
         BMI     TAIL2            ;  .    .    .
;
         CLR     CITFLG           ;  .    BLASTER HAS PASSED THRU GATE
         LDD     #$9000           ;  .    .    RESET BLASTER POSITION
         STD     BLSTY            ;  .    .    .
TAIL1    JMP     TAIL88           ;  .    .    .
;
TAIL2    JMP     TAIL99           ;  JUMP VECTOR
;
;
TAIL4    LDA     LOCK             ;  ABORT FLAG IS SET
         BNE     TAIL1            ;  .    GAME LOCKED-UP ?
;
         LDA     ABORT            ;  .    HAS ABORT BEEN ACKNOWLEDGED ?
         BMI     TAIL5            ;  .    .
         ORA     #$80             ;  .    ACKNOWLEDGE ABORT FLAG
         STA     ABORT            ;  .    .
;
         LDA     #$7F             ;  .    .    SET BLAST TIMER
         STA     EXPTMR           ;  .    .    .
;
         LDX     #BLSTY           ;  .    .    INITIATE FRAGMENT #1
         LDU     #EBLYD1          ;  .    .    .
         LDA     #$10             ;  .    .    .
         JSR     EXPDSP           ;  .    .    .
;
;==========================================================================JJH
;        LDX     #BLSTY           ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
         LDU     #EBLYD2          ;  .    .    .
         LDA     #$20             ;  .    .    .
         JSR     EXPDSP           ;  .    .    .
;
;==========================================================================JJH
;        LDX     #BLSTY           ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
         LDU     #EBLYD3          ;  .    .    .
         LDA     #$30             ;  .    .    .
         JSR     EXPDSP           ;  .    .    .
;
;
TAIL5    LDA     EXPTMR           ;  DISPLAY BLASTER EXPLOSION
;
;==========================================================================JJH
;        SUBA    #$02             ;  CODE DELETED - REV. B CHANGES   ======JJH
;        STA     EXPTMR           ;  .                               ======JJH
;        CMPA    #$30             ;  .                               ======JJH
;        BLT     TAIL6            ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         SUBA    #$02             ;  CODE ADDED - REV. B CHANGES     ======JJH
         CMPA    #$28             ;  .                               ======JJH
         BLT     TAIL6            ;  .                               ======JJH
         STA     EXPTMR           ;  .                               ======JJH
;==========================================================================JJH
;
         LDX     #EBLST1          ;  HANDLE FRAGMENT #1
         LDU     #RGRD1           ;  .
         LDY     #EBLYD1          ;  .
         LDA     #$FE             ;  .
         JSR     MOVEXP           ;  .
;
         LDX     #EBLST2          ;  HANDLE FRAGMENT #2
         LDU     #RGRD2           ;  .
         LDY     #EBLYD2          ;  .
         LDA     #$02             ;  .
         JSR     MOVEXP           ;  .
;
         LDX     #EBLST3          ;  HANDLE FRAGMENT #3
         LDU     #RGRD3           ;  .
         LDY     #EBLYD3          ;  .
         LDA     #$FD             ;  .    .
         JSR     MOVEXP           ;  .
;
         PSHS    DP               ;  DRAW BLASTER SEGMENTS
         LDA     #$D0             ;  .    SET 'DP' TO I/O
         TFR     A,DP             ;  .    .
         direct   $D0              ;  .    .
;
         LDA     EXPTMR           ;  .    SET INTENSITY
         JSR     INTENS           ;  .    .
;
;==========================================================================JJH
;        LDD     EBLYX1           ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD1           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     BLSTSZ           ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
;        LDD     EBLYX2           ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD2           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     BLSTSZ           ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
;        LDD     EBLYX3           ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD3           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     BLSTSZ           ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDX     #RGRD1           ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDY     EBLYX1           ;  .                               ======JJH
         LDB     BLSTSZ           ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;                                                                    ======JJH
         LDX     #RGRD2           ;  .                               ======JJH
         LDY     EBLYX2           ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;                                                                    ======JJH
         LDX     #RGRD3           ;  .                               ======JJH
         LDY     EBLYX3           ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;==========================================================================JJH
;
         PULS    DP               ;  .    SET 'DP' TO RAM
         direct   $C8              ;  .    .
         BRA     TAIL99           ;  .    WAIT FOR EXPLOSION TO FINISH
;
;
;==========================================================================JJH
;TAIL6   JSR     ACTPTR           ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
TAIL6    LDA     KILFLG           ;  CODE ADDED - REV. B CHANGES     ======JJH
         BNE     TAIL99           ;  .                               ======JJH
TAIL6A   JSR     ACTPTR           ;  .                               ======JJH
;==========================================================================JJH
         DEC     6,Y              ;  .    .
;
         LDD     TOTGRD           ;  .    .    SAVE REMAINING GUARDIANS/BIRDS
         ADDA    CGRD             ;  .    .    .    CALC REMAINING GUARDIANS+1
         INCA                     ;  .    .    .    .
         ADDB    CBRD             ;  .    .    .    CALC REMAINING BIRDS
         STD     4,Y              ;  .    .    .
;
         LDA     PLAYRS           ;  .    SWITCH PLAYERS ?
         BEQ     TAIL41           ;  .    .
;
TAIL7    LDA     TBLPT1 + 6       ;  .    CONTINUE GAME ?
;
;==========================================================================JJH
;        ORA     TBLPT2 + 6       ;  CODE DELETED - REV. B CHANGES   ======JJH
;        BEQ     TAIL42           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         ANDA    TBLPT2 + 6       ;  CODE ADDED - REV. B CHANGES     ======JJH
         BMI     TAIL42           ;  .                               ======JJH
;==========================================================================JJH
;
         LDA     ACTPLY           ;  .    BUMP PLAYER FLAG
         ADDA    #$02             ;  .    .
         ANDA    #$02             ;  .    .
         STA     ACTPLY           ;  .    .
;
         JSR     ACTPTR           ;  .    DOES NEW PLAYER HAVE ANY BLASTERS ?
         LDB     6,Y              ;  .    .    IF NOT, SWITCH PLAYERS AGAIN
;
;==========================================================================JJH
;        BEQ     TAIL7            ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         BMI     TAIL7            ;  CODE ADDED - REV. B CHANGES     ======JJH
         BRA     TAIL88           ;  .                               ======JJH
;==========================================================================JJH
;
;
;==========================================================================JJH
;TAIL41  LDA     BLSCNT           ;  CODE DELETED - REV. B CHANGES   ======JJH
;        BNE     TAIL88           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
TAIL41   LDA     TBLPT1 + 6       ;  CODE ADDED - REV. B CHANGES     ======JJH
         BGE     TAIL88           ;  .                               ======JJH
;==========================================================================JJH
;
TAIL42   LDA     #$01             ;  .    LOCK-UP ON GAME SEQUENCE
         STA     LOCK             ;  .    .
;
;
TAIL88   ANDCC   #$FE             ;  SET 'C' TO '0' - LEVEL COMPLETE
         RTS                      ;  .    RETURN TO CALLER
;
;
TAIL99   ORCC    #$01             ;  SET 'C' TO '1' - MORE GAME LOGIC
         RTS                      ;  .    RETURN TO CALLER
;
;
;         IF      L.TAIL = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
