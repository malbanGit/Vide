;
;
;         IF      L.WAR = OFF      ;-------------------------------------------
;         LIST    -L               ;--  WARIOR  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  WARRIOR GAME LOGIC
;  ==================
;
         direct   $C8
;        =====   ===
;
WARIOR   LDA     WARFLG           ;  WARRIOR ACTIVE ?
         LBEQ    WRDSP3           ;  .
;
         LDA     #$70             ;  SET SIZE AND INTENSITY
         SUBA    FOGLIM           ;  .    SET INTENSITY
         SUBA    WARINT           ;  .    .    SKIP WARRIOR ?
         CMPA    #$20             ;  .    .    .
         LBLE    WRDSP3           ;  .    .    .
         LDB     #SZ_WAR          ;  .    SET WARRIOR SIZE
         STD     DRWINT           ;  .    .    .
;
         LDA     WARINH           ;  WARRIOR MOTION INHIBITED ?
         LBNE    WARR11           ;  .
;
         LDA     POT0             ;  ANY JOYSTICK ACTIVITY ?
         ORA     POT1             ;  .
         LBEQ    WARR11           ;  .
;
         LDA     FRAM7            ;  HANDLE RIGHT / LEFT JOYSTICK ACTIVITY
         BNE     WARR3            ;  .    LIMIT ROTATION RATE
;
         LDA     POT0             ;  .    RIGHT / LEFT ACTIVITY ?
         BEQ     WARR3            ;  .    .
         BMI     WARR1            ;  .    .    LEFT ?
;
         DEC     LOKANG           ;  .    JOYSTICK IS RIGHT
         BRA     WARR2            ;  .    .
;
WARR1    INC     LOKANG           ;  .    JOYSTICK IS LEFT
;
WARR2    JSR     NEWANG           ;  NEW LOOK-ANGLE UPDATE
;
;
;
WARR3    LDA     FRAM3            ;  HANDLE UP / DOWN JOYSTICK ACTIVITY
         BNE     WARR7            ;  .    LIMIT MOTION RATE
;
         LDA     POT1             ;  .    JOYSTICK DOWN ?
         BEQ     WARR6            ;  .    .
         BMI     WARR4            ;  .    .
;
         LDD     WARYD            ;  .    JOYSTICK IS UP - MOVE FORWARD
         ADDD    MAPY             ;  .    .    MOVE ALONG 'Y' AXIS
         STD     TEMP1            ;  .    .    .
         BITA    #$C0             ;  .    .    .    CHECK FOR MOTION OFF MAP
         BNE     WARR7            ;  .    .    .    .
;
         LDD     WARXD            ;  .    .    MOVE ALONG 'X' AXIS
         ADDD    MAPX             ;  .    .    .
         STD     TEMP3            ;  .    .    .
         BITA    #$C0             ;  .    .    .    CHECK FOR MOTION OFF MAP
         BNE     WARR7            ;  .    .    .    .
;
         LDX     #PEDSGN          ;  .    .    INCREMENT PEDOMETER ASCII STRING
         LDA     PEDZRO           ;  .    .    .
         JSR     ASCINC           ;  .    .    .
         STA     PEDZRO           ;  .    .    .
         BRA     WARR5            ;  .    .    .
;
;
;
WARR4    LDD     WARYD            ;  .    JOYSTICK IS DOWN - MOVE BACKWARD
         COMA                     ;  .    .    MOVE ALONG 'Y' AXIS
         COMB                     ;  .    .    .    TWO'S COMPLEMENT
         ADDD    #$0001           ;  .    .    .    .
         ADDD    MAPY             ;  .    .    .
         STD     TEMP1            ;  .    .    .
         BITA    #$C0             ;  .    .    .    CHECK FOR MOTION OFF MAP
         BNE     WARR7            ;  .    .    .    .
; 
         LDD     WARXD            ;  .    .    MOVE ALONG 'X' AXIS
         COMA                     ;  .    .    .    TWO'S COMPLEMENT
         COMB                     ;  .    .    .    .
         ADDD    #$0001           ;  .    .    .    .
         ADDD    MAPX             ;  .    .    .
         STD     TEMP3            ;  .    .    .
         BITA    #$C0             ;  .    .    .    CHECK FOR MOTION OFF MAP
         BNE     WARR7            ;  .    .    .    .
;
         LDX     #PEDSGN          ;  .    .    DECREMENT PEDOMETER ASCII STRING
         LDA     PEDZRO           ;  .    .    .
         JSR     ASCDEC           ;  .    .    .
         STA     PEDZRO           ;  .    .    .
;
;
WARR5    LDD     TEMP1            ;  .    UPDATE NEW WARRIOR POSITION
         STD     MAPY             ;  .    .    'Y' AXIS
         LDD     TEMP3            ;  .    .    'X' AXIS
         STD     MAPX             ;  .    .    .
;
         CMPA    LASTX            ;  .    .    NEW GRID SCAN NEEDED ?
         BNE     WARR6            ;  .    .    .    DID MAJOR 'X' AXIS CHANGE ?
         LDB     MAPY             ;  .    .    .    DID MAJOR 'Y' AXIS CHANGE ?
         CMPB    LASTY            ;  .    .    .    .
         BEQ     WARR7            ;  .    .    .    .
;
WARR6    LDB     MAPY             ;  .    UPDATE OBJECT TABLE GRID SCAN
         STB     LASTY            ;  .    .    UPDATE LAST MAJOR NODE
         LDA     MAPX             ;  .    .    .
         STA     LASTX            ;  .    .    .
         JSR     GRDSCN           ;  .    .    SCAN GRID
         JSR     FOGSCN           ;  .    .    SEARCH FOR FOG OR PLAGUE
         BRA     WARR8            ;  .    .
;
;
WARR7    JSR     PROJCT           ;  UPDATE OBJECT TABLE PROJECTIONS
;
WARR8    LDA     WARWLK           ;  DID WARRIORS JUST START MOVING ?
         BNE     WARR9            ;  .
;
         JSR     RANDOM           ;  .    IF SO, THEN SET WARRIOR FRAME BIASES
         ANDA    #$03             ;  .    .
         BNE     WARR9            ;  .    .
         ORA     #$01             ;  .    .
         STA     WARFRM           ;  .    .
;
;
WARR9    LDA     FRAM3            ;  INCREMENT WARRIOR FRAME BIASES
         BNE     WARR10           ;  .    LIMIT ANIMATION RATE
;
         INC     WARFRM           ;  .    INCREMENT FRAME BIAS
         LDA     #$04             ;  .    SET STEP SOUND FLAG
         STA     STEPS            ;  .    .
;
WARR10   LDA     #$01             ;  SET WARRIOR WALKING FLAG
         STA     WARWLK           ;  .
         BRA     WARDSP           ;  .
;
;
WARR11   LDA     #$00             ;  NO JOYSTICK ACTIVITY THIS FRAME
         STA     WARWLK           ;  .    RESET WARRIOR ANIMATION FLAG
;
         CLR     WARFRM           ;  .    RESET ANIMATION FRAMES BIAS
;
;
WARDSP   LDA     WARFLG           ;  DISPLAY ACTIVE WARRIORS
         BEQ     WRDSP3           ;  .    IS WARRIOR DEAD ?
;
WRDSP1   LDA     WARFRM           ;  .    FETCH DRAWING FLAG
         LDX     #WKDRW           ;  .    .
         LDB     A,X              ;  .    .
         STB     RFLAG            ;  .    .
         ASLA                     ;  .    .
         LDX     #WLKNG2          ;  .    FETCH ANIMATION FOR LEFT SIDE
         LDX     A,X              ;  .    .
         STX     DRWLS2           ;  .    .
         LDX     #WLKNG1          ;  .    FETCH ANIMATION FOR RIGHT SIDE
         LDX     A,X              ;  .    .
         STX     DRWLS1           ;  .    .
         BNE     WRDSP2           ;  .    .    .    IF ZERO, RESTART ANIMATION
;
         LDA     #$01             ;  .    .    RESET ANIMATION SEQUENCE
         STA     WARFRM           ;  .    .    .
         BRA     WRDSP1           ;  .    .    .
;
WRDSP2   LDB     WARDSH           ;  .    SET WARRIOR DASHING
         STB     DASH             ;  .    .
;
         LDD     #$0000           ;  .    DRAW USING 'DRWLST1/2'
         LDY     #WARYW           ;  .    FETCH WARRIOR POSITION
         JSR     XDIFFY           ;  .    DRAW WARRIOR
;
WRDSP3   RTS                      ;  RETURN TO CALLER
;
;         IF      L.WAR = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
