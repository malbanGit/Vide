;
;
;         IF      L.COL = OFF      ;-------------------------------------------
;         LIST    -L               ;--  COLLIDE  ------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  *************************************************************
;  *************************************************************
;  ***                                                       ***
;  ***          C O L L I S I O N   H A N D L E R S          ***
;  ***                                                       ***
;  *************************************************************
;  *************************************************************
;
;
;  HANDLE BULLET VS. GUARDIAN COLLISIONS
;  =====================================
;
         direct   $C8
;        =====   ===
;
CBULT    LDU     #BLTTBL          ;  FIND BULLET TO COMPARE AGAINST
         LDA     #BULETS + 4      ;  .
         STA     TEMP1            ;  .
;
CBLT1    LDA     BLTFLG,U         ;  .    BULLET ACTIVE ?
         BNE     CBLT3            ;  .    .
;
CBLT2    LEAU    BLTLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .
         BNE     CBLT1            ;  .    .
         RTS                      ;  .    END OF TABLE - RETURN TO CALLER
;
;
CBLT3    LDA     ABORT            ;  COMPARE BULLET VS. BLASTER
         BNE     CBLT5            ;  .    SKIP BLASTER TEST
         LDA     BLTANG,U         ;  .    FRESH BULLET FROM BLASTER ?
         BEQ     CBLT5            ;  .    .
;
         LDY     BLSTYX           ;  .    SET BLASTER POSITION
         LDD     BLSTBX           ;  .    SET BLASTER COLLISION BOX
         LDX     BLTYX,U          ;  .    SET BULLET POSITION
         JSR     BXTEST           ;  .    DO BOX TEST
         BCC     CBLT5            ;  .    .
;
         LDA     #$80             ;  .    COLLISION DETECTED
         STA     EXPLO2           ;  .    .    SET BLASTER EXPLOSION SOUND
         INC     ABORT            ;  .    .    FLAG GAME ABORT
;
CBLT4    JSR     CLRBLT           ;  .    .    RESET BULLET ENTRY
         BRA     CBLT2            ;  .    .    .    TRY NEXT BULLET ENTRY
;
;
CBLT5    LDA     TEMP1            ;  WAR-BIRD BULLETS ?
         CMPA    #BULETS          ;  .
         BLE     CBLT2            ;  .
;
;
         LDY     #GRDTBL          ;  FIND GUARDIAN TO COMPARE AGAINST
         LDA     #GUARDS          ;  .
         STA     TEMP2            ;  .
;
CBLT6    LDA     GRDFLG,Y         ;  .    GUARDIAN ACTIVE ?
         BNE     CBLT8            ;  .    .
;
CBLT7    LEAY    GRDLEN,Y         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .    END-OF-TABLE ?
         BNE     CBLT6            ;  .    .    .
         BRA     CBLT2            ;  .    .    .    .
;
CBLT8    PSHS    Y                ;  COMPARE BULLET VS. GUARDIAN
         LDX     BLTYX,U          ;  .    SET BULLET POSITION
         LDY     GRDYX,Y          ;  .    SET GUARDIAN POSITION
         LDD     #$0404           ;  .    SET COLLISION BOX
         JSR     BXTEST           ;  .    DO BOX TEST
         PULS    Y                ;  .    .
         BCC     CBLT7            ;  .    .
;
         LDA     GRDFLG,Y         ;  .    COLLISION DETECTED
         BMI     CBLT4            ;  .    .    GUARDIAN ALREADY DYING ?
;
         LDA     #$80             ;  .    .    SET GUARDIAN OUCH SOUND
         STA     OUCH             ;  .    .    .
;
         LDA     GRDERG,Y         ;  .    .    ADJUST ENERGY LEVELS
         SUBA    BLTERG,U         ;  .    .    .
         STA     GRDERG,Y         ;  .    .    .
         CMPA    #$02             ;  .    .    .
         BGT     CBLT9            ;  .    .    .
;
         LDA     GRDFLG,Y         ;  .    .    SET GUARDIAN TO DYING
         ORA     #$80             ;  .    .    .
         STA     GRDFLG,Y         ;  .    .    .
;
         LDA     #$50             ;  .    .    SET DYING COUNTER
         STA     GRDERG,Y         ;  .    .    .
;
         LDD     #$0000           ;  .    .    SET ROTATIONAL COUNTERS
         STD     GRDYD,Y          ;  .    .    .
         STD     GRDXD,Y          ;  .    .    .
;
         CLR     OUCH             ;  .    .    RESET GUARDIAN OUCH SOUND
         LDA     #$80             ;  .    .    SET EXPLOSION SOUND
         STA     EXPLO1           ;  .    .    .
;
         LDD     #$0010           ;  .    .    ADD SCORE VALUE
         JSR     SCORED           ;  .    .    .
         JMP     CBLT4            ;  .    .    RESET BULLET ENTRY
;
CBLT9    PSHS    U                ;  .    .    GUARDIAN ALIVE, ALLOW TO FALL
         TFR     Y,U              ;  .    .    .
         JSR     GRFALL           ;  .    .    .
         PULS    U                ;  .    .    .
         BRA     CBLT4            ;  .    .    .
;
;
;
;
;  HANDLE BLASTER VS. GUARDIAN COLLISIONS
;  ======================================
;
         direct   $C8
;        =====   ===
;
CGUARD   LDA     ABORT            ;  HAS GAME BEEN ABORTED ?
         BNE     CGRD3            ;  .
;
         LDU     #GRDTBL          ;  FIND GUARDIAN TO COMPARE AGAINST
         LDA     #GUARDS          ;  .
         STA     TEMP2            ;  .
;
CGRD1    LDA     GRDFLG,U         ;  .    GUARDIAN ACTIVE ?
         BNE     CGRD4            ;  .    .
;
CGRD2    LEAU    GRDLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .    END-OF-TABLE ?
         BNE     CGRD1            ;  .    .    .
CGRD3    RTS                      ;  .    .
;
CGRD4    LDY     BLSTYX           ;  COMPARE BLASTER VS. GUARDIAN
         LDX     GRDYX,U          ;  .    SET GUARDIAN POSITION
         LDD     BLSTBX           ;  .    SET COLLISION BOX
         JSR     BXTEST           ;  .    DO BOX TEST
         BCC     CGRD2            ;  .    .
;
         LDA     #$80             ;  .    COLLISION DETECTED
         STA     EXPLO2           ;  .    .    SET SOUND FLAG
         INC     ABORT            ;  .    .    FLAG GAME ABORT
;
         LDA     GRDFLG,U         ;  KILL GUARDIAN 
         ORA     #$80             ;  .    SET GUARDIAN TO DYING
         STA     GRDFLG,U         ;  .    .
;
         LDA     #$50             ;  .    SET DYING COUNTER
         STA     GRDERG,U         ;  .    .
;
         LDD     #$0000           ;  .    SET ROTATIONAL COUNTERS
         STD     GRDYD,U          ;  .    .
         STD     GRDXD,U          ;  .    .
;
         RTS                      ;  .    .    RETURN TO CALLER
;
;
;
;
;  HANDLE BULLET VS. SPIKER COLLISIONS
;  ===================================
;
         direct   $C8
;        =====   ===
;
CSPIKE   LDA     CSPK             ;  ANY SPIKERS ACTIVE ?
         BEQ     CSPK20           ;  .
;
         LDY     #SPKTBL          ;  FIND SPIKER TO COMPARE AGAINST
         LDA     #GUARDS + 4      ;  .
         STA     TEMP1            ;  .
;
CSPK1    LDA     SPKFLG,Y         ;  .    SPIKER ACTIVE ?
         BEQ     CSPK2            ;  .    .
         BPL     CSPK3            ;  .    .    HAS SPIKER BEEN RELEASED ?
;
CSPK2    LEAY    SPKLEN,Y         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .
         BNE     CSPK1            ;  .    .
CSPK20   RTS                      ;  .    END OF TABLE - RETURN TO CALLER
;
;
CSPK3    LDA     ABORT            ;  HANDLE SPIKER VS. BLASTER COLLISIONS
         BNE     CSPK38           ;  .    HAS GAME BEEN ABORTED ?
;
         PSHS    Y                ;  .    SET SPIKER POSITION
         LDX     SPKYX,Y          ;  .    .
         LDY     BLSTYX           ;  .    SET BLASTER POSITION
         LDD     BLSTBX           ;  .    SET BLASTER COLLISION BOX
         JSR     BXTEST           ;  .    DO BOX TEST
         PULS    Y                ;  .    .
         BCC     CSPK38           ;  .    .
;
         LDA     #$80             ;  .    COLLISION DETECTED
         STA     EXPLO2           ;  .    .    SET SOUND FLAG
         INC     ABORT            ;  .    .    FLAG GAME ABORT
;
         CLR     SPKFLG,Y         ;  .    .    RESET SPIKER
         DEC     CSPK             ;  .    .    DECREMENT ACTIVE SPIKER COUNTER
         BRA     CSPK2            ;  .    .    TRY NEXT SPIKER ENTRY
;
;
CSPK38   LDU     #BLTTBL          ;  FIND BULLET TO COMPARE AGAINST
         LDA     #BULETS          ;  .
         STA     TEMP2            ;  .
;
CSPK4    LDA     BLTFLG,U         ;  .    BULLET ACTIVE ?
         BNE     CSPK6            ;  .    .
;
CSPK5    LEAU    BLTLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .    END-OF-TABLE ?
         BNE     CSPK4            ;  .    .    .
         BRA     CSPK2            ;  .    .    .    TRY NEXT BULLET
;
CSPK6    PSHS    Y                ;  COMPARE BULLET VS. SPIKER
         LDX     BLTYX,U          ;  .    SET BULLET POSITION
         LDD     #$0404           ;  .    SET COLLISION BOX
         LDY     SPKYX,Y          ;  .    SET SPIKER POSITION
         JSR     BXTEST           ;  .    DO BOX TEST
         PULS    Y                ;  .    .
         BCC     CSPK5            ;  .    .
;
         LDA     #$80             ;  .    COLLISION DETECTED
         STA     EXPLO1           ;  .    .
;
         LDA     SPKFLG,Y         ;  .    .    SPIKER ALREADY SPLIT ?
         ANDA    #$40             ;  .    .    .
         BNE     CSPK91           ;  .    .    .
;
         LDA     GAMCMD           ;  .    .    SPLIT SPIKER ?
         ANDA    #$40             ;  .    .    .
         BNE     CSPK70           ;  .    .    .
         BRA     CSPK62           ;  .    .    .
;
CSPK91   LDD     #$0050           ;  .    .    SPLIT SPIKER BONUS
         JSR     SCORED           ;  .    .    .    ADD SCORE VALUE
;
CSPK62   CLR     SPKFLG,Y         ;  .    .    RESET SPIKER
         DEC     CSPK             ;  .    .    DECREMENT ACTIVE SPIKER COUNT
         BRA     CSPK79           ;  .    .    .
;
CSPK70   LDX     #DBLSPK          ;  .    SPLIT SPIKER
         LDB     #4               ;  .    .
;
CSPK71   LDA     SPKFLG,X         ;  .    .    FIND ROOM FOR SPIKER SPLIT
         BEQ     CSPK72           ;  .    .    .
;
         LEAX    SPKLEN,X         ;  .    .    BUMP TO NEXT ENTRY
         DECB                     ;  .    .    .
         BNE     CSPK71           ;  .    .    .
         BRA     CSPK62           ;  .    .    .    NO ROOM - RESET SPIKER
;
CSPK72   LDA     #$41             ;  .    .    SPIKER SPLIT ROOM FOUND
         STA     SPKFLG,Y         ;  .    .    .    SET SPIKER FLAG FOR SPLIT
         STA     SPKFLG,X         ;  .    .    .    .
;
         LDD     SPKYW,Y          ;  .    .    .    SET SPIKER POSITION
         STD     SPKYW,X          ;  .    .    .    .    'Y' POSITION
         LDD     SPKXW,Y          ;  .    .    .    .    'X' POSITION
         STD     SPKXW,X          ;  .    .    .    .    .
         LDD     SPKYX,Y          ;  .    .    .    .    ABSOLUTE 'YX'
         STD     SPKYX,X          ;  .    .    .    .    .
;
         INC     CSPK             ;  .    .    .    BUMP ACTIVE SPIKER COUNTER
;
         LDA     SPKANG,Y         ;  .    .    .    SET SPIKER ANGLES
         JSR     LRCONE           ;  .    .    .    .
         STA     SPKANG,Y         ;  .    .    .    .
         JSR     LRCONE           ;  .    .    .    .
         STA     SPKANG,X         ;  .    .    .    .
;
         PSHS    Y,U              ;  .    .    .    FORM SPLIT SPIKER
         TFR     X,U              ;  .    .    .    .
         LDA     #SPKSPD          ;  .    .    .    .    SET SPIKER SPEED
         JSR     CALDSP           ;  .    .    .    .    CALC DISPLACEMENTS
;
         TFR     Y,U              ;  .    .    .    MODIFY EXISTING SPIKER
         LDA     #SPKSPD          ;  .    .    .    .    SET SPIKER SPEED
         JSR     CALDSP           ;  .    .    .    .    CALC DISPLACEMENTS
         PULS    Y,U              ;  .    .    .    .    .
;
CSPK79   LDD     #$0050           ;  .    .    ADD SCORE VALUE
         JSR     SCORED           ;  .    .    .
;
         JSR     CLRBLT           ;  .    .    RESET BULLET ENTRY
         JMP     CSPK2            ;  .    .    .    TRY NEXT SPIKER
;
;
;
;
;  HANDLE BULLET VS. WAR-BIRD COLLISIONS
;  =====================================
;
         direct   $C8
;        =====   ===
;
CBIRD    LDY     #BRDTBL          ;  FIND WAR-BIRD TO COMPARE AGAINST
         LDA     #BIRDS           ;  .
         STA     TEMP1            ;  .
;
CBRD1    LDA     BRDFLG,Y         ;  .    WAR-BIRD ACTIVE ?
         BNE     CBRD3            ;  .    .
;
CBRD2    LEAY    BRDLEN,Y         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    .
         BNE     CBRD1            ;  .    .
         RTS                      ;  .    END OF TABLE - RETURN TO CALLER
;
;
CBRD3    ANDA    #$40             ;  IS WAR-BIRD OVER ROADWAY ?
         BEQ     CBRD2            ;  .
;
;
         LDA     ABORT            ;  HANDLE WAR-BIRD VS. BLASTER COLLISIONS
         BNE     CBRD38           ;  .    HAS GAME BEEN ABORTED ?
;
         LDA     BRDFLG,Y         ;  .    SKIP IF WAR-BIRD IS IN SHIELD MODE
         BMI     CBRD38           ;  .    .
;
         PSHS    Y                ;  .    FETCH WAR-BIRD POSITION
         LDX     BRDYX,Y          ;  .    .
         LDY     BLSTYX           ;  .    FETCH BLASTER POSITION
         LDD     BLSTBX           ;  .    FETCH COLLISION BOX
         JSR     BXTEST           ;  .    PERFORM BOX TEST
         PULS    Y                ;  .    .
         BCC     CBRD38           ;  .    .
;
         LDA     #$80             ;  .    COLLISION DETECTED
         STA     EXPLO2           ;  .    .    SET SOUND FLAG
         INC     ABORT            ;  .    .    FLAG GAME ABORT
;
;
CBRD38   LDU     #BLTTBL          ;  FIND BULLET TO COMPARE AGAINST
         LDA     #BULETS          ;  .
         STA     TEMP2            ;  .
;
CBRD4    LDA     BLTFLG,U         ;  .    BULLET ACTIVE ?
         BNE     CBRD6            ;  .    .
;
CBRD5    LEAU    BLTLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .    END-OF-TABLE ?
         BNE     CBRD4            ;  .    .    .
         BRA     CBRD2            ;  .    .    .    TRY NEXT BULLET
;
CBRD6    PSHS    Y                ;  COMPARE BULLET VS. WAR-BIRD
         LDX     BLTYX,U          ;  .    SET BULLET POSITION
         LDD     BRDBOX,Y         ;  .    SET COLLISION BOX
         LDY     BRDYX,Y          ;  .    SET SPIKER POSITION
         JSR     BXTEST           ;  .    DO BOX TEST
         PULS    Y                ;  .    .
         BCC     CBRD5            ;  .    .
;
;
         LDA     BRDFLG,Y         ;  COLLISION DETECTED
         BMI     CBRD61           ;  .    WAR-BIRD OR SHIELD DETECTED ?
;
         LDA     #$C0             ;  .    WAR-BIRD COLLISION DETECTED
         STA     BRDFLG,Y         ;  .    .    SET WAR-BIRD SHIELD MODE
         DEC     CBRD             ;  .    .    DECREMENT WAR-BIRD COUNTER
;
         LDA     #$80             ;  .    .    SET EXPLOSION FLAG
         STA     EXPLO1           ;  .    .    .
;
         LDA     #$7F             ;  .    .    SET SHIELD DECAY TIME
         STA     BRDTMR,Y         ;  .    .    .
;
         LDD     #$0100           ;  .    .    ADD SCORE VALUE
         JSR     SCORED           ;  .    .    .
;
         JSR     BRDINS           ;  .    .    TRY TO INSERT NEW BIRD
;
CBRD61   JSR     CLRBLT           ;  .    .    RESET BULLET ENTRY
         BRA     CBRD2            ;  .    .    .    TRY WAR-BIRD ENTRY
;
;
;
;
;  LINE VS. LINE COLLISION DETECTION
;  ==================================
;
;        ENTRY VALUES
;        ------------
;           U  = POINTER TO OBJECT TABLE ENTRY
;                   + 1/2  = 'Y' AXIS DISPLACEMENT
;                   + 3/4  = 'X' AXIS DISPLACEMENT
;                   + 11   = OBJECT ANGLE OF MOTION
;
;           LASTY  = LAST 'Y'
;           NEXTY  = NEXT 'Y'
;           CRNTX  = LAST 'X'
;           NEXTX  = NEXT 'X'
;
;        RETURN VALUES
;        -------------
;           B  = BOUNCE ANGLE
;           V  = 1 - OBJECT OUT-OF-BOUNDS (CLEAR OBJECT)
;           C  = 1 - WALL COLLISION OCCURED (BOUNCE)
;
         direct   $C8
;        =====   ===
;
COLIDE   PSHS    U                ;  SAVE ENTRY VALUES
;
         LDA     11,U             ;  FETCH OBJECT ANGLE
         STA     TEMP9            ;  .
;
         LDD     1,U              ;  SAVE DELTA 'Y'
         ASLB                     ;  .
         ROLA                     ;  .
         STD     DELTAY           ;  .
;
         LDD     3,U              ;  SAVE DELTA 'X'
         ASLB                     ;  .
         ROLA                     ;  .
         STD     DELTAX           ;  .
;
         LDA     #$08             ;  CALCULATE QUICK LOOK-UP VECTOR
         LDB     LASTY            ;  .    'Y' POSITION
         ADDB    #$80             ;  .    .    MAKE POSITIVE
         MUL                      ;  .    .    USE UPPER 3 BITS OF 'Y'
;
         LDB     LFLAG            ;  .    'X' POSITION
         CMPB    #$01             ;  .    .    FLIP 'X' FOR MIDDLE ROADWAY ?
         BNE     CALB00           ;  .    .    .
;
         LDB     LASTX            ;  .    .    .    MIDDLE ROADWAY - FLIP 'X'
         NEGB                     ;  .    .    .    .
         BRA     CALB01           ;  .    .    .    .
;
CALB00   LDB     LASTX            ;  .    .    .    NOT MIDDLE ROADWAY
CALB01   ADDB    #$80             ;  .    .    MAKE POSITIVE
         ASLB                     ;  .    .    USE UPPER 3 BITS OF 'X'
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
         ASLB                     ;  .    .    .
         ROLA                     ;  .    .    .
;
         LDX     #TCOL            ;  FETCH QUICK LOOK-UP BOUNCE STATUS
         LSLA                     ;  .
         LDD     A,X              ;  .    FETCH BOTH WALLS 
         LBEQ    MISS1            ;  .    .    NO BOUNCE POSSIBLE ?
         LBMI    OUTBND           ;  .    .    IS BULLET OUT-BOUND (ILLEGAL) ?
         STA     TEMP2            ;  .    .
         TSTB                     ;  .    SKIP SECOND WALL ?
         BNE     CALB03           ;  .    .
;
CALB02   LDB     TEMP2            ;  .    PERFORM TEST ON FIRST WALL ONLY
         CLR     TEMP2            ;  .    .
;
CALB03   LDX     #WALLS           ;  FETCH CURRENT WALL POINTER
         LSLB                     ;  .
         STB     TEMP3            ;  .
         LDX     B,X              ;  .
;
         LDA     WALLYS,X         ;  FLIP 'X' AXIS FOR MIDDLE ROADWAY ?
         STA     CWALYS           ;  .
         LDA     WALLYE,X         ;  .
         STA     CWALYE           ;  .
;
         LDA     LFLAG            ;  .    MIDDLE ROADWAY ?
         CMPA    #$01             ;  .
         BNE     FLPB01           ;  .
;
         LDA     WALLXS,X         ;  .    MIDDLE ROADWAY - FLIP 'X'
         NEGA                     ;  .    .
         STA     CWALXS           ;  .    .
         LDA     WALLXE,X         ;  .    .
         NEGA                     ;  .    .
         STA     CWALXE           ;  .    .
;
         LDA     WALLA,X          ;  .    .    FLIP WALL ANGLE
         ADDA    #$20             ;  .    .    .
         ANDA    #$3F             ;  .    .    .
         STA     TEMP7            ;  .    .    .
         BRA     FLPB09           ;  .    .
;
FLPB01   LDA     WALLXS,X         ;  .    DON'T FLIP 'X' AXIS
         STA     CWALXS           ;  .    .
         LDA     WALLXE,X         ;  .    .
         STA     CWALXE           ;  .    .
         LDA     WALLA,X          ;  .    .    DON'T FLIP WALL ANGLE
         STA     TEMP7            ;  .    .    .
;
FLPB09   LDA     CWALXE           ;  END POINT OF LINE
         LDB     CWALYE           ;
         SUBA    CWALXS           ;  TRANSPOSE VECTOR TO THE ORIGIN
         SUBB    CWALYS           ;     .
         NEGA                     ;  NEGATE NEW Y VALUE.
         STD     ETMP1            ;  SAVE FOR FUTURE USE
;
         LDA     LASTY            ;  GET BALL VECTOR'S START POINT
         SUBA    CWALYS           ;  TRANSPOSE IT TO THE ORIGIN
         LDB     LASTX            ;
         SUBB    CWALXS           ;
         STD     DOTTMP           ;
;
         LDD     ETMP1            ;
         BSR     DOTPRD           ;
         STD     ETMP3            ;
;
         LDA     NEXTY            ; GET BALL VECTOR'S END POINT
         SUBA    CWALYS           ;   TRANSPOSE IT TO THE ORIGIN
         LDB     NEXTX            ;
         SUBB    CWALXS           ;
         STD     DOTTMP           ;
;
         LDD     ETMP1            ;
         BSR     DOTPRD           ;
         STD     ETMP5            ;
;
         LDA     ETMP3            ; CHECK FOR OPPOSING SIGNS                     
         EORA    ETMP5            ; IF  NEGATIVE RESULT, THEN BALL'S START AND END
         BPL     MISS             ;   POINTS ARE ON OPPOSITE SIDES OF THE LINE   
;
         LDA     DELTAX           ;
         LDB     DELTAY           ;
         NEGA                     ;  NEGATE NEW Y VALUE.
         STD     DOTTMP           ;
;
         LDA     CWALYS           ; Y:X OF LINE'S START POINT IN D
         LDB     CWALXS           ;
         SUBA    LASTY            ;     TRANSPOSE TO ORIGIN
         SUBB    LASTX            ;
         BSR     DOTPRD           ;
         STD     ETMP6            ;
;
         LDA     CWALYE           ; Y:X OF LINE'S END POINT IN D
         LDB     CWALXE           ;
         SUBA    LASTY            ;     TRANSPOSE TO ORIGIN
         SUBB    LASTX            ;
         BSR     DOTPRD           ;
;
         EORA    ETMP6            ; IF  NEGATIVE RESULT, THEN BALL'S START AND END
         BMI     HIT              ;   POINTS ARE ON OPPOSITE SIDES OF THE LINE   
;
;
MISS     LDA     TEMP2            ;  EXIT - NO COLLISION DETECTED
         LBNE    CALB02           ;  .    IS THERE ANOTHER WALL TO TEST FOR ?
;
MISS1    ANDCC   #$FC             ;  .    RESET 'C'
         PULS    U,PC             ;  .    RETURN TO CALLER
;
;
OUTBND   ORCC    #$02             ;  EXIT - OBJECT IS OUT-BOUND (SET 'V')
         ANDCC   #$FE             ;  .    RESET 'C' - COLLISION FLAG
         PULS    U,PC             ;  .    RETURN TO CALLER
;
;
HIT      LDB     TEMP7            ;  COLLISION DETECTED
         ADDB    TEMP9            ;  .    CALCULATE AN ANGLE OF INCIDENT
         ANDB    #$3F             ;  .    .    REDUCE TABLE LOOK-UP VALUE
         LSRB                     ;  .    .    .
         LSRB                     ;  .    .    .
         LDX     BNCTBL           ;  .    .    FETCH BOUNCE TABLE POINTER
         LDA     TEMP3            ;  .    .    .    FETCH WALL BOUNCE POINTER
         LDX     A,X              ;  .    .    .
         LDB     B,X              ;  .    .    .
         BMI     OUTBND           ;  .    .    .    ILLEGAL BOUNCE ANGLE ?
;
         STB     11,U             ;  .    SAVE BOUNCE ANGLE
         ORCC    #$01             ;  .    SET 'C' - COLLISION FLAG
         ANDCC   #$FD             ;  .    RESET 'V' - OUT-BOUND FLAG
         PULS    U,PC             ;  .    RETURN TO CALLER
;
;
;
;
;  CALCULATE DOT PRODUCT FOR TWO GIVEN VECTORS
;  ===========================================
;
;        ENTRY VALUES
;        ------------
;           A  = 'Y' COMPONENT OF NORMAL
;           B  = 'X' COMPONENT OF NORMAL
;           DP = $C8
;
;           DOTTMP + 0 = 16-BIT 'Y' COMPONENT OF VECTOR
;           DOTTMP + 1 = 16-BIT 'X' COMPONENT OF VECTOR
;
;        RETURN VALUES
;        -------------
;           D  = 16-BIT DOT PRODUCT OF VECTOR #1 AND VECTOR #2
;
         direct   $C8
;        =====   ===
;
DOTPRD   PSHS    B                ;  .
         LDB     DOTTMP           ;  .
         JSR     MULT8            ;  .
         PSHS    D                ;  .
         LDA     2,S              ;  .
         LDB     DOTTMP+1         ;  .
         JSR     MULT8            ;  .
         ADDD    ,S++              ;  .
         LEAS    1,S              ;  .
         RTS                      ;  .
;
;
;         IF      L.COL = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
