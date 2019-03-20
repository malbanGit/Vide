;
;
;         IF      L.MAIN = OFF     ;-------------------------------------------
;         LIST    -L               ;--  MAIN  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  MAIN GAME LEVEL SEQUENCER
;  =========================
;
SEQNCR   JSR     ACTPTR           ;  BUMP TO NEW GAME FIELD
         LDB     3,Y              ;  .
         PSHS    B                ;  .
         CMPB    #$03             ;  .    RETURNING FROM KILLER ?
         BEQ     SQNC2            ;  .    .
;
         LDB     2,Y              ;  .    FETCH GUARDIAN TYPE FOR PLAYER
         ADDB    #$08             ;  .    .    CALC NEXT GUARDIAN TYPE
         CMPB    #$11             ;  .    .    RESTART AT NEXT LEVEL ?
         BLE     SQNC3            ;  .    .    .
;
;==========================================================================JJH
;        INC     0,S              ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         INC     ,S               ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
         LDB     #$01             ;  .    .    RESET GUARDIAN TYPE
         BRA     SQNC3            ;  .    .    .
;
;
;==========================================================================JJH
;SQNC2   CLR     0,S              ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
SQNC2    CLR     ,S               ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
         LDB     #$01             ;  .    .
         LDX     ,Y               ;  .    .    LAST GAME LEVEL FOUND ?
         LDA     ,X               ;  .    .    .
         INCA                     ;  .    .    .
         BNE     SQNC1            ;  .    .    .
         LDX     #GAMOVR          ;  .    .    .    RESET LEVEL TABLE POINTER
         BRA     SQNC1            ;  .    .
;
SQNC3    LDX     ,Y               ;  .    BUMP GAME DATA POINTER FOR PLAYER
         LEAX    LLEN,X           ;  .    .
;
SQNC1    STX     ,Y               ;  .    .    SAVE CURRENT LEVEL STUFF
         STB     2,Y              ;  .    .    .    GUARDIAN TYPE
         PULS    B                ;  .    .    .    LEVEL FLAG
         STB     3,Y              ;  .    .    .    .
;
         CLR     4,Y              ;  .    RESET GUARDIAN/BIRD COUNTER MODIFIER
         CLR     5,Y              ;  .    .
;
;==========================================================================JJH
         BRA     RSTLVL           ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
;
;
;==========================================================================JJH
RSTLV0   JSR     CLRGAM           ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
RSTLVL   LDA     #$33             ;  RE-START INDICATED GAME LEVEL
         STA     SBTN             ;  .    SET DEBOUNCE FLAGS
;
         JSR     FSTCLR           ;  .    CLEAR-UP SOME MISC. SHIT
;
         LDA     #$01             ;  .    SET ACTIVE FLAG (FOR FIRST PASS)
         STA     ACTIVE           ;  .    .
;
         CLR     KILFLG           ;  .    CLEAR KILLER SEQUENCE FLAG
;
;==========================================================================JJH
;        CLR     ABORT            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        CLR     LOCK             ;  .    CLEAR LOCK-UP FLAG         ======JJH
;==========================================================================JJH
;
         JSR     ACTPTR           ;  .    SET-UP FOR INDICATED LEVEL
         LDD     2,Y              ;  .    .    SET GUARDIAN TYPE
         STA     GRDTYP           ;  .    .    .
         LDA     6,Y              ;  .    .    SET BLASTER COUNT
         STA     BLSCNT           ;  .    .    .
         STB     LFLAG            ;  .    .    .
         CMPB    #$03             ;  .    .    SKIP TO KILLER SEQUENCE ?
         LBEQ    KILLER           ;  .    .    .
;
         LDU     ,Y               ;  .    SET-UP LEVEL PARAMETERS
         LDX     #GAMCMD          ;  .    .
         LDA     #LLEN            ;  .    .
         JSR     BLKMOV           ;  .    .
;
         LDA     4,Y              ;  .    MODIFY GUARDIAN/BIRD COUNTERS ?
         BEQ     RSTLV1           ;  .    .
         LDB     5,Y              ;  .    .
         STD     TOTGRD           ;  .    .
;
RSTLV1   LDU     #GRDTUN          ;  SET GUARDIAN ENTRANCE TUNE
         JSR     SPLAY            ;  .
;
         LDA     #$01             ;  SET BLASTER ON ROADWAY FLAG
         STA     CITFLG           ;  .
;
         LDX     #GRDINS          ;  SET-UP PROGRAMMABLE TIMERS
         STX     TMR1 + 1         ;  .    GUARDIAN INSERTION
         LDA     #$1F             ;  .    .
         STA     TMR1             ;  .    .
         LDX     #BRDINS          ;  .    WAR-BIRD INSERTION
         STX     TMR2 + 1         ;  .    .
         LDA     #$5F             ;  .    .
         STA     TMR2             ;  .    .
;
         JSR     RANDOM           ;  SET-UP RANDOM SPIKER RELEASE TIMER
         STA     SPKTIM           ;  .
;
         JSR     INTROD           ;  SET-UP INDICATED ROADWAY
         BRA     FIELD            ;  START FIELD RELATED SEQUENCING
;
;
;
MLOCK    JSR     LOCKUP           ;  LOCK-UP ON GAME SEQUENCE
;
;
FIELD    PSHS    DP               ;  HANDLE CURRENT GAME LEVEL
;
         JSR     WAIT             ;  .    WAIT FOR FRAME BOUNDARY
         JSR     CITDEL           ;  .    DRAW PLAY FIELD
;
         PULS    DP               ;  .    SET 'DP' TO RAM
         direct   $C8              ;  .    .
;
         JSR     BTNACT           ;  .    CHECK FOR PLAYER ACTIVITY
         DEC     SPKTIM           ;  .    RELEASE A SPIKER THIS FRAME ?
         BNE     FLD3             ;  .    .
;
         JSR     RELSPK           ;  .    .    ATTEMPT TO RELEASE SPIKER
         JSR     RANDOM           ;  .    .    .    SET NEW RELEASE TIME
         ANDA    #$3F             ;  .    .    .    .
         ADDA    #$04             ;  .    .    .    .    ADD INSERTION BIAS
         STA     SPKTIM           ;  .    .    .    .
;
;
FLD3     JSR     GBLAST           ;  .    HANDLE BLASTER GAME LOGIC
         JSR     GBULET           ;  .    HANDLE BULLET GAME LOGIC
         JSR     GGUARD           ;  .    HANDLE GUARDIAN GAME LOGIC
         JSR     GSPIKE           ;  .    HANDLE SPIKER GAME LOGIC
         JSR     GBIRD            ;  .    HANDLE WAR-BIRD GAME LOGIC
         JSR     CBULT            ;  .    HANDLE BULLET VS. GUARDIAN COLLISIONS
         JSR     CGUARD           ;  .    HANDLE BLASTER VS. GUARDIAN COLLISIONS
         JSR     CSPIKE           ;  .    HANDLE BULLET VS. SPIKER COLLISIONS
         JSR     CBIRD            ;  .    HANDLE BULLET VS. WAR-BIRD COLLISIONS
         JSR     SOUND            ;  .    HANDLE TUNES AND SOUND-EFFECTS
         JSR     TAIL             ;  .    HANDLE TAIL-END LOGIC
         BCS     FIELD            ;  .    .
;
         LDA     ABORT            ;  GAME OVER !
         LBEQ    SEQNCR           ;  .
;
         LDA     LOCK             ;  .    GAME WAS ABORTED
         BNE     MLOCK            ;  .    .    LOCK-UP ON THIS GAME LEVEL ?
;
;==========================================================================JJH
;        JSR     CLRGAM           ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JMP     RSTLVL           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JMP     RSTLV0           ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
;
;         IF      L.MAIN = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
