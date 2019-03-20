;
;
;         IF      L.SBR = OFF      ;-------------------------------------------
;         LIST    -L               ;--  SUBR  ---------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;
;  ***********************************************
;  ***********************************************
;  ***                                         ***
;  ***          S U B R O U T I N E S          ***
;  ***                                         ***
;  ***********************************************
;  ***********************************************
;
;
;  HAVE ALL THE KEYS BEEN GRANTED ?
;  ================================
;
;        RETURN VALUES
;        -------------
;           C  = 0 - AT LEAST ONE KEY REMAINS
;                1 - ALL KEYS HAVE BEEN GRANTED
;
         direct   $00
;        =====   ===
;
KEYTST   LDA     GLDKEY           ;  GOLD KEY GRANTED ?
         BEQ     KTEST1           ;  .
;
         LDA     SLVKEY           ;  SILVER KEY GRANTED ?
         BEQ     KTEST1           ;  .
;
         LDA     BRZKEY           ;  BRONZE KEY GRANTED ?
         BEQ     KTEST1           ;  .
;
         LDA     BRSKEY           ;  BRASS KEY GRANTED ?
         BEQ     KTEST1           ;  .
;
         ORCC    #$01             ;  RETURN TO CALLER - KEYS ALL GRANTED
         RTS                      ;  .
;
;
KTEST1   CLRA                     ;  RETURN TO CALLER - KEYS REMAIN
         RTS                      ;  .
;
;
;
;
;  SET-UP TREASURE MESSAGE
;  =======================
;
;        ENTRY VALUES
;        ------------
;           A  = TREASURE MESSAGE NUMBER
;           DP = $C8
;
         direct   $C8
;        =====   ===
;
SETMSG   PSHS    U                ;  SAVE ENTRY VALUES
;
         LDU     #TRSMSG          ;  SET TREASURE MESSAGE
         LDU     A,U              ;  .
         STU     MSGPTR           ;  .
;
         LDU     #TRSVCT          ;  SET TREASURE MESSAGE ZOOM VECTOR
         LDU     A,U              ;  .
         STU     MSGVCT           ;  .
;
         CLR     MSGFRM           ;  RESET MESSAGE COUNTER
;
         LDU     #TRSTUN          ;  SET-UP TREASURE TUNE
         JSR     SPLAY            ;  .
;
         PULS    U,PC             ;  RETURN TO CALLER
;
;
;
;
;  UPDATE AND DISPLAY TREASURE MESSAGE
;  ===================================
;
         direct   $D0
;        =====   ===
;
UPDMSG   PSHS    X,U              ;  SAVE ENTRY VALUES
;
         LDU     MSGPTR           ;  FETCH MESSAGE POINTER
         BEQ     UPDMS1           ;  .    IS MESSAGE INHIBITED ?
;
         LDA     MSGFRM           ;  ADVANCE MESSAGE FRAME COUNTER
         ADDA    #$08             ;  .
         CMPA    #$70             ;  .
         BGE     UPDMS0           ;  .
         STA     MSGFRM           ;  .
;
UPDMS0   LDX     #RSTZOM          ;  FETCH RASTER ZOOM VALUE
         LSRA                     ;  .
         LSRA                     ;  .
         ANDA    #$1E             ;  .
         LDD     A,X              ;  .
         STD     SIZRAS           ;  .
;
         JSR     INTMAX           ;  SET-UP RASTER MESSAGE
;
         LDA     MSGFRM           ;  SET-UP MESSAGE VECTOR
         ADDA    #$04             ;  .    SET VECTOR LENGTH
         STA     T1LOLC           ;  .    .
         LDD     MSGVCT           ;  .    SET VECTOR VALUES
         JSR     POSITN           ;  .
;
         JSR     RASTER           ;  DISPLAY TREASURE MESSAGE
;
UPDMS1   PULS    X,U,PC           ;  RETURN TO CALLER
;
;
;
;
;  RANDOMLY SELECT A TREASURE
;  ==========================
;
;        ENTRY VALUES
;        ------------
;           U  = TREASURE SELECTION TABLE
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           A  = TREASURE MESSAGE NUMBER
;
         direct   $C8
;        =====   ===
;
SELTRS   PSHS    B,X,U            ;  SAVE ENTRY VALUES
;
         LDA     #$07             ;  SET TREASURE TRY COUNTER
         STA     ETMP9            ;  .
;
SLTRS1   JSR     RANDOM           ;  PICK TREASURE RANDOMLY
         ANDA    #$0E             ;  .
         LDX     A,U              ;  .
         BEQ     SLTRS2           ;  .
         JSR     ,X               ;  .
         BNE     SLTRS3           ;  .
;
         DEC     ETMP9            ;  TREASURE NOT FOUND, TRY AGAIN ?
         BNE     SLTRS1           ;  .
;
;
SLTRS2   CLRA                     ;  NO TREASURE SELECTED THIS TIME
;
SLTRS3   PULS    B,X,U,PC         ;  RETURN TO CALLER
;
;
;
;
;  SAVE VALUES FOR THE GRID SCAN TABLE
;  ===================================
;
         direct   $C8
;        =====   ===
;
SAVGRD   PSHS    X,Y              ;  SAVE ENTRY VALUES
;
         LDX     #RGDTBL          ;  SET-UP TO TRANSFER RETAINED VALUES
         LDY     #SCNTBL          ;  .
         LDA     #SCNCNT          ;  .    SET TABLE LENGTH
         STA     ETMP1            ;  .    .
;
SVGRD0   LDA     SCNCMD,Y         ;  SAVE COMMAND / STATUS BYTE
         STA     <<RGDCMD,X         ;  .
;
         LDA     SCNTMR,Y         ;  SAVE ANIMATION TIMER BYTE
         STA     RGDTMR,X         ;  .
;
         LEAX    RGDLEN,X         ;  BUMP TO NEXT TABLE ENTRY
         LEAY    SCNLEN,Y         ;  .
         DEC     ETMP1            ;  .    END OF TABLE ?
         BNE     SVGRD0           ;  .    .
;
         PULS    X,Y,PC           ;  RETURN TO CALLER
;
;
;
;
;  RESTORE RETAINED VALUES TO THE GRID SCAN TABLE
;  ==============================================
;
         direct   $C8
;        =====   ===
;
RSTGRD   PSHS    X,Y              ;  SAVE ENTRY VALUES
;
         LDX     #RGDTBL          ;  SET-UP TO TRANSFER RETAINED VALUES
         LDY     #SCNTBL          ;  .
         LDA     #SCNCNT          ;  .    SET TABLE LENGTH
         STA     ETMP1            ;  .    .
;
RSGRD0   LDA     <<RGDCMD,X         ;  SAVE COMMAND / STATUS BYTE
         STA     SCNCMD,Y         ;  .
;
         LDA     RGDTMR,X         ;  SAVE ANIMATION TIMER BYTE
         STA     SCNTMR,Y         ;  .
;
         LEAX    RGDLEN,X         ;  BUMP TO NEXT TABLE ENTRY
         LEAY    SCNLEN,Y         ;  .
         DEC     ETMP1            ;  .    END OF TABLE ?
         BNE     RSGRD0           ;  .    .
;
         PULS    X,Y,PC           ;  RETURN TO CALLER
;
;
;
;
;  SCAN MAP GRID
;  =============
;
;        ENTRY VALUES
;        ------------
;           Y  = GRID SCAN SEQUENCE TABLE
;           DP = $C8
;
;           ETMP1  = STARTING 'Y' POINT
;           ETMP2  = STARTING 'X' POINT
;
;        RETURN VALUES
;        -------------
;           A  = OBJECT TYPE NUMBER ($00 -$0F)
;           B  = 0 - EVEN GRID POSITION
;                1 - ODD GRID POSITION
;
;           C  = 1 - END OF GRID SCAN SEQUENCE
;           V  = 1 - GRID SCAN OFF-MAP ('A' = $00)
;
         direct   $C8
;        =====   ===
;
MAPSCN   LDD     ,Y++              ;  SET-UP GRID SCAN NODE
         LBEQ    MSCN5            ;  .    END OF GRID SCAN SEQUENCE ?
         ADDA    ETMP1            ;  .    CALCULATE MAP SCAN 'Y' POSITION
         STA     ETMP3            ;  .    .
         CLR     ETMP7            ;  .    .    SAVE 'Y' SECTOR BIT
         LSLA                     ;  .    .    .
         BCS     MSCN4            ;  .    .    .    SCAN OFF-MAP ?
         LSLA                     ;  .    .    .
         BCS     MSCN4            ;  .    .    .    SCAN OFF-MAP ?
         LSLA                     ;  .    .    .
         ROL     ETMP7            ;  .    .    .
;
         ADDB    ETMP2            ;  .    CALCULATE MAP SCAN 'X' POSITION
         STB     ETMP4            ;  .    .
         LSLB                     ;  .    .    SAVE 'X' SECTOR BIT
         BCS     MSCN4            ;  .    .    .    SCAN OFF-MAP ?
         LSLB                     ;  .    .    .
         BCS     MSCN4            ;  .    .    .    SCAN OFF-MAP ?
         LSLB                     ;  .    .    .
         ROL     ETMP7            ;  .    .    .
;
         LDX     #BOXMAP          ;  CALCULATE MAP ADDRESS
         CLR     ETMP8            ;  .
         LDB     ETMP3            ;  .    FACTOR-IN 'Y' AXIS
         LSRB                     ;  .    .    SCENERY ?
         ROL     ETMP8            ;  .    .    .
         STB     ETMP10           ;  .    .    .
         LDA     #$40             ;  .    .
         MUL                      ;  .    .
         STD     ETMP5            ;  .    .
;
         LDB     ETMP4            ;  .    FACTOR-IN 'X' AXIS
         ANDB    #$3F             ;  .    .
         SEX                      ;  .    .
         ADDD    ETMP5            ;  .    .
         STD     ETMP5            ;  .    .
;
         CLR     ETMP9            ;  .    FETCH MAP ADDRESS
         LSRA                     ;  .    .    FETCH MAP LOCATION
         RORB                     ;  .    .    .    ANIMATION OR SCENERY ?
         ROL     ETMP8            ;  .    .    .    .
         LSRA                     ;  .    .    .    EVEN OR ODD OBJECT ?
         RORB                     ;  .    .    .    .
         ROL     ETMP9            ;  .    .    .    .
         LEAX    D,X              ;  .    .    .    FORM MAP ADDRESS
;
         LDA     ,X               ;  FETCH MAP OBJECT
         INCA                     ;  .    IS AREA INHIBITED ?
         BEQ     MAPSCN           ;  .    .
         INCA                     ;  .    IS OBJECT THE DARK TOWER ?
         BEQ     MSCN6            ;  .    .
;
         LDB     ETMP8            ;  .    IS THIS ANIMATION OR SCENERY ?
         BNE     MSCN2            ;  .    .
;
         LDA     ,X               ;  FETCH MAP OBJECT
         LDB     ETMP9            ;  .    EVEN / ODD OBJECT ?
         BEQ     MSCN1            ;  .    .
         LSRA                     ;  .    .    OBJECT NUMBER IN MSN
         LSRA                     ;  .    .    .
         LSRA                     ;  .    .    .
         LSRA                     ;  .    .    .
MSCN1    ANDA    #$0F             ;  .    MASK OFF UNUSED NIBBLE
         BNE     MSCN3            ;  .    LEGAL OBJECT ?
;
;
MSCN2    LDA     ETMP7            ;  STANDARD SCENERY RETURN
;
MSCN3    LDB     ETMP9            ;  LEGAL OBJECT RETURN
         EORB    ETMP10           ;  .    FORM DRAWING FLAG
         ANDB    #$01             ;  .    .
         ANDCC   #$FC             ;  .    RESET 'C' & 'V'
         RTS                      ;  .    RETURN TO CALLER
;
;
MSCN4    CLRA                     ;  OFF-MAP GRID-SCAN RETURN
         ORCC    #$02             ;  .    SET 'V'
         RTS                      ;  .    RETURN TO CALLER
;
;
MSCN5    ORCC    #$01             ;  END OF SCAN RETURN
         RTS                      ;  .    SET 'C'
;
;
MSCN6    LDB     ETMP8            ;  DARK TOWER RETURN
         BNE     MAPSCN           ;  .    DARK TOWER OR SCENERY ?
         LDB     ETMP9            ;  .    EVEN / ODD ?
         BITB    #$01             ;  .    .
         LBEQ    MAPSCN           ;  .    .
;
         LDA     #$07             ;  .    DARK TOWER FOUND
         BRA     MSCN3            ;  .    .
;
;
;
;
;  FETCH ACTIVITY BIT FOR GIVEN OBJECT
;  ===================================
;
;        ENTRY VALUES
;        ------------
;           Y  = POINTER TO OBJECT TABLE ENTRY
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           A  = OBJECT ACTIVITY STATUS
;                   $00 = OBJECT NOT PREVIOUSLY ACCESSED
;
;           ETMP1/2 = ACTIVITY BYTE ADDRESS
;           ETMP3   = ACTIVITY MASK BIT
;
         direct   $C8
;        =====   ===
;
TSTACT   LDB     SCNGY,Y          ;  FACTOR-IN 'Y' AXIS
         ANDB    #$3E             ;  .
         LDA     #$20             ;  .
         MUL                      ;  .
         STD     ETMP1            ;  .
;
         LDB     SCNGX,Y          ;  FACTOR-IN 'X' AXIS
         ANDB    #$3F             ;  .
         SEX                      ;  .
         ADDD    ETMP1            ;  .
;
         CLR     ETMP3            ;  FORM BOX ACTIVITY POINTER
         LSRA                     ;  .    REMOVE SCENERY BIT
         RORB                     ;  .    .
         LSRA                     ;  .    FORM BIT POINTER
         RORB                     ;  .    .
         ROR     ETMP3            ;  .    .
         LSRA                     ;  .    .
         RORB                     ;  .    .
         ROR     ETMP3            ;  .    .
         LSRA                     ;  .    .
         RORB                     ;  .    .
         ROR     ETMP3            ;  .    .
         ROL     ETMP3            ;  .    .    ALIGN BIT POINTER
         ROL     ETMP3            ;  .    .    .
         ROL     ETMP3            ;  .    .    .
         ROL     ETMP3            ;  .    .    .
         ADDD    #BOXACT          ;  .    FORM ACTIVITY POINTER
         STD     ETMP1            ;  .    .
;
         LDA     ETMP3            ;  DECODE BIT POINTER
         JSR     DECBIT           ;  .
         STA     ETMP3            ;  .
;
         ANDA    [ETMP1]          ;  FETCH ACTIVITY FLAG
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  SET-UP BONUS WARRIOR FOUND
;  ==========================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           A  = WARRIOR MESSAGE NUMBER ($12)
;
         direct   $C8
;        =====   ===
;
FNDWAR   PSHS    X                ;  SAVE ENTRY VALUES
;
         JSR     RANDOM           ;  DETERMINE NUMBER OF WARRIORS TO BE FOUND
         ANDA    #$03             ;  .
         ADDA    #$01             ;  .
         STA     ETMP1            ;  .
;
         LDA     TROOPS           ;  INCREMENT HEX TROOP COUNTER
         ADDA    ETMP1            ;  .
         BCS     NOFND0           ;  .
         STA     TROOPS           ;  .
;
         LDX     #M_NMEN          ;  INITIALIZE NEW TROOPS MESSAGE
         LDU     #NMEN            ;  .
         JSR     SMOVE            ;  .
;
         LDA     ETMP1            ;  SET-UP NEW TROOPS MESSAGE
         ORA     #$30             ;  .
         STA     NMEN             ;  .
;
         LDX     #MEN             ;  INCREMENT RESERVE TROOPS COUNTER
         LDA     ETMP1            ;  .
         JSR     ASCADD           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDA     ETMP1            ;  .
         CLRB                     ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$12             ;  SET WARRIOR MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
NOFND0   CLRA                     ;  NO TREASURE GRANTED
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP BAGS OF GOLD FOUND
;  =========================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           A  = NEW BAGS OF GOLD MESSAGE NUMBER ($10)
;              = $00 - NO GOLD GRANTED
;
         direct   $C8
;        =====   ===
;
FNDGLD   PSHS    X                ;  SAVE ENTRY VALUES
;
         JSR     RANDOM           ;  DETERMINE BAGS OF GOLD TO BE FOUND
         ANDA    #$07             ;  .    SET LEAST SIGNIFICANT DIGIT
         ADDA    #$02             ;  .    .
         STA     ETMP2            ;  .    .
         CLR     ETMP1            ;  .    .
;
         LDD     BGOLD            ;  INCREMENT HEX GOLD COUNTER
         ADDD    ETMP1            ;  .
         BCS     NOFND0           ;  .
         STD     BGOLD            ;  .
;
         LDX     #M_NGLD          ;  INITIALIZE NEW BAGS OF GOLD MESSAGE
         LDU     #NGOLD           ;  .
         JSR     SMOVE            ;  .
;
         LDA     ETMP2            ;  SET-UP NEW GOLD MESSAGE
         ORA     #$30             ;  .
         STA     NGOLD            ;  .
;
         LDX     #GOLD            ;  INCREMENT BAGS OF GOLD COUNTER
         LDA     ETMP2            ;  .
         JSR     ASCADD           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDA     ETMP2            ;  .
         CLRB                     ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$10             ;  SET NEW BAGS OF GOLD MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP GOLD KEY FOUND
;  =====================
;
;        RETURN VALUES
;        -------------
;           A  = GOLD KEY MESSAGE NUMBER ($02)
;              = $00 - NO KEY GRANTED
;
         direct   $C8
;        =====   ===
;
FNDGKY   PSHS    X                ;  SAVE ENTRY VALUES
;
         LDA     GLDKEY           ;  HAS GOLD KEY ALREADY BEEN GRANTED ?
         BNE     NOFND0           ;  .
;
         LDA     #$01             ;  SET GOLD KEY FLAG
         STA     GLDKEY           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDD     #$1000           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$02             ;  SET GOLD MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP SILVER KEY FOUND
;  =======================
;
;        RETURN VALUES
;        -------------
;           A  = SILVER KEY MESSAGE NUMBER ($04)
;              = $00 - NO KEY GRANTED
;
         direct   $C8
;        =====   ===
;
FNDSKY   PSHS    X                ;  SAVE ENTRY VALUES
;
         LDA     SLVKEY           ;  HAS SILVER KEY ALREADY BEEN GRANTED ?
         BNE     NOFND0           ;  .
;
         LDA     #$01             ;  SET SILVER KEY FLAG
         STA     SLVKEY           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDD     #$0900           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$04             ;  SET SILVER KEY MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP BRONZE KEY FOUND
;  =======================
;
;        RETURN VALUES
;        -------------
;           A  = BRONZE KEY MESSAGE NUMBER ($06)
;              = $00 - NO KEY GRANTED
;
         direct   $C8
;        =====   ===
;
FNDBZK   PSHS    X                ;  SAVE ENTRY VALUES
;
         LDA     BRZKEY           ;  HAS BRONZE KEY ALREADY BEEN GRANTED ?
         BNE     NOFND1           ;  .
;
         LDA     #$01             ;  SET BRONZE KEY FLAG
         STA     BRZKEY           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDD     #$0800           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$06             ;  SET BRONZE KEY MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP BRASS KEY FOUND
;  ======================
;
;        RETURN VALUES
;        -------------
;           A  = BRASS KEY MESSAGE NUMBER ($08)
;              = $00 - NO KEY GRANTED
;
         direct   $C8
;        =====   ===
;
FNDBSK   PSHS    X                ;  SAVE ENTRY VALUES
;
         LDA     BRSKEY           ;  HAS BRASS KEY ALREADY BEEN GRANTED ?
         BNE     NOFND1           ;  .
;
         LDA     #$01             ;  SET BRASS KEY FLAG
         STA     BRSKEY           ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDD     #$0700           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$08             ;  SET BRASS KEY MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP CRYSTAL CROWN FOUND
;  ==========================
;
;        RETURN VALUES
;        -------------
;           A  = CRYSTAL CROWN MESSAGE NUMBER ($0A)
;              = $00 - NO CRYSTAL CROWN FOUND
;
         direct   $C8
;        =====   ===
;
FNDCRW   PSHS    X                ;  SAVE ENTRY VALUES
;
         LDA     CROWN            ;  HAS CRYSTAL CROWN ALREADY BEEN GRANTED ?
         BNE     NOFND1           ;  .
;
         LDA     #$01             ;  SET CRYSTAL CROWN FLAG
         STA     CROWN            ;  .
;
         LDX     #PLYSCR          ;  ADD VALUE TO SCORE
         LDD     #$1500           ;  .
         JSR     SCRADD           ;  .
;
         LDA     #$0A             ;  SET CRYSTAL CROWN MESSAGE NUMBER
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
NOFND1   CLRA                     ;  NO TREASURE GRANTED
         PULS    X,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  SET-UP ENTRY IN FLAMOID TABLE
;  =============================
;
;        ENTRY VALUES
;        ------------
;           A  = DESIRED FLAMOID ANGLE
;           B  = RELATIVE 'Z' AXIS
;           X  = ABSOLUTE 'X' STARTING POSITION OF FLAMOID
;           Y  = ABSOLUTE 'Y' STARTING POSITION OF FLAMOID
;
;        RETURN VALUES
;        -------------
;           U  = CURRENT FLAMOID ENTRY POINTER
;
         direct   $C8
;        =====   ===
;
SETFLM   PSHS    A,B,X,Y          ;  SAVE ENTRY VALUES
;
         LDU     #FLMTBL          ;  SEARCH FLAMOID TABLE FOR OPENING
         LDB     #FLMCNT          ;  .
;
STFLM1   LDA     <<FLMFLG,U         ;  .    ENTRY ACTIVE ?
         BEQ     STFLM2           ;  .    .
;
         LEAU    FLMLEN,U         ;  .    BUMP TO NEXT ENTRY
         DECB                     ;  .    .
         BNE     STFLM1           ;  .    .
;
         ORCC    #$01             ;  RETURN TO CALLER
         PULS    A,B,X,Y,PC       ;  .    NO ROOM FOR FLAMOID IN TABLE
;
;
STFLM2   LDA     #$01             ;  SET FLAMOID ENTRY
         STA     <<FLMFLG,U         ;  .    SET FLAMOID FLAG
;
         LDA     #$90             ;  .    SET FLAMOID TIMER
         STA     FLMTMR,U         ;  .    .
;
         LDD     2,S              ;  .    SET STARTING ABSOLUTE POSITION
         STD     FLMXW,U          ;  .    .    'X' AXIS
;
         LDD     4,S              ;  .    .    'Y' AXIS
         STD     FLMYW,U          ;  .    .    .
;
         LDA     1,S              ;  .    .    'Z' AXIS
         STA     FLMZW,U          ;  .    .    .
;
         LDA     #FLMSPD          ;  .    CALCULATE FLAMOID DISPLACEMENTS
         LDB     ,S               ;  .    .
         JSR     LNROT            ;  .    .
         STA     ETMP1            ;  .    .
;
         SEX                      ;  .    FORM 'X' DISPLACEMENT (4X)
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         STD     FLMXD,U          ;  .    .
;
         LDB     ETMP1            ;  .    FORM 'Y' DISPLACMENT (4X)
         SEX                      ;  .    .
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         ASLB                     ;  .    .
         ROLA                     ;  .    .
         STD     FLMYD,U          ;  .    .
;
         LDA     #$80             ;  .    SET THROWING SOUND
         STA     THRSND           ;  .    .
;
         CLRA                     ;  RETURN TO CALLER
         PULS    A,B,X,Y,PC       ;  .    LEGAL RETURN
;
;
;
;
;  SET-UP ENTRY IN EXPLOSION TABLE
;  ===============================
;
;        ENTRY VALUES
;        ------------
;           A  = EXPLOSION FRAGMENT SIZE
;           X  = ABSOLUTE 'X' STARTING POSITION OF FRAGMENT
;           Y  = ABSOLUTE 'Y' STARTING POSITION OF FRAGMENT
;           U  = POINTER TO FRAGMENT 'DUFFY'
;
;        RETURN VALUES
;        -------------
;           C  = NO ROOM FOR NEW FRAGMENT
;
         direct   $C8
;        =====   ===
;
SETEXP   PSHS    A,X,Y,U          ;  SAVE ENTRY VALUES
;
         LDU     #EXPTBL          ;  SEARCH EXPLOSION TABLE FOR OPENING
         LDB     #EXPCNT          ;  .
;
EXPLD1   LDA     <<EXPFLG,U         ;  .    ENTRY ACTIVE ?
         BEQ     EXPLD2           ;  .    .
;
         LEAU    EXPLEN,U         ;  .    BUMP TO NEXT ENTRY
         DECB                     ;  .    .
         BNE     EXPLD1           ;  .    .
;
         ORCC    #$01             ;  RETURN TO CALLER
         PULS    A,X,Y,U,PC       ;  .    NO ROOM FOR FRAGMENT IN TABLE
;
;
EXPLD2   LDA     #$01             ;  SET EXPLOSION ENTRY
         STA     <<EXPFLG,U         ;  .    SET EXPLOSION FLAG
;
         STY     EXPYW,U          ;  SET INITIAL 'Y' POSITION
;
         STX     EXPXW,U          ;  SET INITIAL 'X' POSITION
;
         CLR     EXPROT,U         ;  SET-UP ROTATIONAL BEHAVIOR
         JSR     CONE             ;  .    SET-UP ROTATIONAL RATE
         STA     EXPRAT,U         ;  .    .
;
         LDA     #$30             ;  SET EXPLOSION TIMER
         STA     EXPTMR,U         ;  .
;
         LDA     ,S               ;  SET EXPLOSION FRAGMENT SIZE
         STA     EXPSIZ,U         ;  .
;
         LDD     5,S              ;  SAVE EXPLOSION FRAGMENT POINTER
         STD     EXPTR,U          ;  .
;
         JSR     CONE             ;  FETCH OBJECT ANGLE OF MOTION
         LDA     #$20             ;  .
         JSR     MLTY16           ;  CALCULATE NEW DISPLACEMENTS
         STY     EXPYD,U          ;  .    'Y' DISPLACEMENT
         STX     EXPXD,U          ;  .    'X' DISPLACEMENT
;
         CLRA                     ;  RETURN TO CALLER
         PULS    A,X,Y,U,PC       ;  .    LEGAL RETURN
;
;
;
;
;  UPDATE OBJECT POSITION
;  ======================
;
;        ENTRY VALUES
;        ------------
;           U  = OBJECT TABLE POINTER
;                   + 1/2  = 'Y' AXIS DISPLACEMENT
;                   + 3/4  = 'X' AXIS DISPLACEMENT
;                   + 5/6  = 'Y' AXIS POSITION
;                   + 7/8  = 'X' AXIS POSITION
;
;        RETURN VALUES
;        -------------
;           C  = SET IF 'Y' AXIS OVER-FLOW
;           V  = SET IF 'X' AXIS OVER-FLOW
;
         direct   $C8
;        =====   ===
;
MOVOBJ   LDD     5,U              ;  UPDATE 'Y' AXIS POSITION
         ADDD    1,U              ;  .    CALCULATE CURRENT 'Y'
         PSHS    A                ;  .    .    SAVE 'V' FOR 'Y' AXIS
         TFR     CC,A             ;  .    .    .    PLACE 'V' STATUS IN 'C'
         ANDA    #$02             ;  .    .    .    .
         LSRA                     ;  .    .    .    .
         STA     -1,S             ;  .    .    .    .
         PULS    A                ;  .    .    .
         STD     5,U              ;  .    .
;
         LDD     7,U              ;  UPDATE 'X' AXIS POSITION
         ADDD    3,U              ;  .    CALCULATE CURRENT 'X'
         PSHS    A                ;  .    .    SAVE 'V' FOR 'X' AXIS
         TFR     CC,A             ;  .    .    .
         ANDA    #$F2             ;  .    .    .
         ORA     -1,S             ;  .    .    .
         STA     -1,S             ;  .    .    .
         PULS    A                ;  .    .    .
         STD     7,U              ;  .    .
;
         LDA     -2,S             ;  RECALL STATUS
         TFR     A,CC             ;  .    .    .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  SET-UP FOR FOG
;  ==============
;
         direct   $C8
;        =====   ===
;
FOGSET   PSHS    X,Y,U,DP         ;  SAVE ENTRY VALUES
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     FOGFLG           ;  SKIP IF FOG ALREADY CYCLING
         BNE     FOGST1           ;  .
;
         LDA     #$01             ;  TURN-ON PLAGUE FLAG
         STA     FOGFLG           ;  .
;
         CLR     FOGLIM           ;  CLEAR FOG COUNTER
;
         LDD     #PLGTIM          ;  SET-UP PLAGUE LOCK-OUT TIMER
         STD     PLGLCK           ;  .
;
         LDU     #FOGTUN          ;  ENABLE FOG TUNE
         JSR     SPLAY            ;  .
;
FOGST1   PULS    X,Y,U,DP,PC      ;  RETURN TO CALLER
;
;
;
;
;  SET-UP FOR PLAGUE
;  =================
;
         direct   $C8
;        =====   ===
;
PLGSET   PSHS    X,Y,U,DP         ;  SAVE ENTRY VALUES
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     PLGFLG           ;  IS PLAGUE INHBITED ?
         ORA     PLGLCK           ;  .
         ORA     PLGLCK + 1       ;  .
         BNE     PLGST1           ;  .
;
         LDA     #$01             ;  TURN-ON PLAGUE FLAG
         STA     PLGFLG           ;  .
;
         LDU     #DEDTUN          ;  PLAY DEAD MAN TUNE
         JSR     SPLAY            ;  .
;
         CLR     PLGLIM           ;  CLEAR PLAGUE COUNTER
;
         LDD     #PLGTIM          ;  SET-UP PLAGUE LOCK-OUT TIMER
         STD     PLGLCK           ;  .
;
PLGST1   PULS    X,Y,U,DP,PC      ;  RETURN TO CALLER
;
;
;
;
;  CLEAR OVER-LAYED STORAGE
;  ========================
;
         direct   $00
;        =====   ===
;
WRKCLR   LDX     #ENDWRK          ;  CLEAR OVER-LAYED STORAGE
WRKCL1   CLR     ,X+               ;  .
         CMPX    #UP_RAM          ;  .
         BNE     WRKCL1           ;  .
;
         CLR     STEPS            ;  RESET SOUND FLAGS
         CLR     BOXSQK           ;  .
         CLR     THRSND           ;  .
         CLR     EXPBRG           ;  .
         CLR     EXPWAR           ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  ASCII ADD TO 3-DIGIT ASCII NUMBER (IGNORES SIGN)
;  ================================================
;
;        ENTRY VALUES
;        ------------
;           A  = ASCII NUMBER TO BE ADDED
;           X  = POINTER TO 3-DIGIT ASCII NUMBER
;           DP = $00
;
;           NUMBER FORMAT
;               0 = NUMBER SIGN (ASCII '-' OR ' ')
;               1 = MOST SIGNIFICANT DIGIT
;               3 = LEAST SIGNIFICANT DIGIT
;
;        RETURN VALUES
;        -------------
;           A  = ASCII NUMBER ZERO FLAG
;
         direct   $00
;        =====   ===
;
ASCADD   PSHS    A,X              ;  SAVE ENTRY VALUE
;
         LEAX    1,X              ;  SET-UP TO ADD NUMBER
;
         LDA     2,X              ;  INCREMENT INDICATED DIGIT
         ORA     #$10             ;  .    MAKE BLANK = $30
         ADDA    ,S               ;  .
         STA     2,X              ;  .
         CMPA    #$39             ;  .    CARRY ?
         BLE     ASCZRO           ;  .    .
;
         SUBA    #$0A             ;  CARRY TO NEXT DIGIT
         STA     2,X              ;  .
;
         LDB     #$01             ;  .    INCREMENT NEXT DIGIT
         BRA     ASINC2           ;  .    .
;
;
;
;
;  INCREMENT 3-DIGIT ASCII NUMBER (WITH SIGN)
;  ==========================================
;
;        ENTRY VALUES
;        ------------
;           A  = ASCII NUMBER ZERO FLAG
;           X  = POINTER TO 3-DIGIT ASCII NUMBER
;           DP = $00
;
;           NUMBER FORMAT
;               0 = NUMBER SIGN (ASCII '-' OR ' ')
;               1 = MOST SIGNIFICANT DIGIT
;               3 = LEAST SIGNIFICANT DIGIT
;
;        RETURN VALUES
;        -------------
;           A  = ASCII NUMBER ZERO FLAG
;
         direct   $00
;        =====   ===
;
ASCINC   PSHS    A,X              ;  SAVE ENTRY VALUE
;
         LDA     ,X               ;  NEGATIVE NUMBER ?
         CMPA    #'-'             ;  .
         BEQ     ASDEC1           ;  .
;
ASINC1   LEAX    1,X              ;  SET-UP TO INCREMENT
         LDB     #$02             ;  .
;
ASINC2   LDA     B,X              ;  INCREMENT INDICATED DIGIT
         ORA     #$10             ;  .    MAKE BLANK = $30
         INCA                     ;  .
         STA     B,X              ;  .
         CMPA    #$39             ;  .    CARRY ?
         BLS     ASCZRO           ;  .    .
;
         LDA     #$30             ;  CARRY TO NEXT DIGIT
         STA     B,X              ;  .    RESET THIS DIGIT
         DECB                     ;  .    ADVANCE TO NEXT DIGIT
         BPL     ASINC2           ;  .    .
         BRA     ASCZRO           ;  .    DO ZERO SUPPRESSION
; 
;
;
;
;  DECREMENT 3-DIGIT ASCII NUMBER (WITH SIGN)
;  ==========================================
;
;        ENTRY VALUES
;        ------------
;           A  = ASCII NUMBER ZERO FLAG
;           X  = POINTER TO 3-DIGIT ASCII NUMBER
;           DP = $00
;
;           NUMBER FORMAT
;               0 = NUMBER SIGN (ASCII '-' OR ' ')
;               1 = MOST SIGNIFICANT DIGIT
;               3 = LEAST SIGNIFICANT DIGIT
;
;        RETURN VALUES
;        -------------
;           A  = ASCII NUMBER ZERO FLAG
;
         direct   $00
;        =====   ===
;
ASCDEC   PSHS    A,X              ;  SAVE ENTRY VALUES
;
         LDA     ,X               ;  NUMBER NEGATIVE ?
         CMPA    #'-'             ;  .
         BEQ     ASINC1           ;  .
;
         LDA     ,S               ;  ZERO CROSSING ?
         BEQ     ASDEC1           ;  .
         LDA     #'-'             ;  .    SET SIGN OF TRANSITION
         STA     ,X               ;  .    .
         BRA     ASINC1           ;  .    .
;
ASDEC1   LEAX    1,X              ;  DECREMENT ASCII NUMBER
         LDB     #$02             ;  .
;
         LDA     B,X              ;  .    IS DIGIT ZERO (OR LESS)
         CMPA    #$30             ;  .    .
         BGT     ASDEC3           ;  .    .
;
ASDEC2   LDA     #$39             ;  .    DIGIT IS ZERO (OR LESS)
         STA     B,X              ;  .    .    SET DIGIT TO '9'
         DECB                     ;  .    .    NEXT DIGIT
         BMI     ASCZRO           ;  .    .    LAST DIGIT ?
         DEC     B,X              ;  .    .    BORROW FROM NEXT DIGIT
         LDA     B,X              ;  .    .    .
         CMPA    #$30             ;  .    .    .
         BGE     ASCZRO           ;  .    .    .
         BRA     ASDEC2           ;  .    .    .
;
ASDEC3   DEC     B,X              ;  .    DECREMENT CURRENT DIGIT
;
;
;
ASCZRO   CLRB                     ;  HANDLE LEADING ZERO SUPPRESSION
         CLR     ,S               ;  .    CLEAR ZERO CROSSING FLAG
;
ASZER1   LDA     B,X              ;  .    FETCH ASCII NUMBER
         BMI     ASZER2           ;  .    .    END OF ASCII STRING ?
;
         CMPA    #$30             ;  .    DIGIT = ZERO ?
         BGT     ASZER3           ;  .    .    DONE WITH NUMBER ?
;
         LDA     #$20             ;  .    SET LEADING ZERO TO SPACE
         STA     B,X              ;  .    .
         INCB                     ;  .    POSITION TO NEXT DIGIT
         BRA     ASZER1           ;  .    .
;
ASZER2   LDA     #$30             ;  .    ENTIRE NUMBER = 0
         DECB                     ;  .    .    SET LAST DIGIT = $30
         STA     B,X              ;  .    .    .
         LDA     #' '             ;  .    .    RESET SIGN
         STA     -1,X             ;  .    .    .
         LDA     #$01             ;  .    .    SET ZERO FLAG
         STA     ,S               ;  .    .    .
;
ASZER3   PULS    A,X,PC           ;  .    RETURN TO CALLER
;
;
;
;
;  HANDLE GAME-OVER LOGIC
;  ======================
;
         direct   $D0
;        =====   ===
;
GAMOVR   LDA     ABORT            ;  HAS GAME BEEN ABORTED ?
         BEQ     GAMOV1           ;  .
;
GAMDON   PSHS    DP               ;  SAVE 'DP'
;
         JSR     INTMAX           ;  DISPLAY END OF GAME MESSAGE
         LDU     #M_END           ;  .    DISPLAY GAME-OVER MESSAGE
         JSR     DSMESS           ;  .    .
;
         LDD     #$78DC           ;  DISPLAY PLAYERS SCORE
         JSR     POSITD           ;  .    POSITION MESSAGE
         LDD     #$F638           ;  .    SET RASTER SIZE
         STD     SIZRAS           ;  .    .
         LDU     #PLAYER + 13     ;  .    DISPLAY HEADER MESSAGE
         JSR     RASTER           ;  .    .
;
         LDA     #$C8             ;  DETERMINE HIGH SCORE
         TFR     A,DP             ;  .    SET 'DP' = RAM
         direct   $C8              ;  .    .
;
         LDX     #PLYSCR          ;  .    IS PLAYER SCORE HIGHEST ?
         LDU     #HISCOR          ;  .    .
         JSR     HISCR            ;  .    .
;
         CLR     TMR1             ;  RESET PROGRAMMABLE TIMERS
         CLR     TMR2             ;  .
         CLR     TMR3             ;  .
         CLR     TMR4             ;  .
;
         LDX     TIMOUT           ;  TIME-OUT ON GAME SEQUENCE
         BEQ     GAMOV2           ;  .
         LEAX    -1,X             ;  .
         STX     TIMOUT           ;  .
;
         LDA     KEY3             ;  HAS PLAYER ABORTED LOCK-UP SEQUENCE ?
         BNE     GAMOV2           ;  .
;
         PULS    DP               ;  RETURN TO CALLER
GAMOV1   RTS                      ;  .
;
;
GAMOV2   LEAS    3,S              ;  RESTART VECTREX
         JMP     ENTRY            ;  .
;
;
;
;
;  INITIALIZE FOREST LEVEL WARRIOR
;  ===============================
;
;        RETURN VALUES
;        -------------
;           X  = DESTROYED
;           DP = $C8
;
         direct   $00
;        =====   ===
;
PNTWAR   LDA     #$C8             ;  SET 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDD     #SY_WAR          ;  SET SCREEN POSITION
         STD     WARYW            ;  .    'Y' AXIS
         LDD     #SX_WAR          ;  .    'X' AXIS
         STD     WARXW            ;  .    .
;
         CLR     WARINT           ;  RESET WARRIOR INTENSITY MODIFIER
;
         LDA     #$FF             ;  SET WARRIOR DASHING
         STA     WARDSH           ;  .
;
         LDA     #$01             ;  RESET WARRIOR ANIMATION COUNTER
         STA     WARFRM           ;  .
;
         CLR     WARINH           ;  RELEASE WARRIOR INHIBIT
         CLR     WARTHR           ;  RESET WARRIOR THROWING FLAG
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  SET-UP WARRIOR FOR BOX
;  ======================
;
;        RETURN VALUES
;        -------------
;           X  = DESTROYED
;           DP = $C8
;
         direct   $00
;        =====   ===
;
BOXWAR   LDA     #$C8             ;  SET 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDD     #BY_WAR          ;  SET SCREEN POSITION
         STD     WARYW            ;  .    'Y' AXIS
         LDD     #BX_WAR          ;  .    'X' AXIS
         STD     WARXW            ;  .    .
;
         LDA     #$7F             ;  SET WARRIOR INTENSITY MODIFIER
         STA     WARINT           ;  .
;
         LDA     #$FF             ;  SET WARRIOR DASHING
         STA     WARDSH           ;  .
;
         CLR     WARFRM           ;  RESET WARRIOR ANIMATION COUNTER
         CLR     WARTHR           ;  RESET WARRIOR THROWING FLAG
;
         LDA     #$01             ;  INHIBIT WARRIOR MOTION
         STA     WARINH           ;  .
;
         LDA     #$88             ;  SET PROJECTION LIMIT
         STA     PRJLIM           ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  SET-UP RANDOM POSITION WITHIN MAP
;  =================================
;
         direct   $C8
;        =====   ===
;
NEWMAP   JSR     RANDOM           ;  SET NEW LOOK-ANGLE
         ANDA    #$3F             ;  .
         STA     LOKANG           ;  .
         BSR     NEWANG           ;  .
;
         BSR     PNTWAR           ;  INITIALIZE WARRIOR FOR FOREST
;
         JSR     RANDOM           ;  SET NEW MAP POSITION
         LSRA                     ;  .    MAP 'Y' AXIS
         RORB                     ;  .    .
         LSRA                     ;  .    .
         RORB                     ;  .    .
         CMPD    #$3A00           ;  .    .    FUDGE VALUE IF CLOSE TO EDGE
         BLT     NWMP1            ;  .    .    .
         SUBD    #$0800           ;  .    .    .
NWMP1    CMPD    #$0400           ;  .    .    .
         BGT     NWMP2            ;  .    .    .
         ADDD    #$0800           ;  .    .    .
NWMP2    STD     MAPY             ;  .    .    SAVE NEW MAP 'Y'
         STA     LASTY            ;  .    .    .
;
         JSR     RANDOM           ;  .    MAP 'X' AXIS
         LSRA                     ;  .    .
         RORB                     ;  .    .
         LSRA                     ;  .    .
         RORB                     ;  .    .
         CMPD    #$3A00           ;  .    .    FUDGE VALUE IF CLOSE TO EDGE
         BLT     NWMP3            ;  .    .    .
         SUBD    #$0800           ;  .    .    .
NWMP3    CMPD    #$0400           ;  .    .    .
         BGT     NWMP4            ;  .    .    .
         ADDD    #$0800           ;  .    .    .
NWMP4    STD     MAPX             ;  .    .    SAVE NEW MAP 'X'
         STA     LASTX            ;  .    .    .
;
         CLR     SCTINH           ;  RESET SCOUT ACTION INHIBIT
;
         JMP     GRDSCN           ;  SCAN GRID FOR NEW POSITION & PROJECT
; 
;
;
;
;  UPDATE LOOK-ANGLE RELATED INFORMATION
;  =====================================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
         direct   $C8
;        =====   ===
;
NEWANG   LDA     LOKANG           ;  CALCULATE NEW REFERENCE ANGLE
         SUBA    #$08             ;  .
         ANDA    #$3F             ;  .
         STA     RFANGL           ;  .
;
         LDA     LOKANG           ;  CALCULATE SINE / COSINE FOR LOOK-ANGLE
         ANDA    #$3F             ;  .    LIMIT LOOK-ANGLE VALUE
         STA     LOKANG           ;  .    .
         ADDA    #$20             ;  .    FUDGE LOOK-ANGLE FOR PROJECTION
         STA     ANGLE            ;  .    DO SINE / COSINE
         JSR     SINCOS           ;  .    .
         LDD     WSINE            ;  .    SAVE SINE VALUE
         STD     DSINE            ;  .    .
         LDD     WCSINE           ;  .    SAVE COSINE VALUE
         STD     DCSINE           ;  .    .
;
         LDA     #WARSPD          ;  CALCULATE NEW WARRIOR DISPLACEMENTS
         LDB     LOKANG           ;  .    FETCH ANGLE OF MOTION
         ADDB    #$20             ;  .    .    FUDGE ANGLE
         JSR     LNROT            ;  .
         STA     ETMP1            ;  .
         SEX                      ;  .    FORM 16-BIT 'X-AXIS' DISPLACEMENT
         STD     WARXD            ;  .    .
         LDB     ETMP1            ;  .    FORM 16-BIT 'Y-AXIS' DISPLACEMENT
         SEX                      ;  .    .
         STD     WARYD            ;  .    .
;
         LDD     #$2020           ;  CLEAR PEDOMETER
         STD     PEDSGN - 1       ;  .
         STD     PEDSGN + 1       ;  .
         LDD     #$3080           ;  .
         STD     PEDSGN + 3       ;  .
         LDA     #$01             ;  .    RESET ZERO CROSSING FLAG
         STA     PEDZRO           ;  .    .
;
         LDX     #MPED            ;  SET PEDOMETER DIRECTION MESSAGE
         LDA     LOKANG           ;  .    LOOK-UP PEDOMETER MESSAGE
         LSRA                     ;  .    .
         LSRA                     ;  .    .
         ANDA    #$0E             ;  .    .
         LDX     A,X              ;  .    .
         LDU     #PEDMTR          ;  .    .
NWANG1   LDA     ,X+               ;  .    ROLL MESSAGE INTO PEDOMETER MESSAGE
         BMI     NWANG2           ;  .    .
         STA     ,U+               ;  .    .
         BRA     NWANG1           ;  .    .
;
NWANG2   RTS                      ;  .    RETURN TO CALLER
;
;
;
;
;  CALCULATE PROJECTION FOR BRIGAND SUB-PLOT
;  =========================================
;
         direct   $C8
;        =====   ===
;
FPROJ    LDD     #$0080           ;  SET SINE / COSINE VALUES
         STD     WSINE            ;  .
         LDD     #$FF81           ;  .
         STD     WCSINE           ;  .
;
         LDA     WARYW            ;  SET-UP WARRIOR POSITION
         STA     RZPOS            ;  .
         LDA     WARXW            ;  .
         STA     RXPOS            ;  .
         LDA     #BZ_WAR          ;  .
         STA     RYPOS            ;  .    
;
         BSR     PRJCTN           ;  .
;
         LDA     DRWSCY           ;  SAVE PROJECT WARRIOR POSITION
         STA     WARSCY           ;  .
         LDA     DRWSCX           ;  .
         STA     WARSCX           ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  CALCULATE OBJECT'S RELATIVE POSITION TO SCREEN POSITION
;  =======================================================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
;           RYPOS  = RELATIVE 'Y' AXIS POSITION (8-BITS)
;           RXPOS  = RELATIVE 'X' AXIS POSITION (8-BITS)
;           RZPOS  = RELATIVE 'Z' AXIS POSITION (8-BITS)
;
;        RETURN VALUES
;        -------------
;           V  = RESULTS OUT-OF-RANGE
;
         direct   $C8
;        =====   ===
;
PRJCTN   LDA     RZPOS            ;  CALCULATE THE SCREEN Z-ORDINATE
         JSR     MCSINE           ;  .
         STA     ETMP1            ;  .
         LDA     RXPOS            ;  .
         JSR     MSINE            ;  .
         SUBA    ETMP1            ;  .
         BLE     PRJC1            ;  .
         STA     DRWSCZ           ;  .
;
         LDA     RYPOS            ;  CALCULATE THE SCREEN Y-ORDINATE
         BSR     PRJDIV           ;  .
         BVS     PRJC1            ;  .
         CMPB    PRJLIM           ;  .
         BLE     PRJC1            ;  .
         STB     DRWSCY           ;  .
;
         LDA     RXPOS            ;  CALCULATE THE SCREEN X-ORDINATE
         JSR     MCSINE           ;  .
         STA     ETMP1            ;  .
         LDA     RZPOS            ;  .
         JSR     MSINE            ;  .
         ADDA    ETMP1            ;  .
         NEGA                     ;  .
         BSR     PRJDIV           ;  .
         BVS     PRJC1            ;  .
         STB     DRWSCX           ;  .
;
         ANDCC   #$FD             ;  RETURN TO CALLER
         RTS                      ;  .    VALID RESULTS
;     
PRJC1    ORCC    #$02             ;  RETURN TO CALLER
         RTS                      ;  .    OBJECT OUT-OF-RANGE
;
;
;
;
;  DIVISION ROUTINE FOR 'PRJCTN'
;  =============================
;
;        ENTRY VALUES
;        ------------
;           A  = DIVIDEND / 256 (MUST BE POSITIVE)
;           CC = MUST BE VALID FOR 'A' CONTENTS
;           DP = $C8
;
;           DRWSCZ = SCREEN Z-ORDINATE ('0' OR '1' ARE ILLEGAL)
;
;        RETURN VALUES
;        -------------
;           B  = QUOTIENT
;           Y  = #DIVTBL
;           V  = 0 - 'B' CONTENTS ARE LEGAL
;                1 - ILLEGAL RESULTS
;
         direct   $C8
;        =====   ===
;
PRJDIV   TFR     CC,B             ;  SAVE ENTRY VALUE SIGN
         BPL     PRJDV1           ;  .
         NEGA                     ;  .    TWO'S COMPLEMENT OF DIVIDEND
PRJDV1   STB     ETMP2            ;  .    SAVE SIGN OF DIVIDEND
         CLR     ETMP3            ;  .    RESET SHIFT FLAG
;
         CMPA    DRWSCZ           ;  FAST TEST FOR ILLEGAL RESULTS
         BGE     PRJDV5           ;  .
;
         LDB     DRWSCZ           ;  SET-UP DIVISOR
         SUBB    #$02             ;  .
         BCS     PRJDV5           ;  .    IF EITHER 0 OR 1 - CAUSES OVERFLOW
;
         CMPB    #14              ;  IF B &gt; 14, SHIFT QUOTIENT 4 TIMES
         BHI     PRJDV2           ;  .
         DEC     ETMP3            ;  .    SET SHIFT FLAG
;
PRJDV2   LDY     #DIVTBL          ;  LOOK-UP QUOTIENT IN DIVIDE TABLE
         LDB     B,Y              ;  .
         MUL                      ;  .
         TST     ETMP3            ;  .    SHIFT DIVIDE TABLE RESULT ?
         BNE     PRJDV3           ;  .    .
;
         ASRA                     ;  .    SHIFT QUOTIENT 4 TIMES
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
;
PRJDV3   TSTB                     ;  IS QUOTIENT VALID BUT OUT OF RANGE ?
         BMI     PRJDV5           ;  .
;
         LDA     ETMP2            ;  ADJUST SIGN OF RESULT
         TFR     A,CC             ;  .
         BPL     PRJDV4           ;  .
         NEGB                     ;  .
;     
PRJDV4   ANDCC   #$FD             ;  RETURN TO CALLER
         RTS                      ;  .    VALID RESULTS
;      
PRJDV5   ORCC    #$02             ;  RETURN TO CALLER
         RTS                      ;  .    ILLEGAL RESULTS
;
;
;
;
;  MOVE ASCII STRING
;  =================
;
;        ENTRY VALUES
;        ------------
;           X  = ASCII SOURCE STRING ($80 TERMINATOR)
;           U  = ASCII DESTINATION STRING
;           DP = $00
;
         direct   $00
;        =====   ===
;
;
SMOVE    LDA     ,X+               ;  MOVE BODY OF MESSAGE
         STA     ,U+               ;  .
         BPL     SMOVE            ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  DRAW COMPACT RASTER MESSAGE STRING
;  ==================================
;
;        ENTRY VALUES
;        ------------
;           U  = MESSAGE STRING ADDRESS
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
DSMESS   PSHS    U                ;  SAVE ENTRY VALUES
;
DSMS1    LDD     ,U++              ;  FETCH RASTER SIZE
         STD     SIZRAS           ;  .
;
         LDD     ,U++              ;  POSITION RASTER MESSAGE
         JSR     POSITD           ;  .
;
         JSR     RASTER           ;  DRAW RASTER MESSAGE STRING
;
         LDA     ,U               ;  END OF MESSAGE STRING ?
         BNE     DSMS1            ;  .
;
         PULS    U,PC             ;  RETURN TO CALLER
;
;
;
;
;  STAR-BURST HANDLER
;  ==================
;
;        ENTRY VALUES
;        ------------
;           D  = CENTRE OF STAR-BURST
;           DP = $D0
;
;        RETURN VALUES
;        -------------
;           A  = INTENSITY MODIFIER
;
         direct   $D0
;        =====   ===
;
DHYPER   STD     ETMP3            ;  SAVE STAR-BURST CENTRE
;
         LDA     BRSFLG           ;  IS STAR-BURST PENDING ?
         BEQ     HYPR4            ;  .    SKIP STAR-BURST ?
         BMI     HYPR1            ;  .    CONTRACTING STAR-BURST ?
;
         LDA     BRSTMR           ;  EXPANDING STAR-BURST
         ADDA    #$02             ;  .
         STA     BRSTMR           ;  .    
         CMPA    #$20             ;  .    EXPANDING DONE ?
         BGE     HYPR6            ;  .    .
         BRA     HYPR2            ;  .
;
HYPR1    LDA     BRSTMR           ;  CONTRACTING STAR-BURST
         SUBA    #$02             ;  .
         STA     BRSTMR           ;  .
         BLE     HYPR6            ;  .    CONTRACTION DONE ?
;
HYPR2    LDA     BRSTMR           ;  SET STAR-BURST SIZE
         STA     ETMP7            ;  .
;
         LDA     #$09             ;  SET FIELD COUNTER
         STA     ETMP8            ;  .
;
HYPR3    JSR     ZERGND           ;  ZERO INTEGRATORS
;
         DEC     ETMP8            ;  MOVE TO NEXT FIELD
         BNE     HYPR5            ;  .
         LDA     ETMP7            ;  .    SET NEW STAR-BURST SIZE
         ADDA    #$08             ;  .    .
         STA     ETMP7            ;  .    .
;
         JSR     ZERGND           ;  RETURN TO CALLER
HYPR4    LDA     BRSTMR           ;  .    SET INTENSITY MODIFIER
         LSLA                     ;  .    .
         RTS                      ;  .
;
;
HYPR5    LDA     #$03             ;  SET DOT DWELL TIME
         STA     LIST             ;  .
;
         LDD     ETMP3            ;  POSITION STAR-BURST
         SUBA    #$08             ;  .
         JSR     POSITD           ;  .
;
         LDB     ETMP8            ;  CALCULATE ZOOM VALUE FOR THIS FIELD
         LSLB                     ;  .
         LSLB                     ;  .
         ADDB    ETMP7            ;  .
         BLE     HYPR3            ;  .
         ANDB    #$7F             ;  .
         STB     T1LOLC           ;  .
;
         LDX     #FSTAR           ;  FETCH FIELD POINTER
         LDA     ETMP8            ;  .
         DECA                     ;  .
         LSLA                     ;  .
         LDX     A,X              ;  .
;
         LDA     #$7F             ;  SET INTENSITY
         SUBA    ETMP7            ;  .
         JSR     INTENS           ;  .
         JSR     DIFDOT           ;  DRAW STAR FIELD
         BRA     HYPR3            ;  DO NEXT FIELD
;
;
HYPR6    JSR     ZERGND           ;  RETURN TO CALLER
         CLR     BRSFLG           ;  .    RESET STAR-BURST
         LDA     BRSTMR           ;  .    .
         LSLA                     ;  .    SET INTENSITY MODIFIER
         RTS                      ;  .
;
;
;
;
;  16-BIT POSITION AND DRAW COMPACT 'DIFFY' FORMAT
;  ===============================================
;
;        ENTRY VALUES
;        ------------
;           D  = POINTER TO 'DIFFY' LIST #1
;                   IF = 0, THEN 'DRWLS1' & 'DRWLS2' WILL BE USED
;           X  = POINTER TO 'DIFFY' LIST #2
;           Y  = POINTER TO ABSOLUTE SCREEN POSITION (16-BITS WIDE)
;
;           DRWINT = INTENSITY FOR 'DIFFY' LISTS
;           DRWSIZ = ZOOM SIZE FOR 'DIFFY' LISTS
;
;           DRWLS1 = POINTER TO 'DIFFY' LIST #1 (IF 'D' = $0000)
;           DRWLS2 = POINTER TO 'DIFFY' LIST #2 (IF 'D' = $0000)
;
         direct   $00
;        =====   ===
;
CDIFFY   PSHS    D,X,Y,DP         ;  SAVE ENTRY VALUES
;
         LDA     #$D0             ;  SET 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         LDD     DRWINT           ;  DRAW 'DIFFY' LIST #1
         LDY     5,S              ;  .
         LDX     <<0,S              ;  .
         BEQ     CDIF1            ;  .
         BSR     SDIFFY           ;  .
;
         LDD     DRWINT           ;  DRAW 'DIFFY' LIST #2
         LDX     3,S              ;  .
         LDY     5,S              ;  .
         BSR     SDIFFY           ;  .
;
         PULS    D,X,Y,DP,PC      ;  RETURN TO CALLER
;
;
CDIF1    LDX     DRWLS1           ;  DRAW 'DIFFY' LIST USING 'DRWLS1/2'
         BSR     SDIFFY           ;  .    DRAW 'DIFFY' LIST #1
;
         LDD     DRWINT           ;  .    DRAW 'DIFFY' LIST #2
         LDX     DRWLS2           ;  .    .
         LDY     5,S              ;  .    .
         BSR     SDIFFY           ;  .    .
;
         PULS    D,X,Y,DP,PC      ;  .    RETURN TO CALLER
;
;
;
;
;  32-BIT POSITION AND DRAW COMPACT 'DIFFY' FORMAT
;  ===============================================
;
;        ENTRY VALUES
;        ------------
;           D  = POINTER TO 'DIFFY' LIST #1
;                   IF = 0, THEN 'DRWLS1' & 'DRWLS2' WILL BE USED
;           X  = POINTER TO 'DIFFY' LIST #2
;           Y  = POINTER TO ABSOLUTE SCREEN POSITION (32-BITS WIDE)
;
;           DRWINT = INTENSITY FOR 'DIFFY' LISTS
;           DRWSIZ = ZOOM SIZE FOR 'DIFFY' LISTS
;
;           DRWLS1 = POINTER TO 'DIFFY' LIST #1 (IF 'D' = $0000)
;           DRWLS2 = POINTER TO 'DIFFY' LIST #2 (IF 'D' = $0000)
;
         direct   $00
;        =====   ===
;
XDIFFY   PSHS    D,X,Y,DP         ;  SAVE ENTRY VALUES
;
         LDA     #$D0             ;  SET 'DP' = I/O
         TFR     A,DP             ;  .
         direct   $D0              ;  .
;
         LDD     DRWINT           ;  DRAW 'DIFFY' LIST #1
         LDY     5,S              ;  .
         LDX     <<0,S              ;  .
         BEQ     XDIF1            ;  .
         BSR     WDIFFY           ;  .
;
         LDD     DRWINT           ;  DRAW 'DIFFY' LIST #2
         LDX     3,S              ;  .
         LDY     5,S              ;  .
         BSR     WDIFFY           ;  .
;
         PULS    D,X,Y,DP,PC      ;  RETURN TO CALLER
;
;
XDIF1    LDX     DRWLS1           ;  DRAW 'DIFFY' LIST USING 'DRWLS1/2'
         BSR     WDIFFY           ;  .    DRAW 'DIFFY' LIST #1
;
         LDD     DRWINT           ;  .    DRAW 'DIFFY' LIST #2
         LDX     DRWLS2           ;  .    .
         LDY     5,S              ;  .    .
         BSR     WDIFFY           ;  .    .
;
         PULS    D,X,Y,DP,PC      ;  .    RETURN TO CALLER
;
;
;
;
;  16-BIT POSITION AND DRAW 'DIFFY' FORMAT
;  =======================================
;
;        ENTRY VALUES
;        ------------
;           A  = INTENSITY ($00 - $7F)
;           B  = VECTOR LENGTH
;           X  = POINTER TO 'DIFFY' STYLE LIST
;           Y  = POINTER TO ABSOLUTE SCREEN POSITION (16-BITS WIDE)
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
SDIFFY   PSHS    B,X,Y            ;  SAVE ENTRY VALUES
;
         JSR     INTENS           ;  SET INTENSITY
;
         LDD     ,Y               ;  POSITION OBJECT
         JSR     POSITD           ;  .
;
         PULS    B,X,Y            ;  RESTORE ENTRY VALUES
         BRA     ZDIFFY           ;  DRAW 'DIFFY' FORMAT
;
;
;
;
;  32-BIT POSITION AND DRAW 'DIFFY' FORMAT
;  =======================================
;
;        ENTRY VALUES
;        ------------
;           A  = INTENSITY ($00 - $7F)
;           B  = VECTOR LENGTH
;           X  = POINTER TO 'DIFFY' STYLE LIST
;           Y  = POINTER TO ABSOLUTE SCREEN POSITION (32-BITS WIDE)
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
WDIFFY   PSHS    B,X,Y            ;  SAVE ENTRY VALUES
;
         JSR     INTENS           ;  SET INTENSITY
;
         TFR     Y,X              ;  POSITION OBJECT
         JSR     POSWID           ;  .
;
         PULS    B,X,Y            ;  RESTORE ENTRY VALUES
;
;
;
;
;  DRAW 'DIFFY' FORMAT
;  ===================
;
;        ENTRY VALUES
;        ------------
;           B  = VECTOR LENGTH
;           X  = POINTER TO 'DIFFY' STYLE LIST
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
ZDIFFY   STB     T1LOLC           ;  SET VECTOR LENGTH
;
         LDA     ,X+               ;  SET NUMBER OF VECTORS - 1
         BEQ     ZPCK0            ;  .    'PACKET' FORMAT ?
         BMI     ZDUF1            ;  .    'DUFFY' FLAG SET ?
         BRA     ZDUF5            ;  .
;
;
;
;
;  DRAW 'DUFFY' FORMAT FOR SCENERY
;  ===============================
;
;        ENTRY VALUES
;        ------------
;           B  = VECTOR LENGTH
;           X  = POINTER TO 'DUFFY' STYLE LIST
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
ZDUFFY   STB     T1LOLC           ;  SET VECTOR LENGTH
;
         LDA     ,X+               ;  SET NUMBER OF VECTORS - 1
ZDUF1    ANDA    #$3F             ;  .
         STA     LIST             ;  .
;
         LDD     ,X               ;  FETCH RELATIVE 'Y:X'
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         LEAX    2,X              ;  .    POSITION TO NEXT ENTRY
         NOP                      ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
;
         TST     RFLAG            ;  SET 'X' AXIS VALUE
         BEQ     ZDUF2            ;  .    COMPLEMENT 'X' AXIS ?
         NEGB                     ;  .    .
ZDUF2    STB     DAC              ;  .    SAVE 'X' VALUE
;
         LDD     #$0000           ;  POSITION BEAM FOR START OF 'DUFFY' LIST
         STA     SHIFT            ;  .
         STB     T1HOC            ;  .
;
         LDD     #$0040           ;  WAIT FOR VECTOR COMPLETION
ZDUF3    BITB    IFLAG            ;  .
         BEQ     ZDUF3            ;  .
         NOP                      ;  .    &lt;&lt; TIMING &gt;&gt;
         STA     SHIFT            ;  .
         LDA     LIST             ;  .
;
;
ZDUF4    DECA                     ;  DECREMENT VECTOR COUNT
;
ZDUF5    STA     LIST             ;  SET VECTOR COUNT
         LDD     ,X               ;  FETCH RELATIVE 'Y:X'
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         LEAX    2,X              ;  .    POSITION TO NEXT ENTRY
         NOP                      ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
;
         TST     RFLAG            ;  SET 'X' AXIS VALUE
         BEQ     ZDUF6            ;  .    COMPLEMENT 'X' AXIS ?
         NEGB                     ;  .    .
ZDUF6    STB     DAC              ;  .    SAVE 'X' VALUE
;
         LDA     DASH             ;  DRAW DASHED LINE DURING VECTOR
         LDB     #$40             ;  .
         STA     SHIFT            ;  .    SET DASH PATTERN
         CLR     T1HOC            ;  .    START VECTOR RAMP
         BITB    IFLAG            ;  .    IS VECTOR COMPLETE ?
         BEQ     ZDUF8            ;  .    .    LONG DASHED VECTOR ?
         CLR     SHIFT            ;  .    SHORT VECTOR - CLEAR DASHING
;
         LDA     LIST             ;  END OF LIST ?
         BNE     ZDUF4            ;  .
         JMP     ZERGND           ;  .    ZERO INTEGRATORS
;
ZDUF7    LDA     DASH             ;  LONG DASHED LINE
ZDUF8    STA     SHIFT            ;  .    REPEAT DASH PATTERN
         NOP                      ;  .    .    &lt;&lt; TIMING &gt;&gt;
         BITB    IFLAG            ;  .    WAIT FOR COMPLETION
         BEQ     ZDUF7            ;  .    .
;
         LDA     LIST             ;  VECTOR COMPLETE
         CLR     SHIFT            ;  .    CLEAR DASH PATTERN
         TSTA                     ;  .    END OF DASHING LIST ?
         BNE     ZDUF4            ;  .    .
         JMP     ZERGND           ;  .    ZERO INTEGRATORS
;
;
;
;
;  DRAW 'PACKET' FORMAT FOR SCENERY
;  ================================
;
;        ENTRY VALUES
;        ------------
;           B  = VECTOR LENGTH
;           X  = POINTER TO 'PACKET' STYLE LIST
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
ZPACK    STB     T1LOLC           ;  SET VECTOR LENGTH
;
ZPCK0    LDD     1,X              ;  FETCH 'Y:X' AXIS VALUE
;
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         LDA     ,X               ;  .    .    FETCH BEAM ENABLE
         LEAX    3,X              ;  .    .    POSITION FOR NEXT ENTRY
         TST     RFLAG            ;  .    .    COMPLEMENT 'X' AXIS ?
         BEQ     ZPCK1            ;  .    .    .
         NEGB                     ;  .    .    .
ZPCK1    INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
;
         STB     DAC              ;  SET 'X' AXIS VALUE
         STA     SHIFT            ;  .    SET BEAM ENABLE
         CLR     T1HOC            ;  .    START VECTOR RAMP
;
         LDD     #$0040           ;  WAIT FOR VECTOR COMPLETION
ZPCK2    BITB    IFLAG            ;  .
         BEQ     ZPCK2            ;  .
         NOP                      ;  .    &lt;&lt; TIMING &gt;&gt;
;
         STA     SHIFT            ;  TURN-OFF BEAM
;
         LDA     ,X               ;  PACKET TERMINATOR ?
         BLE     ZPCK0            ;  .
         JMP     ZERGND           ;  .    ZERO INTEGRATORS AND SET ACTIVE GND
;
;
;         IF      L.SBR = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
