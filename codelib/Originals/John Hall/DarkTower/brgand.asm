;
;
;         IF      L.BRG = OFF      ;-------------------------------------------
;         LIST    -L               ;--  BRGAND  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  *********************************************************
;  *********************************************************
;  ***                                                   ***
;  ***          B R I G A N D   S U B - P L O T          ***
;  ***                                                   ***
;  *********************************************************
;  *********************************************************
;
;  BRIGAND SEQUENCER
;  =================
;
         direct   $D0
;        =====   ===
;
BRGAND   JSR     SAVGRD           ;  SAVE GRID SCAN VALUES
         JSR     WRKCLR           ;  CLEAR OVER-LAYED STORAGE
;
         LDX     #BRGINT          ;  INITIALIZE BRIGAND TABLE
         LDU     #BRGTBL          ;  .
         LDB     #BRGEND - BRGINT ;  .
BGINT1   LDA     ,X+               ;  .
         STA     ,U+               ;  .
         DECB                     ;  .
         BNE     BGINT1           ;  .
;
         PSHS    DP               ;  INITIALIZE WARRIOR FOR BOX ACTION
         JSR     BOXWAR           ;  .
         direct   $C8              ;  .
;
         JSR     RANDOM           ;  SET-UP BRIGAND INSERTION HANDLER
         ANDA    #$7F             ;  .
         ORA     #$80             ;  .
         STA     TMR2             ;  .
;
;
;
;        WARRIORS ENTRANCE TO BOX
;        ------------------------
;
         LDA     #$80             ;  SET-UP FOR STAR-BURST
         STA     BRSFLG           ;  .
         LDA     #$3F             ;  .
         STA     BRSTMR           ;  .
         LDA     #$1F             ;  .    SET-UP STAR-BURST DELAY
         STA     BRSDLY           ;  .    .
         LDA     #$01             ;  .    SET WARRIOR INHIBIT
         STA     WARINH           ;  .    .
;
         LDU     #BRGFAN          ;  SET-UP ENTRANCE TUNE
         JSR     SPLAY            ;  .
;
BENT1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BLE     BENT2            ;  .
         DEC     BRSDLY           ;  .
         BRA     BENT3            ;  .
;
BENT2    LDD     #$CD00           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WARINT           ;  .    SET WARRIOR INTENSITY MODIFIER
;
BENT3    JSR     FIGHT            ;  HANDLE WARRIOR FIGHTING LOGIC
         JSR     GOBLIN           ;  HANDLE GOBLIN LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR ENTRANCE ?
         BNE     BENT1            ;  .
;
;
;
;        HANDLE BRIGAND FIGHT SEQUENCE
;        -----------------------------
;
         CLR     WARINH           ;  RELEASE WARRIOR INHIBIT
;
BRGN1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         JSR     FIGHT            ;  HANDLE WARRIOR FIGHTING LOGIC
         JSR     GOBLIN           ;  HANDLE GOBLIN LOGIC
         JSR     FLAMER           ;  HANDLE FLAMOID LOGIC
         JSR     FRGMNT           ;  HANDLE FRAGMENT LOGIC
         JSR     COLIDE           ;  HANDLE COLLISIONS
;
         LDA     EXPEND           ;  ARE EXPLOSIONS PENDING ?
         BNE     BRGN1            ;  .
;
         LDA     WARFLG           ;  IS SUB-PLOT OVER ?
         BEQ     RFRST            ;  .    WAS WARRIOR KILLED ?
         LDA     CBXAMT           ;  .    HAS ENOUGH GOBLINS BEEN KILLED ?
         BPL     BRGN1            ;  .    .
         LDA     GBLACT           ;  .    ARE ANY GOBLINS VISIBLE ?
         BNE     BRGN1            ;  .    .
         LDA     GBLKIL           ;  .    WAS THE LAST GOBLIN KILLED ?
         BEQ     BRGN1            ;  .    .    WAIT FOR NEXT GOBLIN
;
;
;
;        HANDLE TREASURE SELECTION AND DISPLAY
;        -------------------------------------
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .  
;
         CLR     TMR2             ;  RESET BRIGAND INSERTION TIMER
;
         LDA     #$01             ;  SET WARRIOR INHIBIT
         STA     WARINH           ;  .
;
         LDU     #TRSBRG          ;  SELECT TREASURE FOR SUCCESSFUL WARRIOR
         JSR     SELTRS           ;  .
         JSR     SETMSG           ;  .
;
BTRS1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         JSR     UPDMSG           ;  HANDLE TREASURE MESSAGE
         JSR     FIGHT            ;  HANDLE WARRIOR FIGHTING LOGIC
         JSR     GOBLIN           ;  HANDLE GOBLIN LOGIC
         JSR     FLAMER           ;  HANDLE FLAMOID LOGIC
         JSR     FRGMNT           ;  HANDLE FRAGMENT LOGIC
;
         LDA     MSGFRM           ;  CONTINUE TREASURE MESSAGE ?
         CMPA    #$60             ;  .
         BLT     BTRS1            ;  .
;
;
;
;        HANDLE WARRIORS EXIT FROM BOX
;        -----------------------------
;
         LDA     #$01             ;  SET-UP FOR STAR-BURST
         STA     BRSFLG           ;  .
         CLR     BRSTMR           ;  .
         LDA     #$0F             ;  .    SET-UP STAR-BURST DELAY
         STA     BRSDLY           ;  .    .
;
BEXT1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BLE     BEXT2            ;  .
         DEC     BRSDLY           ;  .
         BRA     BEXT3            ;  .
;
BEXT2    LDD     WARSCY           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WARINT           ;  .    SET WARRIOR INTENSITY MODIFIER
;
BEXT3    JSR     UPDMSG           ;  HANDLE TREASURE MESSAGE
         JSR     FIGHT            ;  HANDLE WARRIOR FIGHTING LOGIC
         JSR     GOBLIN           ;  HANDLE GOBLIN LOGIC
         JSR     FLAMER           ;  HANDLE FLAMOID LOGIC
         JSR     FRGMNT           ;  HANDLE FRAGMENT LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR EXIT ?
         BNE     BEXT1            ;  .
;
;
RFRST    LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         CLR     TMR2             ;  RESET PROGRAMMABLE TIMERS
         CLR     TMR3             ;  .
;
         JSR     PNTWAR           ;  RE-INITIALIZE POINT WARRIOR
;
         LDA     WARFLG           ;  WAS WARRIOR KILLED ?
         BNE     RFRST1           ;  .
         LDU     #DEDTUN          ;  .     PLAY DEAD WARRIOR TUNE
         JSR     SPLAY            ;  .    .
;
RFRST1   LDA     #$7F             ;  SET WARRIOR INTENSITY MODIFIER
         STA     WARINT           ;  .
;
         JSR     WRKCLR           ;  CLEAR OVER-LAYED STORAGE
         JSR     GRDSCN           ;  RE-CALCULATE FOREST PROJECTIONS
         JSR     RSTGRD           ;  RESTORE RETAINED GRID VALUES
;
         PULS    DP,PC            ;  RETURN TO FOREST
;
;         IF      L.BRG = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
