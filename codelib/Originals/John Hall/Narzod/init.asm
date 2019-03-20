;
;
;         IF      L.INIT = OFF     ;-------------------------------------------
;         LIST    -L               ;--  INIT  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          R E A D - O N L Y   M E M O R Y          ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
 code
         ORG     $0000
;        ===     =====
;
;==========================================================================JJH
;        DB      $67,' GCE 1982',$80   ;  CODE DELETED - REV. A       =====JJH
;==========================================================================JJH
;
;==========================================================================JJH
         DB      $67,' GCE 1983',$80   ;  CODE ADDED - REV. A         =====JJH
;==========================================================================JJH
         DW      WAGNER
;
         DW      $F850
         DW      $30D0
         DB      'FORTRESS',$80
         DW      $F850
         DW      $10F0
         DB      'OF',$80
         DW      $F850
         DW      $F0D8
         DB      'NARZOD',$80
         DB      0
;
;
;
;  POWER-UP INITIALIZATION
;  =======================
;
         direct   $D0
;        =====   ===
;
;
ENTRY    JSR     DPRAM            ;  SET "DP" REGISTER FOR RAM
         direct   $C8              ;  .
;
         INC     ZSKIP            ;  SET POST-PACKET ZEROING FLAG
;
         LDA     #$FF             ;  RESET DASHING
         STA     DASH             ;  .
;
;
;
;
;  INITIALIZE CITADEL
;  ==================
;
GAME1    LDA     #$BB             ;  SET-UP CONTROLLER FLAGS
         STA     SBTN             ;  .
         LDX     #$0103           ;  .
         STX     SJOY             ;  .
;
         LDD     #$0203           ;  SELECT OPTIONS
         JSR     SELOPT           ;  .
         DEC     PLAYRS           ;  .
;
;
GAME2    LDX     #ETMP1           ;  CLEAR MEMORY
CLRALL   CLR     ,X+               ;  .
         CMPX    #ENDRAM          ;  .
         BNE     CLRALL           ;  .
;
         LDD     #$1000           ;  SET GAME-OVER TIME-OUT DURATION
         STD     TIMOUT           ;  .
;
         LDX     #SCOR1           ;  CLEAR PLAYERS SCORE
         JSR     SCLR             ;  .
         LDX     #SCOR2           ;  .
         JSR     SCLR             ;  .
;
         LDD     #$0100           ;  SET-UP GAME-LEVEL TABLE POINTERS
         STD     TBLPT1 + 2       ;  .    SET GUARDIAN TYPE & LEVEL FLAG
         STD     TBLPT2 + 2       ;  .    .
;
         LDA     OPTION           ;  .    SET SELECTED OPTION NUMBER
         DECA                     ;  .    .
         LSLA                     ;  .    .
         LDX     #OPTLVL          ;  .    .
         LDU     A,X              ;  .    .
         STU     TBLPT1           ;  .    .
         STU     TBLPT2           ;  .    .
;
         LDX     #FIELD1          ;  .    SET ACTIVE GAME LEVEL COUNTER
         JSR     SCLR             ;  .    .    FOR PLAYER #1
         LDA     1,U              ;  .    .    .
         JSR     BYTADD           ;  .    .    .
         LDX     #FIELD2          ;  .    .    FOR PLAYER #2
         JSR     SCLR             ;  .    .    .
         LDU     TBLPT2           ;  .    .    .
         LDA     1,U              ;  .    .    .
         JSR     BYTADD           ;  .    .    .
;
         LDA     #5               ;  .    SET BLASTER COUNTERS
         STA     BLSCNT           ;  .    .
         STA     TBLPT1 + 6       ;  .    .
         STA     TBLPT2 + 6       ;  .    .
;
;==========================================================================JJH
;        JSR     CLRGAM           ;  CODE DELETED - REV. B CHANGES   ======JJH
;        CLR     ACTPLY           ;  .                               ======JJH
;        BRA     RSTLVL           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         CLR     ACTPLY           ;  CODE ADDED - REV. B CHANGES     ======JJH
         BRA     RSTLV0           ;  .                               ======JJH
;==========================================================================JJH
;
;
;         IF      L.INIT = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
