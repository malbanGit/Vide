;         IF      L.FGHT = OFF     ;-------------------------------------------
;         LIST    -L               ;--  FIGHT  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  HANDLE FIGHTING WARRIOR LOGIC
;  =============================
;
         direct   $00
;        =====   ===
;
FIGHT    PSHS    DP               ;  SAVE ENTRY VALUES
;
         LDA     WARFLG           ;  HAS WARRIOR BEEN KILLED ?
         LBEQ    CHAMBR           ;  .
;
         LDA     #$C8             ;  SET 'DP' = RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         CLR     TEMP1            ;  CLEAR MOTION FLAG
         CLR     RFLAG            ;  CLEAR DRAW REVERSE FLAG
;
         LDA     WARTHR           ;  IS WARRIOR ALREADY THROWING ?
         BNE     THWDRW           ;  .
;
         LDA     WARINH           ;  IS WARRIOR ACTION INHIBITED ?
         LBNE    SHFL4            ;  .
;
;
         LDA     TSTRT            ;  THROW FLAMOID STRAIGHT ?
         BEQ     THRW1            ;  .
         LDA     #$00             ;  .    SET FLAMOID ANGLE
         BRA     THRW3            ;  .    .
;
THRW1    LDA     TRGHT            ;  THROW FLAMOID RIGHT ?
         BEQ     THRW2            ;  .
         LDA     #$3D             ;  .    SET FLAMOID ANGLE
         BRA     THRW3            ;  .    .
;
THRW2    LDA     TLEFT            ;  THROW FLAMOID LEFT ?
         BEQ     SHUFLE           ;  .
         LDA     #$03             ;  .    SET FLAMOID ANGLE
;
THRW3    INC     WARTHR           ;  SET-UP FLAMOID TABLE ENTRY
         CLR     WARFRM           ;  .    CLEAR FRAME COUNTER
         STA     THRANG           ;  .    SAVE FLAMOID ANGLE
;
;
THWDRW   LDA     FRAM1            ;  DISPLAY THROWING WARRIOR
         BNE     THWDR1           ;  .    LIMIT ANIMATION RATE
;
         LDX     #WTHRW           ;  .    INCREMENT FRAME BIAS
         INC     WARFRM           ;  .    .    RELEASE FLAMOID ?
         LDA     WARFRM           ;  .    .    .
         LDA     A,X              ;  .    .    .
         BEQ     THWDR1           ;  .    .    .
;
         LDA     WARYW            ;  .    RELEASE FLAMOID
         CLRB                     ;  .    .    SET 'Y' AXIS STARTING POSITION
         TFR     D,Y              ;  .    .    .
         LDA     WARXW            ;  .    .    SET 'X' AXIS STARTING POSITION
         ADDA    #$02             ;  .    .    .
         CLRB                     ;  .    .    .
         TFR     D,X              ;  .    .    .
         LDB     #$F8             ;  .    .    SET 'Z' AXIS
         LDA     THRANG           ;  .    .    SET THROW ANGLE
         JSR     SETFLM           ;  .    .
         LDA     <<FLMFLG,U         ;  .    .    FLAG THAT THIS IS WARRIOR FLAME
         ORA     #$40             ;  .    .    .
         STA     <<FLMFLG,U         ;  .    .    .
;
THWDR1   JSR     FPROJ            ;  .    PROJECT WARRIOR INTO 3-D
;
         LDX     #WWAR12          ;  .    DISPLAY THROWING WARRIOR
         STX     DRWLS2           ;  .    .    FETCH LEFT SIDE ANIMATION
         LDA     WARFRM           ;  .    .    FETCH RIGHT SIDE ANIMATION
         LSLA                     ;  .    .    .
         LDX     #THROW1          ;  .    .    .
         LDX     A,X              ;  .    .    .
         STX     DRWLS1           ;  .    .    .
         BNE     THDRW2           ;  .    .    .    IF ZERO, RESTART ANIMATION
;
         CLR     WARTHR           ;  .    .    RESET ANIMATION
         CLR     WARFRM           ;  .    .    .
         BRA     SHFL6            ;  .    .    .
;
THDRW2   LDB     #$7F             ;  .    .    FETCH SIZE
         SUBB    DRWSCZ           ;  .    .    .
         SUBB    #$10             ;  .    .    .
         LDA     #$70             ;  .    .    SET INTENSITY
         STD     DRWINT           ;  .    .    .
;
         LDD     #$0000           ;  .    .    DRAW USING 'DRWLS1/2'
         LDY     #DRWSCY          ;  .    .    FETCH ABSOLUTE POSITION
         JSR     CDIFFY           ;  .    .    DRAW WARRIOR
;
         JMP     CHAMBR           ;  .    DRAW BOX CHAMBER
;
;
;
         direct   $C8
;        =====   ===
;
SHUFLE   LDA     POT0             ;  HANDLE RIGHT / LEFT JOYSTICK ACTIVITY
         BEQ     SHFL4            ;  .
         BMI     SHFL1            ;  .
;
         LDD     WARXW            ;  .    JOYSTICK IS RIGHT
         CMPA    #$0C             ;  .    .    CHECK FOR RIGHT LIMIT
         BGE     SHFL3            ;  .    .    .
         ADDD    #SHFDSP          ;  .    .
         STD     WARXW            ;  .    .
         BRA     SHFL2            ;  .    .
;
SHFL1    LDD     WARXW            ;  .    JOYSTICK IS LEFT
         CMPA    #$F4             ;  .    .    CHECK FOR LEFT LIMIT
         BLE     SHFL3            ;  .    .    .
         SUBD    #SHFDSP          ;  .    .
         STD     WARXW            ;  .    .
;
SHFL2    INC     TEMP1            ;  .    SET WARRIOR MOTION FLAG
;
;
SHFL3    LDA     TEMP1            ;  ANIMATE WARRIOR SHUFFLE
         BEQ     SHFL4            ;  .    DID WARRIOR MOVE THIS FRAME ?
;
         LDA     FRAM3            ;  .    LIMIT ANIMATION RATE
         BNE     SHFL5            ;  .    .
;
         INC     WARFRM           ;  .    INCREMENT FRAME BIAS
         BRA     SHFL5            ;  .    .
;
SHFL4    CLR     WARFRM           ;  .    RESET FRAME BIAS (NO SHUFFLE)
;
;
SHFL5    JSR     FPROJ            ;  .    PROJECT WARRIOR INTO 3-D
;
;
SHFL6    LDA     WARFRM           ;  .    DISPLAY SHUFFLING WARRIOR
         LDX     #FWDRW           ;  .    .    SET DRAWING FLAG
         LDB     A,X              ;  .    .    .
         STB     RFLAG            ;  .    .    .
         LSLA                     ;  .    .    FETCH LEFT SIDE ANIMATION
         LDX     #FWAR2           ;  .    .    .
         LDX     A,X              ;  .    .    .
         STX     DRWLS2           ;  .    .    .
         LDX     #FWAR1           ;  .    .    FETCH RIGHT SIDE ANIMATION
         LDX     A,X              ;  .    .    .
         STX     DRWLS1           ;  .    .    .
         BNE     SHFL7            ;  .    .    .    IF ZERO, RESTART ANIMATION
;
         CLR     WARFRM           ;  .    .    RESET ANIMATION
         BRA     SHFL6            ;  .    .    .
;
SHFL7    LDA     #$70             ;  .    .    SET INTENSITY
         SUBA    WARINT           ;  .    .    .    MODIFY WITH STAR-BURST
         CMPA    #$20             ;  .    .    .    .
         BLE     CHAMBR           ;  .    .    .    .
;
         LDB     #$7F             ;  .    .    FETCH SIZE
         SUBB    DRWSCZ           ;  .    .    .
         SUBB    #$10             ;  .    .    .
         STD     DRWINT           ;  .    .    .
;
         LDD     #$0000           ;  .    .    DRAW USING 'DRWLS1/2'
         LDY     #DRWSCY          ;  .    .    FETCH ABSOLUTE POSITION
         JSR     CDIFFY           ;  .    .    DRAW WARRIOR
;
;
;
CHAMBR   LDA     #$D0             ;  DRAW BOX CHAMBER
         TFR     A,DP             ;  .    SET 'DP' = I/O
         direct   $D0              ;  .    .
;
         LDD     #$0000           ;  .    SET POSITION
         STD     TEMP1            ;  .    .
;
         CLR     RFLAG            ;  .    DRAW INTERIOR WALLS
         LDD     #$50FF           ;  .    .    (LEFT SIDE)
         LDX     #WALLS           ;  .    .    .
         LDY     #TEMP1           ;  .    .    .
         JSR     SDIFFY           ;  .    .    .
;
         DEC     RFLAG            ;  .    .    (RIGHT SIDE)
         LDD     #$50FF           ;  .    .    .
         LDX     #WALLS           ;  .    .    .
         JSR     SDIFFY           ;  .    .    .
;
         PULS    DP,PC            ;  .    RETURN TO CALLER
;
;         IF      L.FGHT = OFF     ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
