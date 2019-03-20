;
;
;         IF      L.SUBR = OFF     ;-------------------------------------------
;         LIST    -L               ;--  SUBR  ---------------------------------
;         ENDIF                    ;-------------------------------------------
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
;  CLEAR GAME RELATED TABLES
;  =========================
;
         direct   $C8
;        =====   ===
;
CLRGAM   LDX     #BLTTBL          ;  CLEAR GAME TABLES
         LDD     #$0000           ;  .
CGAM1    STD     ,X++              ;  .
         CMPX    #ENDBRD          ;  .
         BLE     CGAM1            ;  .
;
         LDA     #$0F             ;  SET BLASTER INHIBIT TIMER
         STA     BLSTMR           ;  .
;
         LDD     #$9000           ;  RESET BLASTER POSITION
         STD     BLSTY            ;  .
         STD     BLSTYX           ;  .
         LDD     #$0000           ;  .
         STD     BLSTX            ;  .
;
FSTCLR   CLR     TMR1             ;  RESET PROGRAMMABLE TIMERS
         CLR     TMR2             ;  .
;
;==========================================================================JJH
         CLR     ABORT            ;  CODE ADDED - REV. B CHANGES     ======JJH
         CLR     LOCK             ;  .                               ======JJH
;==========================================================================JJH
;
         CLR     CBLT             ;  CLEAR BULLET COUNTER
         CLR     CGRD             ;  CLEAR GUARDIAN COUNTER
         CLR     CSPK             ;  CLEAR SPIKER COUNTER
         CLR     CBRD             ;  CLEAR WAR-BIRD COUNTER
;
         CLR     SHOOT            ;  CLEAR SOUND EFFECT FLAGS
         CLR     OUCH             ;  .
         CLR     SQUAWK           ;  .
         CLR     SIZZLE           ;  .
         CLR     EXPLO1           ;  .
         CLR     EXPLO2           ;  .
         CLR     XACON            ;  .
         JSR     INTREQ           ;  .
;
         CLR     EKLTMR           ;  CLEAR KILLER EXPLOSION TIMER
;
         LDA     #$7F             ;  SET LEVEL DISPLAY TIMER
         STA     LVLTMR           ;  .
;
         STA     LCKTMR           ;  SET LOCK-UP BUTTON INHIBIT TIMER
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  CALCULATE TABLE POINTER FOR ACTIVE PLAYER
;  =========================================
;
ACTPTR   LDY     #PTABLE
         LDA     ACTPLY
         LDY     A,Y
         RTS
;
;
;
;
;  HANDLE LOCK-UP LOGIC
;  ====================
;
LOCKUP   JSR     INTREQ           ;  RESET SOUND EFFECTS
         CLR     SIZZLE           ;  .
         CLR     EXPLO1           ;  .
         CLR     EXPLO2           ;  .
         CLR     XACON            ;  .
;
         PSHS    DP               ;  DISPLAY BOTH PLAYERS SCORE
         LDA     #$D0             ;  .    SET 'DP' TO I/O
         TFR     A,DP             ;  .    .
         direct   $D0              ;  .    .
;
         JSR     SCRBTH           ;  .    DISPLAY SCORES
         LDU     #MEND            ;  .    DISPLAY 'END-OF-GAME' MESSAGE
         JSR     SMESS            ;  .    .
;
         PULS    DP               ;  SET 'DP' TO RAM
         direct   $C8              ;  .
;
         LDX     #SCOR1           ;  IS PLAYER #1 SCORE HIGHEST ?
         LDU     #HISCOR          ;  .
         JSR     HISCR            ;  .
;
         LDX     #SCOR2           ;  IS PLAYER #2 SCORE HIGHEST ?
         LDU     #HISCOR          ;  .
         JSR     HISCR            ;  .
;
         LDX     TIMOUT           ;  SEQUENCE TIME-OUT ?
         LEAX    -1,X             ;  .
         STX     TIMOUT           ;  .
         BEQ     LCKENT           ;  .
;
         LDA     LCKTMR           ;  DECREMENT LOCK-OUT TIMER
         BEQ     LOCK1            ;  .
         DEC     LCKTMR           ;  .
         BRA     LOCK2            ;  .
;
LOCK1    LDA     TRIGGR           ;  PLAYER ABORTED LOCK-UP SEQUENCE ?
         BNE     LCKGAM           ;  .
;
LOCK2    RTS                      ;  RETURN TO CALLER
;
;
LCKENT   PULS    D                ;  RESTART VECTREX
         JMP     ENTRY            ;  .
;
;
LCKGAM   PULS    D                ;  RESTART THIS GAME - SAME OPTIONS
         JMP     GAME2            ;  .
;
;
;
;
;  CHECK FOR PLAYER ACTIVITY
;  =========================
;
         direct   $C8
;        =====   ===
;
BTNACT   LDA     TRIGGR           ;  HAS ANY BUTTON BEEN PUSHED ?
         BNE     ACTV1            ;  .
;
         LDX     BTNTMR           ;  NO PLAYER ACTIVITY THIS FRAME
         LEAX    -1,X             ;  .    DECREMENT BUTTON TIMER
         STX     BTNTMR           ;  .    .
         BEQ     ACTENT           ;  .    .    BUTTON TIMER TIME-OUT ?
         RTS                      ;  .    RETURN TO CALLER
;
;
ACTV1    LDX     #$8000           ;  SOMEBODY HIT A KEY
         STX     BTNTMR           ;  .
         RTS                      ;  .    RETURN TO CALLER
;
;
ACTENT   PULS    D                ;  NOBODY IS PLAYING - RESTART VECTREX
         JMP     ENTRY            ;  .
;
;
;
;
;  RECORD SCORE CHANGE
;  ===================
;
;        ENTRY VALUES
;        ------------
;           D  = BCD FORMAT SCORE
;
         direct   $C8
;        =====   ===
;
SCORED   PSHS    D,X              ;  SAVE ENTRY VALUES
;
         LDX     #SCRPTR          ;  FETCH ACTIVE PLAYER SCORE
         LDA     ACTPLY           ;  .
         LDX     A,X              ;  .
;
;==========================================================================JJH
;        LDD     0,S              ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDD     ,S               ;  CODE ADDED - REV. B CHANGES     ======JJH
;==========================================================================JJH
;
         JSR     SCRADD           ;  .
;
         PULS    D,X,PC           ;  RETURN TO CALLER
;
;
;
;
;  CALCULATE DISPLACEMENTS FOR INDICATED OBJECT
;  ============================================
;
;        ENTRY VALUES
;        ------------
;           A  = SPEED OF OBJECT
;           U  = OBJECT TABLE POINTER
;                   + 1/2  = 'Y' AXIS DISPLACEMENT
;                   + 3/4  = 'X' AXIS DISPLACEMENT
;                   + 11   = ANGLE OF MOTION
;
         direct   $C8
;        =====   ===
;
CALDSP   PSHS    X,Y              ;  SAVE ENTRY VALUES
;
         LDB     11,U             ;  FETCH OBJECT ANGLE OF MOTION
         JSR     MLTY16           ;  CALCULATE NEW DISPLACEMENTS
         STY     1,U              ;  .    'Y' DISPLACEMENT
         STX     3,U              ;  .    'X' DISPLACEMENT
;
         PULS    X,Y,PC           ;  RETURN TO CALLER
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
;                   + 9/10 = 'YX' POSITION
;
;        RETURN VALUES
;        -------------
;           C  = SET IF 'Y' AXIS OVER-FLOW
;           V  = SET IF 'X' AXIS OVER-FLOW
;
;           LASTY  = 'Y' POSITION LAST FRAME
;           LASTX  = 'X' POSITION LAST FRAME
;           NEXTY  = 'Y' POSITION NEXT FRAME
;           NEXTX  = 'X' POSITION NEXT FRAME
;
         direct   $C8
;        =====   ===
;
MOVOBJ   LDD     5,U              ;  UPDATE 'Y' AXIS POSITION
         STD     LASTY            ;  .    SAVE LAST 'Y'
         ADDD    1,U              ;  .    CALCULATE CURRENT 'Y'
         PSHS    A                ;  .    .    SAVE 'V' FOR 'Y' AXIS
         TFR     CC,A             ;  .    .    .    PLACE 'V' STATUS IN 'C'
         ANDA    #$02             ;  .    .    .    .
         LSRA                     ;  .    .    .    .
         STA     -1,S             ;  .    .    .    .
         PULS    A                ;  .    .    .
         STD     5,U              ;  .    .
         STA     9,U              ;  .    .    SAVE 'YX' POSITION
         ADDD    1,U              ;  .    CALCULATE NEXT 'Y'
         STD     NEXTY            ;  .    .
;
         LDD     7,U              ;  UPDATE 'X' AXIS POSITION
         STD     LASTX            ;  .    SAVE LAST 'X'
         ADDD    3,U              ;  .    CALCULATE CURRENT 'X'
         PSHS    A                ;  .    .    SAVE 'V' FOR 'X' AXIS
         TFR     CC,A             ;  .    .    .
         ANDA    #$F2             ;  .    .    .
         ORA     -1,S             ;  .    .    .
         STA     -1,S             ;  .    .    .
         PULS    A                ;  .    .    .
         STD     7,U              ;  .    .
         STA     10,U             ;  .    .    SAVE 'YX' POSITION
         ADDD    3,U              ;  .    CALCULATE NEXT 'X'
         STD     NEXTX            ;  .    .
;
         LDA     -2,S             ;  RECALL STATUS
         TFR     A,CC             ;  .    .    .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  MOVE EXPLOSION FRAGMENTS
;  ========================
;
;        ENTRY VALUES
;        ------------
;           A  = ROTATIONAL VALUE
;           X  = SOURCE 'DUFFY' POINTER
;           Y  = EXPLOSION TABLE POINTER
;           U  = DESTINATION 'DUFFY' POINTER
;
         direct   $C8
;        =====   ===
;
MOVEXP   PSHS    X,Y,U            ;  SAVE ENTRY VALUES
;
         ADDA    EKLROT,Y         ;  ROTATE FRAGMENT
         STA     EKLROT,Y         ;  .    CALCULATE NEW ROTATION VALUE
         LDB     ,X+               ;  .    FETCH VECTOR COUNT
         STB     ,U+               ;  .    .
         JSR     DROT             ;  .    ROTATE DUFFY
;
         LDU     2,S              ;  MOVE FRAGMENT
         LEAU    -1,U             ;  .
         BSR     MOVOBJ           ;  .
;
         PULS    X,Y,U,PC         ;  RETURN TO CALLER
;
;
;
;
;  CALCULATE DISPLACEMENTS FOR EXPLOSION OBJECT
;  ============================================
;
;        ENTRY VALUES
;        ------------
;           A  = SPEED OF OBJECT
;           X  = POINTER TO 32-BIT INITIAL EXPLOSION POSITION
;           U  = OBJECT TABLE POINTER
;                   + 0/1  = 'Y' AXIS DISPLACEMENT
;                   + 2/3  = 'X' AXIS DISPLACEMENT
;                   + 4/5  = CURRENT 'Y' POSITION
;                   + 6/7  = CURRENT 'X' POSITION
;                   + 8/9  = CURRENT 'YX' POSITION
;                   + 10   = ROTATION COUNTERS
;
         direct   $C8
;        =====   ===
;
EXPDSP   PSHS    X,Y              ;  SAVE ENTRY VALUES
;
         JSR     SWING            ;  FETCH OBJECT ANGLE OF MOTION
         JSR     MLTY16           ;  CALCULATE NEW DISPLACEMENTS
         STY     0,U              ;  .    'Y' DISPLACEMENT
         STX     2,U              ;  .    'X' DISPLACEMENT
;
         PULS    X,Y              ;  RECOVER POINTERS
;
         LDD     0,X              ;  SET INITIAL 'Y' POSITION
         STD     4,U              ;  .
         STA     8,U              ;  .    SET 'YX' POSITION
;
         LDD     2,X              ;  SET INITIAL 'X' POSITION
         STD     6,U              ;  .
         STA     9,U              ;  .    SET 'YX' POSITION
;
         CLR     10,U             ;  CLEAR ROTATION COUNTER
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  CLEAR INDICATED BULLET ENTRY
;  ============================
;
;        ENTRY VALUES
;        ------------
;           U  = BULLET TABLE POINTER
;
         direct   $C8
;        =====   ===
;
CLRBLT   CLR     BLTFLG,U         ;  CLEAR BULLET ENTRY
         DEC     CBLT             ;  DECREMENT ACTIVE BULLET COUNTER
         CLR     BLSTMR           ;  RESET BLASTER INHIBIT
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  INITIALIZE ROADWAY LIMITS
;  =========================
;
         direct   $C8
;        =====   ===
;
INTROD   LDA     LFLAG            ;  INITIALIZE WHICH ROADWAY ?
         CMPA    #$03             ;  .    KILLER SEQUENCE ?
         BEQ     INTRD2           ;  .    .
         CMPA    #$01             ;  .    MIDDLE ROADWAY ?
         BEQ     INTRD1           ;  .    .
;
         LDU     #LR_LIM          ;  SET-UP LOWER OR UPPER ROADWAY LIMITS
         LDX     #CR_LIM          ;  .    ROADWAY LIMITS
         LDA     #64              ;  .    .
         JSR     BLKMOV           ;  .    .
         LDU     #HR_LIM          ;  .    HIDDEN ROADWAY LIMITS
         LDX     #CHRLIM          ;  .    .
         LDA     #64              ;  .    .
         JSR     BLKMOV           ;  .    .
         RTS                      ;  .    RETURN TO CALLER
;
;
INTRD1   LDU     #LR_LIM          ;  SET-UP MIDDLE ROADWAY LIMITS
         LDX     #CL_LIM          ;  .    ROADWAY LIMITS
         LDB     #32              ;  .    .
         BSR     NEGMOV           ;  .    .
         LDU     #LL_LIM          ;  .    .
         LDX     #CR_LIM          ;  .    .
         LDB     #32              ;  .    .
         BSR     NEGMOV           ;  .    .
;:
         LDU     #HR_LIM          ;  .    HIDDEN ROADWAY LIMITS
         LDX     #CHLLIM          ;  .    .
         LDB     #32              ;  .    .
         BSR     NEGMOV           ;  .    .
         LDU     #HL_LIM          ;  .    .
         LDX     #CHRLIM          ;  .    .
         LDB     #32              ;  .    .
         BSR     NEGMOV           ;  .    .
         RTS                      ;  .    RETURN TO CALLER
;
;
INTRD2   LDA     #$B0             ;  SET-UP LIMITS FOR KILLER SEQUENCE
         LDB     #32              ;  .    LEFT ROADWAY LIMITS
         LDX     #CL_LIM          ;  .    .
         JSR     BLKFIL           ;  .    .
         LDB     #32              ;  .    LEFT HIDDEN ROADWAY LIMITS
         LDX     #CHLLIM          ;  .    .
         JSR     BLKFIL           ;  .    .
         LDA     #$48             ;  .    RIGHT ROADWAY LIMITS
         LDB     #32              ;  .    .
         LDX     #CR_LIM          ;  .    .
         JSR     BLKFIL           ;  .    .
         LDB     #32              ;  .    RIGHT HIDDEN ROADWAY LIMITS
         LDX     #CHRLIM          ;  .    .
         JSR     BLKFIL           ;  .    .
         RTS                      ;  .    .
;
;
;
;
;  MOVE INDICATED BUFFER AND TWO'S COMPLEMENT CONTENTS
;  ===================================================
;
;        ENTRY VALUES
;        ------------
;           B  = NUMBER OF BYTES TO TRANSFER
;           X  = POINTER TO DESTINATION BUFFER
;           U  = POINTER TO SOURCE BUFFER
;
         direct   $00
;        =====   ===
;
NEGMOV   LDA     ,U+               ;  FETCH BYTE FROM SOURCE BUFFER
         NEGA                     ;  COMPLEMENT BYTE
         STA     ,X+               ;  SAVE BYTE IN DESTINATION BUFFER
         DECB                     ;  END-OF-TRANSFER ?
         BNE     NEGMOV           ;  .
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  STRING BLOCK MOVE
;  =================
;
;        ENTRY VALUES
;        ------------
;           X  = POINTER TO SOURCE BUFFER
;           Y  = POINTER TO DESTINATION BUFFER
;
         direct   $00
;        =====   ===
;
SMOVE    LDB     ,X+               ;  FETCH BYTES TO BE TRANSFERRED
;
SMOV1    LDA     ,X+               ;  MOVE BYTE FROM SOURCE TO DESTINATION
         STA     ,Y+               ;  .
;
         DECB                     ;  DONE MOVIN' ?
         BNE     SMOV1            ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  CALCULATE PERSPECTIVE POINTER AND FETCH TABLE ENTRY
;  ===================================================
;
;        ENTRY VALUES
;        ------------
;           A  = VERTICAL POSITION
;           X  = TABLE POINTER
;
;        RETURN VALUES
;        -------------
;           A  = PERSPECTIVE POINTER
;           B  = PERSPECTIVE RELATED TABLE ENTRY
;
         direct   $00
;        =====   ===
;
PRSPCT   ADDA    #$80             ;  MAKE POSITIVE
;
         LSRA                     ;  DIVIDE BY 8
         LSRA                     ;  .
         LSRA                     ;  .
;
         LDB     A,X              ;  FETCH TABLE ENTRY FOR THIS POINTER
;
         RTS                      ;  RETURN TO CALLER
;
;    
;
;
;  SELECT THE 'SWING' VALUE
;  ========================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           B  = SWING VALUE
;
         direct   $C8
;        =====   ===
;
SWING    PSHS    A,X              ;  SAVE ENTRY VALUES
;
         JSR     RANDOM           ;  FETCH A RANDOM NUMBER
         LDX     #SWGTBL          ;  FETCH SWING VALUE
         ANDA    #$0F             ;  .
         LDB     A,X              ;  .
         PULS    A,X,PC           ;  RETURN TO CALLER
;
SWGTBL   DB      11,10,9,8,7,6,5,4
         DB      -4,-5,-6,-7,-8,-9,-10,-11
;
;
;
;
;  SELECT DIRECTION WITHIN LIMIT CONES
;  ===================================
;
;        ENTRY VALUES
;        ------------
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           A  = RANDOM ANGLE WITH-IN LEFT / RIGHT CONE
;
         direct   $C8
;        =====   ===
;
LRCONE   PSHS    X                ;  SAVE ENTRY VALUES
;
         LSRA                     ;  SAVE PREVIOUS ROTATION SIGN
         LSRA                     ;  .
         LSRA                     ;  .
         ANDA    #$04             ;  .
         PSHS    A                ;  .
;
         JSR     RANDOM           ;  FETCH NEW ROTATION ANGLE
         ANDA    #$03             ;  .
         ADDA    ,S+               ;  .
         LDX     #LRTBL           ;  .
         LDA     A,X              ;  .
         PULS    X,PC             ;  RETURN TO CALLER
;
LRTBL    DB      $28,$2E,$2D,$2C
         DB      $18,$16,$13,$14
;
;
;
;  8 X 8 SIGNED MULTIPLY
;  =====================
;
;        ENTRY VALUES
;        ------------
;           A  = 8-BIT TWO'S COMPLEMENT MULTIPLICAND
;           B  = 8-BIT TWO'S COMPLEMENT MULTIPLIER
;           DP = $C8
;
;        RETURN VALUES
;        -------------
;           D  = 16-BIT TWO'S COMPLEMENT PRODUCT
;
         direct   $C8
;        =====   ===
;
MULT8    PSHS    D                ;  CALCULATE SIGN OF RESULT
         LDA     ,S                ;  .
         EORA    1,S              ;  .
         PULS    D                ;  .
         PSHS    CC               ;  .
;
         JSR     ABSAB            ;  FORM PARTIAL RESULT
         MUL                      ;  .
;
         PULS    CC               ;  COMPLEMENT RESULT ?
         BPL     MLT800           ;  .
         COMA                     ;  .    TWO'S COMPLEMENT
         COMB                     ;  .    .
         ADDD    #$0001           ;  .    .
;
MLT800   RTS                      ;  RETURN TO CALLER
;
;
;
;
;==========================================================================JJH
;  CODE ADDED - REV. B CHANGES                                       ======JJH
;==========================================================================JJH
;                                                                    ======JJH
;  DRAW COMPACT 'DUFFY' FORMAT                                       ======JJH
;  ===========================                                       ======JJH
;                                                                    ======JJH
;        ENTRY VALUES                                                ======JJH
;        ------------                                                ======JJH
;           B  = 'DUFFY' SIZE                                        ======JJH
;           X  = POINTER TO 'DUFFY'                                  ======JJH
;           Y  = ABSOLUTE SCREEN POSITION (Y:X)                      ======JJH
;           DP = $D0                                                 ======JJH
;                                                                    ======JJH
         direct   $D0              ;                                  ======JJH
;        =====   ===              ;                                  ======JJH
;                                                                    ======JJH
DFSHRT   PSHS    B                ;  SAVE ENTRY VALUES               ======JJH
;                                                                    ======JJH
         TFR     Y,D              ;  POSITION 'DUFFY'                ======JJH
         JSR     POSITD           ;  .                               ======JJH
;                                                                    ======JJH
         LDA     ,X+               ;  DRAW 'DUFFY'                    ======JJH
         LDB     ,S               ;  .                               ======JJH
         JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
         PULS    B,PC             ;  RETURN TO CALLER                ======JJH
;==========================================================================JJH
;
;
;
;
;  RELEASE INTEGRATORS AND DRAW 'DUFFY' FORMAT
;  ===========================================
;
;        ENTRY VALUES
;        ------------
;           X  = POINTER TO 'DUFFY'
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
IDUFFY   LDA     #$FF             ;  RESET DASH PATTERN
         STA     DASH             ;  .
;
         LDA     ,X+               ;  FETCH VECTOR COUNT
;
;
;
;
;  RELEASE INTEGRATORS AND DRAW DASHED 'DUFFY' FORMAT
;  ==================================================
;
;        ENTRY VALUES
;        ------------
;           A  = NUMBER OF VECTORS - 1
;           X  = POINTER TO 'DUFFY'
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
IDASH    DECA                     ;  SET VECTOR COUNT
         STA     LIST             ;  .
;
         LDD     ,X++              ;  POSITION FOR 'DIFFY'
         JSR     POSITD           ;  .    FAKES 'DUFFY' FORMAT
;
         JMP     DASHDF           ;  DRAW DASHED 'DIFFY' STRING
;
;
;
;
;  DRAW VECTOR STRING WITH STANDARD VALUES
;  =======================================
;
;        ENTRY VALUES
;        ------------
;           U  = POINTER TO GRAPIC STRING
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
SPRCNT   LDX     #$0000           ;  POSITION TO Y:00, X:00
         LDA     #$7F             ;  SET STANDARD VECTOR SIZE
         BRA     SUPRDF           ;  .
;
;
;
;
;  DRAW FROM ROTATION TABLES
;  =========================
;
;        ENTRY VALUES
;        ------------
;           A  = VECTOR SIZE
;           X  = COMMON POSITION
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
SPRTBL   LDB     RGRD1            ;  SET ROTATION TABLES FOR 'DUFFY' FORMAT
         ORB     #$80             ;  .
         STB     RGRD1            ;  .
;
         LDB     RGRD2            ;  .
         ORB     #$80             ;  .
         STB     RGRD2            ;  .
;
         LDB     RGRD3            ;  .
         ORB     #$80             ;  .
         STB     RGRD3            ;  .
;
         LDU     #XRTBL           ;  .
;
;
;
;
;  DRAW FROM GRAPHIC STIRNG
;  ========================
;
;        ENTRY VALUES
;        ------------
;           A  = VECTOR SIZE
;           X  = COMMON POSITION
;           U  = POINTER TO GRAPHIC STRING
;           DP = $D0
;
         direct   $D0
;        =====   ===
;
SUPRDF   STA     ETMP1            ;  SAVE ENTRY VALUES
         STX     ETMP2            ;  .
;
SPRDF1   LDX     ,U++              ;  FETCH POINTER TO OBJECT
         BEQ     SPRDF4           ;  .    STRING TERMINATOR ?
;
         LDD     ETMP2            ;  POSITION NEXT OBJECT
         JSR     POSITD           ;  .
;
         LDA     ETMP1            ;  SET VECTOR SIZE
         STA     T1LOLC           ;  .
;
         LDA     ,X+               ;  FETCH VECTOR COUNT - 1
         BMI     SPRDF2           ;  .    'DIFFY' FORMAT ?
;
         JSR     LDIFFY           ;  DRAW 'DIFFY' FORMAT
         BRA     SPRDF1           ;  .    DO NEXT STRING ENTRY
;
SPRDF2   TFR     A,B              ;  'DUFFY' FORMAT ?
         ANDA    #$1F             ;  .
         BITB    #$20             ;  .    BIT 5 = DASHED 'DUFFY' FORMAT
         BNE     SPRDF5           ;  .    .
         BITB    #$40             ;  .    BIT 6 = ZDUFFY FORMAT
         BNE     SPRDF3           ;  .    .
;
         JSR     LDUFFY           ;  DRAW 'DUFFY' FORMAT
         BRA     SPRDF1           ;  .    DO NEXT STRING ENTRY
;
SPRDF3   BSR     ZDUFFY           ;  DRAW 'ZDUFFY' FORMAT
         BRA     SPRDF1           ;  .    DO NEXT STRING ENTRY
;
SPRDF5   BSR     IDASH            ;  DRAW DASHED 'DUFFY' FORMAT
         BRA     SPRDF1           ;  .
;
SPRDF4   LDA     #$FF             ;  RESET DASH PATTERN
         STA     DASH             ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;
;
;  DRAW 'DUFFY' FORMAT FOR SCENERY
;  ===============================
;
;        ENTRY VALUES
;        ------------
;           A  = NUMBER OF VECTORS - 1
;           X  = POINTER TO 'DUFFY' STYLE LIST
;
         direct   $D0
;        =====   ===
;
ZDUFFY   STA     LIST             ;  SET NUMBER OF VECTORS - 1
;
         LDD     ,X               ;  FETCH RELATIVE 'Y:X'
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         LEAX    2,X              ;  .    POSITION TO NEXT ENTRY
         NOP                      ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
;
         LDA     LFLAG            ;  SET 'X' AXIS VALUE
         CMPA    #$01             ;  .    COMPLEMENT 'X' AXIS ?
         BNE     ZDUF0            ;  .    .
         NEGB                     ;  .    .
ZDUF0    STB     DAC              ;  .    SAVE 'X' VALUE
;
         LDD     #0               ;  POSITION BEAM FOR START OF 'DUFFY' LIST
         BRA     ZDUF3            ;  .
;
;
ZDUF1    STA     LIST             ;  SET VECTOR COUNT
         LDD     ,X               ;  FETCH RELATIVE 'Y:X'
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         LEAX    2,X              ;  .    POSITION TO NEXT ENTRY
         NOP                      ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
;
         LDA     LFLAG            ;  SET 'X' AXIS VALUE
         CMPA    #$01             ;  .    COMPLEMENT 'X' AXIS ?
         BNE     ZDUF2            ;  .    .
         NEGB                     ;  .    .
ZDUF2    STB     DAC              ;  .    SAVE 'X' VALUE
;
         LDD     #$FF00           ;  TURN-ON CRT BEAM
ZDUF3    STA     SHIFT            ;  .
         STB     T1HOC            ;  START VECTOR RAMP
;
         LDD     #$0040           ;  WAIT FOR VECTOR COMPLETION
ZDUF4    BITB    IFLAG            ;  .
         BEQ     ZDUF4            ;  .
         NOP                      ;  .    &lt;&lt; TIMING &gt;&gt;
;
         STA     SHIFT            ;  TURN-OFF CRT BEAM
;
         LDA     LIST             ;  END OF LIST ?
         DECA                     ;  .
         BPL     ZDUF1            ;  .
         JMP     ZERGND           ;  .    ZERO INTEGRATORS AND SET ACTIVE GND
;
;
;         IF      L.SUBR = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
