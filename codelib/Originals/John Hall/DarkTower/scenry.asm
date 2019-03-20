;
;
;         IF      L.SCN = OFF      ;-------------------------------------------
;         LIST    -L               ;--  SCENRY  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  OPEN IN-FRONT BOX ?
;  ===================
;
         direct   $C8
;        =====   ===
;
SCENRY   PSHS    DP               ;  SAVE ENTRY VALUES
;
         LDY     CBXSCN           ;  SET-UP IN-FRONT BOX ACTIVITY POINTER
         BEQ     SCNRY3           ;  .    IS AN OBJECT IN-FRONT ?
;
         JSR     TSTACT           ;  .    CALCULATE POINTERS
         STA     CBXACT           ;  .    .
         LDD     ETMP1            ;  .    .
         STD     CBXPTR           ;  .    .
         LDA     ETMP3            ;  .    .
         STA     CBXBIT           ;  .    .
;
;
         LDA     OPEN             ;  OPEN / CLOSE BOX ?
         BEQ     SCNRY3           ;  .    HAS OPEN BUTTON BEEN PUSHED ?
         LDA     [CBXOBJ]         ;  .    IS IN-FRONT OBJECT A BOX ?
         ANDA    #$E0             ;  .    .
         CMPA    #$80             ;  .    .
         BNE     SCNRY3           ;  .    .
         LDA     WARFLG           ;  .    IS A WARRIOR REQUEST PENDING ?
         BEQ     SCNRY3           ;  .    .
         LDA     FOGFLG           ;  .    IS FOG OR PLAGUE PENDING ?
         ORA     PLGFLG           ;  .    .
         ORA     TSTAT            ;  .    IS A TUNE PENDING ?
         BNE     SCNRY3           ;  .    .
;
         LDA     SCNCMD,Y         ;  .    IS BOX ALREADY OPENING ?
         BITA    #$02             ;  .    .
         BNE     SCNRY1           ;  .    .
         BITA    #$FE             ;  .    IS BOX ALREADY CYCLING ?
         BNE     SCNRY3           ;  .    .
;
         LDA     #$03             ;  OPEN BOX
         STA     SCNCMD,Y         ;  .    SET COMMAND BYTE FOR OPENING
         LDA     #$01             ;  .    SET ANIMATION TIMER
         STA     SCNTMR,Y         ;  .    .
         LDA     #$30             ;  .    SET BOX SQUEAK FLAG
         STA     BOXSQK           ;  .    .
         BRA     SCNRY2           ;  .    .
;
;
SCNRY1   LDA     #$05             ;  CLOSE BOX
         STA     SCNCMD,Y         ;  .    SET COMMAND BYTE FOR CLOSING
SCNRY2   CLR     OPEN             ;  .    MASK BUTTON FOR REST OF FRAME
;
;
SCNRY3   LDA     #$D0             ;  SETP 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         JSR     INTMAX           ;  DISPLAY PEDOMETER
         LDD     #$FB38           ;  .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .
         LDD     #$7F10           ;  .    SET POSITION
         JSR     POSITD           ;  .    .
         LDU     #PEDMTR          ;  .    DRAW RASTER PEDOMETER
         JSR     RASTER           ;  .    .
;
;
;
;  DRAW OBJECT TABLE
;  =================
;
         direct   $D0
;        =====   ===
;
DRWTBL   LDU     #OBJTBL          ;  SET-UP TO SCAN OBJECT TABLE
         LDA     #OBJCNT          ;  .
         STA     DRWCNT           ;  .
;
         LDA     #$FF             ;  SET DASHING PATTERN
         STA     DASH             ;  .
;
DRW0     LDY     OBJPTR,U         ;  IS OBJECT ACTIVE ?
         LDA     <<OBJFLG,U         ;  .
         BEQ     DRW2             ;  .
         BMI     BOXES            ;  .    SPECIAL ANIMATION ?
;
         LDA     SCNDRW,Y         ;  SET DRAW REVERSE FLAG
         STA     RFLAG            ;  .
;
         LDA     #$7F             ;  SET 'Z-AXIS'
         SUBA    OBJSCZ,U         ;  .
         STA     ETMP1            ;  .
         ADDA    #$30             ;  .    SET INTENSITY
         BVC     DRW1             ;  .    .
         LDA     #$7F             ;  .    .
DRW1     SUBA    FOGLIM           ;  .    .    SKIP OBJECT ?
         CMPA    #$20             ;  .    .    .
         BLE     DRW2             ;  .    .    .
;
         LDB     ETMP1            ;  DRAW INDICATED OBJECT
         LSRB                     ;  .    SET ZOOM SIZE
         ADDB    #$08             ;  .    .
         LDX     <<SCNADR,Y         ;  .    SET OBJECT ADDRESS
         LEAY    OBJSCY,U         ;  .    SET OBJECT POSITION
         JSR     SDIFFY           ;  .    DRAW OBJECT
;
DRW2     LEAU    OBJLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     DRWCNT           ;  .
         BNE     DRW0             ;  .
;
         PULS    DP,PC            ;  RETURN TO CALLER
;
;         IF      L.SCN = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;         IF      L.BOX = OFF      ;-------------------------------------------
;         LIST    -L               ;--  BOXES  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SPECIAL ANIMATION FOR FOREST SEQUENCE
;  =====================================
;
         direct   $D0
;        =====   ===
;
BOXES    LDA     <<OBJFLG,U         ;  IS ANOTHER ANIMATION ROUTINE USED ?
         CMPA    #$F2             ;  .    SCENERY GOLD HANDLER REQUIRED ?
         LBEQ    SCNGLD           ;  .    .
         CMPA    #$F0             ;  .    SCENERY KEY HANDLER REQUIRED ?
         LBEQ    SCNKEY           ;  .    .
         CMPA    #$F4             ;  .    DARK TOWER HANDLER REQUIRED ?
         LBEQ    DRWTWR           ;  .    .
         ANDA    #$F0             ;  .    SCENERY FOG OR PLAGUE ?
         CMPA    #$E0             ;  .    .
         BEQ     DRW2             ;  .    .
;
;
         LDA     WARYW            ;  IS STAR-BURST PENDING ?
         LDB     WARXW            ;  .
         JSR     DHYPER           ;  .
         STA     WARINT           ;  .    SET WARRIOR INTENSITY MODIFIER
;
         LDA     SCNCMD,Y         ;  SET WARRIOR MOTION INHIBIT ?
         ANDA    #$3E             ;  .
         ORA     WARINH           ;  .
         STA     WARINH           ;  .
;
         LDA     SCNCMD,Y         ;  WHAT IS CURRENT BOX STATUS ?
         BITA    #$30             ;  .    IS BOX ACTION PENDING ?
         BNE     BOXS4            ;  .    .
         BITA    #$08             ;  .    IS BOX ALREADY FULLY OPENED ?
         BNE     BOXS3            ;  .    .
         BITA    #$FE             ;  .    IS ANY BOX ACTION PENDING ?
         BEQ     BOXS5            ;  .    .
;
;
         LDB     FRAM7            ;  MODERATE ANIMATION RATE
         BNE     BOXS5            ;  .
;
         BITA    #$04             ;  BUMP ANIMATION COUNTER
         BNE     BOXS1            ;  .    IS BOX CLOSING ?
;
         LDA     SCNTMR,Y         ;  .    BOX IS OPENING - INCR ANIMATION TIMER
         INCA                     ;  .    .    END OF BOX OPENING ANIMATION ?
         LSLA                     ;  .    .    .
         LDX     #PBOX1           ;  .    .    .
         LDX     A,X              ;  .    .    .
         BEQ     BOXS2            ;  .    .    .
         LSRA                     ;  .    .    .    SAVE NEW ANIMATION TIMER
         STA     SCNTMR,Y         ;  .    .    .    .
         BRA     BOXS5            ;  .    .
;
;
BOXS1    DEC     SCNTMR,Y         ;  .    BOX IS CLOSING - DECR ANIMATION TIMER
         BNE     BOXS5            ;  .    .
         LDA     #$01             ;  .    .    BOX IS CLOSED
         STA     SCNCMD,Y         ;  .    .    .    RESET ANIMATION FLAG
         BRA     BOXS5            ;  .    .
;
;
BOXS2    LDA     #$09             ;  BOX IS FULLY OPEN - DELAY BEFORE ACTION
         STA     SCNCMD,Y         ;  .    FLAG THAT BOX IS FULLY OPENED
         LDA     #$08             ;  .    SET BOX OPENED DELAY
         STA     CBXDLY           ;  .    .
;
BOXS3    DEC     CBXDLY           ;  .    DECREMENT BOX DELAY TIMER
         BNE     BOXS5            ;  .    .
;
;
BOXS4    LDX     #BOXVCT          ;  BOX IS FULLY OPENED - TAKE ACTION
         LDA     <<OBJFLG,U         ;  .    FETCH OBJECT ACTION VECTOR
         ANDA    #$0E             ;  .    .
         JSR     [A,X]            ;  .    EXECUTE ACTION VECTOR
;  
;
BOXS5    LDA     SCNDRW,Y         ;  DRAW CURRENT BOX
         STA     RFLAG            ;  .    SET DRAW REVERSE FLAG
;
         LDA     #$7F             ;  .    DRAW BOTTOM OF BOX
         SUBA    OBJSCZ,U         ;  .    .    SET 'Z' AXIS
         TFR     A,B              ;  .    .    .
         ADDA    #$20             ;  .    .    .    SET INTENSITY
         BVC     BOXS6            ;  .    .    .    .
         LDA     #$7F             ;  .    .    .    .
BOXS6    SUBA    FOGLIM           ;  .    .    .    .    FACTOR-IN FOG
         CMPA    #$20             ;  .    .    .    .    .
         LBLE    DRW2             ;  .    .    .    .    .
         STA     DRWINT           ;  .    .    .    .
;
         LSRB                     ;  .    .    SET ZOOM SIZE
         SUBB    #$0C             ;  .    .    .    FUDGE BOX SIZE DOWN
         LBLE    DRW2             ;  .    .    .    .
         STB     DRWSIZ           ;  .    .    .
;
         LDX     #PBOX1           ;  .    .    FETCH ANIMATION ADDRESS
         LDA     SCNTMR,Y         ;  .    .    .    BOTTOM OF BOX
         LSLA                     ;  .    .    .    .
         LDX     A,X              ;  .    .    .    .
         STX     DRWLS1           ;  .    .    .    .
         LDX     #PBOX2           ;  .    .    .    BOX LID
         LDX     A,X              ;  .    .    .    .
         STX     DRWLS2           ;  .    .    .    .
;
         LDD     #$0000           ;  .    .    DRAW USING 'DRWLS1/2'
         LEAY    OBJSCY,U         ;  .    .    FETCH SCREEN POSITION
         JSR     CDIFFY           ;  .    .    DRAW BOTTOM OF BOX
;
         JMP     DRW2             ;  .    TRY NEXT OBJECT
;
;
;
;        BOX ACTION HANGLERS
;        -------------------
;
BOXVCT   DW      BOXTRP           ;  DO NOTHING BOX             $80
         DW      BOXGFT           ;  TREASURE BOX               $82
         DW      BOXBRG           ;  BRIGANDS SUB-PLOT          $84
         DW      BOXMAG           ;  MAGICIAN SUB-PLOT          $86
         DW      BOXFOG           ;  FOG TRIGGER                $88
         DW      BOXPLG           ;  PLAGUE TRIGGER             $8A
         DW      BOXTRP           ;  UN-DEFINED                 $8C
         DW      BOXTRP           ;  UN-DEFINED                 $8E
;
;
;
;        TREASURE BOX
;        ------------
;
BOXGFT   LDA     SCNCMD,Y         ;  WHAT IS STATUS OF TREASURE BOX ?
         BITA    #$20             ;  .    COMPLETE ACTION SEQUENCE ?
         BNE     BXGFT2           ;  .    .
         BITA    #$10             ;  .    FIRST PASS ?
         BNE     BXGFT1           ;  .    .
;
         LDA     CBXACT           ;  FIRST PASS
         BNE     BXGFT4           ;  .    HAS THIS BOX BEEN OPENED BEFORE ?
;
         LDA     #$11             ;  .    SET PENDING ACTION FLAG
         STA     SCNCMD,Y         ;  .    .
         PSHS    X,Y,U,DP         ;  .    SET-UP TREASURE MESSAGE
         LDA     #$C8             ;  .    .    SET 'DP' = RAM
         TFR     A,DP             ;  .    .    .
         direct   $C8              ;  .    .    .
         LDU     #TRSBOX          ;  .    .
         JSR     SELTRS           ;  .    .
         JSR     SETMSG           ;  .    .
         LDA     [CBXPTR]         ;  .    SET BOX ACTIVITY POINTER
         ORA     CBXBIT           ;  .    .
         STA     [CBXPTR]         ;  .    .
         PULS    X,Y,U,DP         ;  .    .
         direct   $D0              ;  .    .    SET 'DP' = I/O
;
BXGFT1   JSR     UPDMSG           ;  DISPLAY TREASURE MESSAGE
         LDA     MSGFRM           ;  .    CONTINUE TREASURE MESSAGE ?
         CMPA    #$60             ;  .    .
         BLT     BXGFT3           ;  .    .
;
         LDA     #$21             ;  SET-UP TO CLOSE BOX
         STA     SCNCMD,Y         ;  .
         LDA     #$1F             ;  .
         STA     CBXDLY           ;  .
;
BXGFT2   JSR     UPDMSG           ;  DELAY BEFORE CLOSING BOX
         DEC     CBXDLY           ;  .
         BNE     BXGFT3           ;  .
;
         LDA     #$05             ;  CLOSE BOX
         STA     SCNCMD,Y         ;  .
         LDD     #$0000           ;  .    CLEAR RASTER MESSAGE
         STD     MSGPTR           ;  .    .
;
BXGFT3   RTS                      ;  RETURN TO DRAWING ROUTINE
;
;
BXGFT4   LDA     #$84             ;  BOX HAS BEEN OPENED BEFORE
         STA     <<OBJFLG,U         ;  .    CHANGE TO BRIGAND SEQUENCE
;
;
;
;        BRIGANDS SUB-PLOT
;        -----------------
;
BOXBRG   LDA     SCNCMD,Y         ;  WHAT IS STATUS OF BRIGAND TRIGGER ?
         BITA    #$20             ;  .    COMPLETE ACTION SEQUENCE ?
         LBNE    BOXCLS           ;  .    .
         BITA    #$10             ;  .    FIRST PASS ?
         BNE     BXBRG1           ;  .    .
;
         LDA     #$01             ;  FIRST PASS
         STA     BRSFLG           ;  .    SET-UP EXPANDING STAR-BURST
         CLR     BRSTMR           ;  .    .
         LDA     #$11             ;  .    SET PENDING ACTION FLAG
         STA     SCNCMD,Y         ;  .    .
;
BXBRG1   LDA     BRSFLG           ;  IS EXPANDING STAR-BURST DONE ?
         BNE     BXBRG3           ;  .
;
         LDA     CBXAMT           ;  SET INITIAL BRIGAND COUNT FOR BOX
         BNE     BXBRG2           ;  .    SKIP IF BRIGANDS COUNT ALREADY SET
         JSR     RANDOM           ;  .    SELECT A RANDOM NUMBER
         ANDA    #$03             ;  .    .
         ADDA    #$06             ;  .    .
         STA     CBXAMT           ;  .    .
;
BXBRG2   PSHS    Y,U,DP           ;  HANDLE BRIGAND SUB-PLOT
         JSR     BRGAND           ;  .
         PULS    Y,U,DP           ;  .
;
         LDA     #$21             ;  SET-UP TO CLOSE BOX
         STA     SCNCMD,Y         ;  .
         LDA     #$1F             ;  .
         STA     CBXDLY           ;  .
;
         LDA     WARFLG           ;  DID WARRIOR GET KILLED ?
         BEQ     BXBRG3           ;  .
;
         LDA     #$80             ;  SET-UP CONTRACTING STAR-BURST
         STA     BRSFLG           ;  .
         LDA     #$3F             ;  .
         STA     BRSTMR           ;  .
;
BXBRG3   RTS                      ;  RETURN TO DRAWING ROUTINE
;
;
;
;        MAGICIAN SUB-PLOT
;        -----------------
;
BOXMAG   LDA     CBXACT           ;  HAS THIS BOX BEEN OPENED ALREADY ?
         BNE     BXGFT4           ;  .    IF SO, CHANGE TO BRIGAND SUB-PLOT
;
         LDA     SCNCMD,Y         ;  WHAT IS STATUS OF MAGICIAN TRIGGER ?
         BITA    #$20             ;  .    COMPLETE ACTION SEQUENCE ?
         BNE     BOXCLS           ;  .
         BITA    #$10             ;  .    FIRST PASS ?
         BNE     BXMAG1           ;  .
;
         LDA     #$01             ;  .    SET-UP EXPANDING STAR-BURST
         STA     BRSFLG           ;  .    .
         CLR     BRSTMR           ;  .    .
         LDA     #$11             ;  .    SET PENDING ACTION FLAG
         STA     SCNCMD,Y         ;  .    .
;
BXMAG1   LDA     BRSFLG           ;  IS EXPANDING STAR-BURST DONE ?
         BNE     BXMAG2           ;  .
;
         LDA     [CBXPTR]         ;  SET BOX ACTIVITY FLAG
         ORA     CBXBIT           ;  .
         STA     [CBXPTR]         ;  .
;
         PSHS    Y,U,DP           ;  HANDLE MAGICIAN SUB-PLOT
         JSR     MAGIC            ;  .
         PULS    Y,U,DP           ;  .
;
         LDA     #$21             ;  SET-UP TO CLOSE BOX
         STA     SCNCMD,Y         ;  .
         LDA     #$1F             ;  .
         STA     CBXDLY           ;  .
;
         LDA     #$80             ;  SET-UP CONTRACTING STAR-BURST
         STA     BRSFLG           ;  .
         LDA     #$3F             ;  .
         STA     BRSTMR           ;  .
;
BXMAG2   RTS                      ;  RETURN TO DRAWING ROUTINE
;
;
;
;        FOG TRIGGER
;        -----------
;
BOXFOG   LDA     SCNCMD,Y         ;  FIRST PASS THRU FOG TRIGGER ?
         BITA    #$10             ;  .
         BNE     BOXCLS           ;  .
;
         JSR     FOGSET           ;  FIRST PASS - SET-UP FOG SEQUENCE
;
         LDA     #$FF             ;  .    DELAY BOX CLOSING SO FOG DEVELOPES
         STA     CBXDLY           ;  .    .    SET BOX DELAY TIMER
         BRA     BOXPND           ;  .    .    SET PENDING ACTION FLAG
;
;
;
;        PLAGUE TRIGGER
;        --------------
;
BOXPLG   LDA     SCNCMD,Y         ;  FIRST PASS THRU PLAGUE TRIGGER ?
         BITA    #$10             ;  .
         BNE     BOXCLS           ;  .
;
         LDD     #$0000           ;  FIRST PASS - SET-UP PLAGUE SEQUENCE
         STD     PLGLCK           ;  .    ENABLE PLAGUE TRIGGER
         JSR     PLGSET           ;  .    SET PLAGUE FLAG
;
         LDA     #$4F             ;  .    DELAY BOX CLOSING SO PLAGUE DEVELOPES
         STA     CBXDLY           ;  .    .    SET BOX DELAY TIMER
;
;
;
;        SET PENDING ACTION FLAG
;        -----------------------
;
BOXPND   LDA     #$11             ;  SET PENDING ACTION FLAG
         STA     SCNCMD,Y         ;  .
;
;
;
;        CLOSE BOX
;        ---------
;
BOXCLS   DEC     CBXDLY           ;  DELAY BOX CLOSING
         BNE     BXCLS1           ;  .
         LDA     #$05             ;  .    CLOSE BOX
         STA     SCNCMD,Y         ;  .    .
;
BXCLS1   RTS                      ;  RETURN TO DRAWING ROUTINE
;
;
;
;        UN-DEFINED BOX TRAP
;        -------------------
;
BOXTRP   LDA     SCNCMD,Y         ;  FIRST PASS THRU BOX TRAP ?
         BITA    #$10             ;  .
         BNE     BOXCLS           ;  .
;
         LDA     #$10             ;  UN-DEFINED BOX HANDLER
         STA     CBXDLY           ;  .    SET BOX DELAY
         BRA     BOXPND           ;  .    .
;
;         IF      L.BOX = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;         IF      L.DTWR = OFF     ;-------------------------------------------
;         LIST    -L               ;--  DRWTWR  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SPECIAL ANIMATION FOR DARK TOWER
;  ================================
;
         direct   $D0
;        =====   ===
;
DRWTWR   PSHS    DP               ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         JSR     KEYTST           ;  ALL KEYS MUST BE HELD 
         BCC     DRWTW4           ;  .    GOLD KEY ?
;
         LDA     FOGFLG           ;  IS A FOG PENDING ?
         BNE     DRWTW1           ;  .
;
         LDA     [CBXOBJ]         ;  ENTERING DARK-TOWER ?
         CMPA    #$F4             ;  .    IS THE DARK-TOWER IN-FRONT ?
         BNE     DRWTW1           ;  .    .
         LDA     CBXDST           ;  .    HOW CLOSE IS THE DARK-TOWER ?
;
;==========================================================================JJH
;        CMPA    #$38             ;  CODE DELETED - REV. A CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         CMPA    #$3C             ;  CODE ADDED - REV. A CHANGES     ======JJH
;==========================================================================JJH
;
         BGE     DRWTW1           ;  .    .
         LDA     POT1             ;  .    BACKING INTO DARK TOWER ?
         BLE     DRWTW1           ;  .    .
         LDA     POT0             ;  .    TURNING INTO DARK TOWER ?
         BNE     DRWTW1           ;  .    .
;
         PSHS    X,Y,U            ;  TRY THE RIDDLE OF THE KEYS
         JSR     TOWER            ;  .    IF RETURN, PLAYER FUCKED-UP RIDDLE !
         JSR     FOGSET           ;  .    .
         PULS    X,Y,U            ;  .    .
;
DRWTW1   CLR     RFLAG            ;  SET-UP TO DRAW DARK-TOWER
;
         LDA     #$7F             ;  .    SET 'Z' AXIS
         SUBA    OBJSCZ,U         ;  .    .
         TFR     A,B              ;  .    .
         ADDA    #$30             ;  .    .    SET INTENSITY
         BVC     DRWTW2           ;  .    .    .
         LDA     #$7F             ;  .    .    .
DRWTW2   SUBA    FOGLIM           ;  .    .    .    FACTOR-IN FOG
         CMPA    #$20             ;  .    .    .    .
         BLE     DRWTW4           ;  .    .    .    .
;
         LSLB                     ;  .    SET ZOOM SIZE
         ADDB    #$68             ;  .    .    FUDGE BOX SIZE
         BCC     DRWTW3           ;  .    .    .
         LDB     #$FF             ;  .    .    .
DRWTW3   STD     DRWINT           ;  .    .
;
         LDD     #DTWR1           ;  DRAW DARK TOWER
         LDX     #DTWR2           ;  .    FETCH DARK TOWER ADDRESS
         LEAY    OBJSCY,U         ;  .    FETCH SCREEN POSITION
         JSR     CDIFFY           ;  .    DRAW BOTTOM OF BOX
;
DRWTW4   PULS    DP               ;  TRY NEXT SCENERY OBJECT
         JMP     DRW2             ;  .
;
;         IF      L.DTWR = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;         IF      L.SKEY = OFF     ;-------------------------------------------
;         LIST    -L               ;--  SCNKEY  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SPECIAL ANIMATION FOR SCENERY KEY
;  =================================
;
         direct   $D0
;        =====   ===
;
SCNKEY   PSHS    DP               ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         JSR     KEYTST           ;  HAVE ALL THE KEYS BEEN GRANTED ?
         BCS     KYSCN1           ;  .
;
         JSR     TSTACT           ;  HAS THIS KEY ALREADY BEEN PICKED-UP ?
         BEQ     KYSCN2           ;  .
KYSCN1   PULS    DP               ;  .    THIS KEY HAS ALREADY BEEN USED
         JMP     DRW2             ;  .    .
;
KYSCN2   LDA     [CBXOBJ]         ;  PICKING-UP SCENERY KEY ?
         CMPA    #$F0             ;  .    IS THE SCENERY KEY IN-FRONT ?
         BNE     KYSCN4           ;  .    .
         LDA     CBXACT           ;  .    HAS THIS KEY ALREADY BEEN PICKED-UP ?
         BNE     KYSCN1           ;  .    .
         LDA     CBXDST           ;  .    HOW CLOSE IS THE SCENERY KEY ?
;
;==========================================================================JJH
;        CMPA    #$38             ;  CODE DELETED - REV. A CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         CMPA    #$3C             ;  CODE ADDED - REV. A CHANGES     ======JJH
;==========================================================================JJH
;
         BGE     KYSCN4           ;  .    .
         LDA     POT1             ;  .    BACKING INTO KEY ?
         BLE     KYSCN4           ;  .    .
         LDA     POT0             ;  .    TURNING INTO KEY ?
         BNE     KYSCN4           ;  .    .
;
         JSR     FNDGKY           ;  GRANT PLAYER ONE KEY PER FIND
         BNE     KYSCN3           ;  .    ATTEMPT GOLD KEY
         JSR     FNDBZK           ;  .    ATTEMPT BRONZE KEY
         BNE     KYSCN3           ;  .    .
         JSR     FNDSKY           ;  .    ATTEMPT SILVER KEY
         BNE     KYSCN3           ;  .    .
         JSR     FNDBSK           ;  .    ATTEMPT BRASS KEY
         BEQ     KYSCN1           ;  .    .
;
KYSCN3   LDA     [CBXPTR]         ;  .    SET ACTIVITY FLAG
         ORA     CBXBIT           ;  .    .
         STA     [CBXPTR]         ;  .    .
         STA     CBXACT           ;  .    .
;
         PSHS    U                ;  .    PLAY TREASURE TUNE
         LDU     #TRSTUN          ;  .    .
         JSR     SPLAY            ;  .    .
         PULS    U                ;  .    .
         BRA     KYSCN1           ;  .    .
;
KYSCN4   CLR     RFLAG            ;  SET-UP TO DRAW SCENERY KEY
;
         LDA     #$7F             ;  .    SET 'Z' AXIS
         SUBA    OBJSCZ,U         ;  .    .
         TFR     A,B              ;  .    .
         ADDA    #$30             ;  .    .    SET INTENSITY
         BVC     KYSCN5           ;  .    .    .
         LDA     #$7F             ;  .    .    .
KYSCN5   SUBA    FOGLIM           ;  .    .    .    FACTOR-IN FOG
         CMPA    #$20             ;  .    .    .    .
         BLE     KYSCN1           ;  .    .    .    .
;
         LSRB                     ;  .    SET ZOOM SIZE
         LSRB                     ;  .    .    FUDGE KEY SIZE
         ADDB    #$08             ;  .    .    .
         CMPB    #$10             ;  .    .    .
         BLE     KYSCN1           ;  .    .    .
;
         PULS    DP               ;  SET 'DP' = I/O
         direct   $D0              ;  .
;
         LDX     #PKEY            ;  DRAW SCENERY KEY
         LEAY    OBJSCY,U         ;  .    FETCH SCREEN POSITION
         JSR     SDIFFY           ;  .    DRAW KEY
;
         JMP     DRW2             ;  TRY NEXT SCENERY OBJECT
;
;         IF      L.SKEY = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;         IF      L.SGLD = OFF     ;-------------------------------------------
;         LIST    -L               ;--  SCNGLD  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SPECIAL ANIMATION FOR SCENERY GOLD
;  ==================================
;
         direct   $D0
;        =====   ===
;
SCNGLD   PSHS    DP               ;  SET 'DP' = RAM
         LDA     #$C8             ;  .
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         JSR     TSTACT           ;  HAS THIS GOLD ALREADY BEEN PICKED-UP ?
         BEQ     GLSCN2           ;  .
GLSCN1   PULS    DP               ;  .    THIS GOLD HAS ALREADY BEEN USED
         JMP     DRW2             ;  .    .
;
GLSCN2   LDA     [CBXOBJ]         ;  PICKING-UP SCENERY GOLD ?
         CMPA    #$F2             ;  .    IS THE SCENERY GOLD IN-FRONT ?
         BNE     GLSCN4           ;  .    .
         LDA     CBXACT           ;  .    HAS THIS GOLD ALREADY BEEN PICKED-UP ?
         BNE     GLSCN1           ;  .    .
         LDA     CBXDST           ;  .    HOW CLOSE IS THE SCENERY GOLD ?
;
;==========================================================================JJH
;        CMPA    #$38             ;  CODE DELETED - REV. A CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         CMPA    #$3C             ;  CODE ADDED - REV. A CHANGES     ======JJH
;==========================================================================JJH
;
         BGE     GLSCN4           ;  .    .
         LDA     POT1             ;  .    BACKING INTO BAG OF GOLD ?
         BLE     GLSCN4           ;  .    .
         LDA     POT0             ;  .    TURNING INTO BAG OF GOLD ?
         BNE     GLSCN4           ;  .    .
;
         PSHS    U                ;  GRANT PLAYER ONE BAG OF GOLD
         LDD     BGOLD            ;  .    INCREMENT HEX GOLD COUNTER
         ADDD    #$0001           ;  .    .
         BCS     GLSCN3           ;  .    .
         STD     BGOLD            ;  .    .
;
         LDA     #$01             ;  .    INCREMENT ASCII GOLD COUNTER
         LDX     #GOLD            ;  .    .
         JSR     ASCADD           ;  .    .
;
GLSCN3   LDX     #PLYSCR          ;  .    ADD VALUE TO SCORE
         LDD     #$0100           ;  .    .
         JSR     SCRADD           ;  .    .
;
         LDU     #TRSTUN          ;  .    PLAY TREASURE TUNE
         JSR     SPLAY            ;  .    .
         PULS    U                ;  .
;
         LDA     [CBXPTR]         ;  .    SET ACTIVITY FLAG
         ORA     CBXBIT           ;  .    .
         STA     [CBXPTR]         ;  .    .
         STA     CBXACT           ;  .    .
         BRA     GLSCN1           ;  .    .
;
GLSCN4   CLR     RFLAG            ;  SET-UP TO DRAW SCENERY GOLD
;
         LDA     #$7F             ;  .    SET 'Z' AXIS
         SUBA    OBJSCZ,U         ;  .    .
         TFR     A,B              ;  .    .
         ADDA    #$30             ;  .    .    SET INTENSITY
         BVC     GLSCN5           ;  .    .    .
         LDA     #$7F             ;  .    .    .
GLSCN5   SUBA    FOGLIM           ;  .    .    .    FACTOR-IN FOG
         CMPA    #$20             ;  .    .    .    .
         BLE     GLSCN1           ;  .    .    .    .
;
         LSRB                     ;  .    SET ZOOM SIZE
         LSRB                     ;  .    .    FUDGE GOLD BAG SIZE
         ADDB    #$08             ;  .    .    .
         CMPB    #$10             ;  .    .    .
         BLE     GLSCN1           ;  .    .    .
;
         PULS    DP               ;  SET 'DP' = I/O
         direct   $D0              ;  .
;
         LDX     #PGOLD           ;  DRAW BAG OF GOLD
         LEAY    OBJSCY,U         ;  .    FETCH SCREEN POSITION
         JSR     SDIFFY           ;  .    DRAW BAG
;
         JMP     DRW2             ;  TRY NEXT SCENERY OBJECT
;
;         IF      L.SGLD = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
