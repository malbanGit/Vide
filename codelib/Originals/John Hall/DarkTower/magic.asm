;
;
;         IF      L.MAG = OFF      ;-------------------------------------------
;         LIST    -L               ;--  MAGIC  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***********************************************************
;  ***********************************************************
;  ***                                                     ***
;  ***          M A G I C I A N   S U B - P L O T          ***
;  ***                                                     ***
;  ***********************************************************
;  ***********************************************************
;
;  MAGICIAN SEQUENCER
;  ==================
;
         direct   $D0
;        =====   ===
;
MAGIC    JSR     SAVGRD           ;  SAVE GRID SCAN VALUES
         JSR     WRKCLR           ;  CLEAR OVER-LAYED STORAGE
;
         PSHS    DP               ;  INITIALIZE WARRIOR FOR BOX ACTION
         JSR     BOXWAR           ;  .
         direct   $C8              ;  .
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
;
MENT1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BEQ     MENT2            ;  .
         DEC     BRSDLY           ;  .
         BRA     MENT3            ;  .
;
MENT2    LDD     #$CD00           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WARINT           ;  .    SET WARRIOR INTENSITY MODIFIER
;
MENT3    JSR     FIGHT            ;  HANDLE WARRIOR LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR ENTRANCE ?
         BNE     MENT1            ;  .
;
;
;
;        WIZARDS ENTRANCE TO BOX
;        -----------------------
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     #$80             ;  SET-UP FOR STAR-BURST
         STA     BRSFLG           ;  .
         LDA     #$3F             ;  .
         STA     BRSTMR           ;  .
         LDA     #$68             ;  .    SET-UP STAR-BURST DELAY
         STA     BRSDLY           ;  .    .
         LDA     #$7F             ;  .    SET WIZARD INTENSITY MODIFIER
         STA     WZINT            ;  .    .
;
         LDU     #FFARE2          ;  SET-UP WIZARD ENTRY TUNE
         JSR     SPLAY            ;  .
;
WENT1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BEQ     WENT2            ;  .
         DEC     BRSDLY           ;  .
         BRA     WENT3            ;  .
;
WENT2    LDD     #$1000           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WZINT            ;  .    SET WIZARD INTENSITY MODIFIER
;
WENT3    CLR     WZCNT            ;  DRAW WIZARD
         JSR     WIZDSP           ;  .
         JSR     FIGHT            ;  HANDLE WARRIOR LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR ENTRANCE ?
         BNE     WENT1            ;  .
;
;
;
;        HANDLE WIZARD ANIMATION
;        -----------------------
;
         CLR     WZCNT            ;  SET-UP WIZARD ANIMATION
         CLR     WZDON            ;  .
;
MGIC1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .
;
         JSR     WIZARD           ;  DRAW WIZARD
         JSR     FIGHT            ;  HANDLE WARRIOR LOGIC
;
         LDA     WZDON            ;  IS WIZARD ANIMATION DONE ?
         BNE     WGNT1            ;  .
;
         BRA     MGIC1            ;  REPEAT MAGICIAN SEQUENCE
;
;
;
;        HANDLE WIZARD GRANT (IF ANY)
;        ----------------------------
;
WGNT1    LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         JSR     RANDOM           ;  IS THE WIZARD A FINK ?
         CMPA    #$80             ;  .    DO A WINDOW TEST ON RNG
         BLS     WGNT2            ;  .    .
         CMPA    #$90             ;  .    .
         LBLS    WGNT10           ;  .    .
;
WGNT2    LDD     BGOLD            ;  DETERMINE WIZARDS ATTEMPTED GRANT
         CMPD    #GLDPRC          ;  .    GRANT GOLD KEY ?
         BLT     WGNT3            ;  .    .
         JSR     FNDGKY           ;  .    .    ATTEMPT TO GRANT KEY
         LBNE    WGNT11           ;  .    .    .
;
WGNT3    LDD     BGOLD            ;  .    GRANT CRYSTAL CROWN ?
         CMPD    #CRWPRC          ;  .    .
         BLT     WGNT4            ;  .    .
         JSR     FNDCRW           ;  .    .    ATTEMPT TO GRANT CROWN
         BNE     WGNT11           ;  .    .    .
;
WGNT4    LDD     BGOLD            ;  .    GRANT SILVER KEY ?
         CMPD    #SLVPRC          ;  .    .
         BLT     WGNT5            ;  .    .
         JSR     FNDSKY           ;  .    .    ATTEMPT TO GRANT KEY
         BNE     WGNT11           ;  .    .    .
;
WGNT5    LDD     BGOLD            ;  .    GRANT BRONZE KEY ?
         CMPD    #BRZPRC          ;  .    .
         BLT     WGNT6            ;  .    .
         JSR     FNDBZK           ;  .    .    ATTEMPT TO GRANT KEY
         BNE     WGNT11           ;  .    .    .
;
WGNT6    LDD     BGOLD            ;  .    GRANT BRASS KEY ?
         CMPD    #BRSPRC          ;  .    .
         BLT     WGNT7            ;  .    .
         JSR     FNDBSK           ;  .    .    ATTEMPT TO GRANT KEY
         BNE     WGNT11           ;  .    .    .
;
WGNT7    LDD     BGOLD            ;  .    GRANT SCOUT ?
         CMPD    #SCTPRC          ;  .    .
         BLT     WGNT8            ;  .    .
         LDA     SCTFLG           ;  .    .    ATTEMPT TO GRANT SCOUT
         BNE     WGNT8            ;  .    .    .    ALREADY ASSIGNED ?
         INC     SCTFLG           ;  .    .    GRANT SCOUT
         LDA     #$04             ;  .    .    .    SET SCOUT USAGE COUNTER
         STA     SCTCNT           ;  .    .    .    .
         LDX     #PLYSCR          ;  .    .    .    ADD VALUE TO SCORE
         LDD     #$0300           ;  .    .    .    .
         JSR     SCRADD           ;  .    .    .    .
         LDA     #$0C             ;  .    .    .    SET MESSAGE NUMBER
         BRA     WGNT11           ;  .    .    .
;
WGNT8    LDD     BGOLD            ;  .    GRANT HEALER ?
         CMPD    #HLRPRC          ;  .    .
         BLT     WGNT9            ;  .    .
         LDA     HLRFLG           ;  .    .    ATTEMPT TO GRANT HEALER
         BNE     WGNT9            ;  .    .    .    ALREADY ASSIGNED ?
         INC     HLRFLG           ;  .    .    GRANT HEALER
         LDA     #$04             ;  .    .    .    SET HEALER USAGE COUNTER
         STA     HLRCNT           ;  .    .    .    .
         LDX     #PLYSCR          ;  .    .    .    ADD VALUE TO SCORE
         LDD     #$300            ;  .    .    .    .
         JSR     SCRADD           ;  .    .    .    .
         LDA     #$0E             ;  .    .    .    SET MESSAGE NUMBER
         BRA     WGNT11           ;  .    .    .
;
WGNT9    LDD     BGOLD            ;  .    GRANT WARRIOR ?
         CMPD    #WARPRC          ;  .    .
         BLT     WGNT10           ;  .    .
         JSR     FNDWAR           ;  .    .    ATTEMPT TO GRANT WARRIOR
         BNE     WGNT11           ;  .    .    .
;
;
WGNT10   CLRA                     ;  TREASURE WAS NOT GRANTED
         JSR     SETMSG           ;  .    SET-UP 'BE GONE' MESSAGE
         BRA     WEXT1            ;  .    .
;
WGNT11   JSR     SETMSG           ;  A TREASURE HAS BEEN GRANTED
;
         LDX     #M_BAGS          ;  .    WIZARD TAKE MOST OF THE GOLD
         LDU     #GOLD            ;  .    .    RE-INITIALIZE BAGS OF GOLD MESSAGE
         JSR     SMOVE            ;  .    .    .
;
         JSR     RANDOM           ;  .    .    LEAVE A LITTLE GOLD FOR THE PLAYER
         ANDA    #$07             ;  .    .    .
         ADDA    #$02             ;  .    .    .    PLAYER ALWAYS HAS SOME GOLD
         STA     BGOLD + 1        ;  .    .    .    .
         CLR     BGOLD            ;  .    .    .    .
         ORA     #$30             ;  .    .    .    MAKE ASCII AND STICK IN MESSAGE
         STA     GOLD + 3         ;  .    .    .    .
;
;
;
;        HANDLE WIZARDS EXIT FROM BOX
;        ----------------------------
;
;
WEXT1    LDA     #$01             ;  SET-UP FOR STAR-BURST
         STA     BRSFLG           ;  .
         CLR     BRSTMR           ;  .
         LDA     #$0F             ;  .    SET-UP STAR-BURST DELAY
         STA     BRSDLY           ;  .    .
;
WEXT2    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BEQ     WEXT3            ;  .
         DEC     BRSDLY           ;  .
         BRA     WEXT4            ;  .
;
WEXT3    LDD     #$1000           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WZINT            ;  .    SET WIZARD INTENSITY MODIFIER
;
;
WEXT4    JSR     UPDMSG           ;  HANDLE TREASURE MESSAGE
         JSR     WIZDSP           ;  DRAW WIZARD
         JSR     FIGHT            ;  HANDLE WARRIOR LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR EXIT ?
         BNE     WEXT2            ;  .
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
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
MEXT1    JSR     INVENT           ;  DISPLAY INVENTORY PAGE OR PAUSE ?
         direct   $D0              ;  .    SET 'DP' = I/O
;
         LDA     BRSDLY           ;  DECREMENT STAR-BURST TIMER
         BEQ     MEXT2            ;  .
         DEC     BRSDLY           ;  .
         BRA     MEXT3            ;  .
;
MEXT2    LDD     #$CD00           ;  DISPLAY STAR-BURST
         JSR     DHYPER           ;  .
         STA     WARINT           ;  .    SET WARRIOR INTENSITY MODIFIER
;
MEXT3    JSR     UPDMSG           ;  HANDLE TREASURE MESSAGE
         JSR     FIGHT            ;  HANDLE WARRIOR LOGIC
;
         LDA     BRSFLG           ;  CONTINUE WARRIOR EXIT ?
         BNE     MEXT1            ;  .
;
         JMP     RFRST            ;  RETURN TO FOREST SEQUENCE
;
;         IF      L.MAG = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
