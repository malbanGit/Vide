;
;
;         IF      L.GRD = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GRDSCN  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SCAN MAP GRID FOR OBJECTS
;  =========================
;
         direct   $C8
;        =====   ===
;
GRDSCN   LDU     #SCNTBL          ;  RESET GRID SCAN TABLE
         LDB     #SCNCNT          ;  .
         STB     TEMP1            ;  .
         STB     TEMP2            ;  .
         LDD     #$0000           ;  .
;
GSCN1    STD     <<SCNADR,U         ;  .    RESET GRID OBJECT ADDRESS
         LEAU    SCNLEN,U         ;  .    BUMP TO NEXT ENTRY
         DEC     TEMP2            ;  .    .
         BNE     GSCN1            ;  .    .
;
;
         LDU     #SCNTBL          ;  SET-UP FOR MAP GRID SCAN
         CLR     SCNFND           ;  .
;
         LDY     #GRDANG          ;  .    FETCH SCAN SEQUENCE POINTER
         LDA     LOKANG           ;  .    .
         LSRA                     ;  .    .
         LSRA                     ;  .    .
         ANDA    #$1E             ;  .    .
         LDY     A,Y              ;  .    .
;
         LDA     MAPY             ;  .    CALCULATE MAP 'Y' STARTING POINT
         SUBA    #$06             ;  .    .
         STA     ETMP1            ;  .    .
;
         LDA     MAPX             ;  .    CALCULATE MAP 'X' SCAN STARTING POINT
         SUBA    #$06             ;  .    .
         STA     ETMP2            ;  .    .
;
GSCN2    JSR     MAPSCN           ;  SCAN MAP GRID FOR WINDOW PROJECTION
         BCS     PROJCT           ;  .    END OF GRID SCAN SEQUENCE ?
         BVS     GSCN2            ;  .    SKIP IF OFF-MAP
;
         STB     SCNDRW,U         ;  .    SAVE GRID OBJECT
;
         LDX     #OBJTYP          ;  .    .    SAVE DRAW ADDRESS FOR OBJECT
         LSLA                     ;  .    .    .
         LDD     A,X              ;  .    .    .
         STD     <<SCNADR,U         ;  .    .    .
;
         CLRB                     ;  .    .    SAVE ABSOLUTE GRID POSITION
         LDA     ETMP3            ;  .    .    .    ABSOLUTE GRID 'Y' POSITION
         STD     SCNGY,U          ;  .    .    .    .
         LDA     ETMP4            ;  .    .    .    ABSOLUTE GRID 'X' POSITION
         STD     SCNGX,U          ;  .    .    .    .
;
         CLR     SCNCMD,U         ;  .    .    RESET COMMAND / STATUS BYTE
         CLR     SCNTMR,U         ;  .    .    RESET ANIMATION TIMER
;
         INC     SCNFND           ;  .    BUMP TO NEXT GRID SCAN ENTRY
         LEAU    SCNLEN,U         ;  .    .
         DEC     TEMP1            ;  .    .
         BNE     GSCN2            ;  .    .    EXIT IF NO MORE ROOM IN TABLE
;
;
;
;
;  PROJECT GRID SCAN OBJECTS
;  =========================
;
         direct   $C8
;        =====   ===
;
PROJCT   LDU     #OBJTBL          ;  RESET OBJECT TABLE
         LDB     #OBJCNT          ;  .
PROJ1    CLR     <<OBJFLG,U         ;  .
         LEAU    OBJLEN,U         ;  .
         DECB                     ;  .
         BNE     PROJ1            ;  .
;
         LDD     #$0000           ;  RESET IN-FRONT OBJECT
         STD     CBXSCN           ;  .    SCAN-TABLE POINTER
         STA     CBXAMT           ;  .    .
         COMA                     ;  .    IN-FRONT OBJECT DISTANCE
         STA     CBXDST           ;  .    .
;
         LDA     #FRSTY           ;  SET FOREST 'Y' VALUE FOR 'PROJCT'
         STA     RYPOS            ;  .
;
;==========================================================================JJH
;        LDA     #$D8             ;  CODE DELETED - REV. A CHANGES   ======JJH
;        STA     PRJLIM           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         LDA     #$E0             ;  CODE ADDED - REV. A CHANGES     ======JJH
         STA     PRJLIM           ;  .    SET LOWER 'Y' FOR 'PRJCTN' ======JJH
;==========================================================================JJH
;
         LDD     DSINE            ;  FETCH SINE / COSINE FOR LOOK-ANGLE
         STD     WSINE            ;  .    FETCH SINE VALUE
         LDD     DCSINE           ;  .    FETCH COSINE VALUE
         STD     WCSINE           ;  .    .
;
         LDX     #SCNTBL          ;  SET-UP TO SCAN GRID TABLE
         LDA     SCNFND           ;  .
         BEQ     PROJ6            ;  .    SKIP IF NO OBJECTS
         STA     TEMP1            ;  .
;
PROJ2    LDD     <<SCNADR,X         ;  IS GRID SCAN TABLE ENTRY ACTIVE ?
         BEQ     PROJ5            ;  .
;
         LDD     MAPX             ;  CALCULATE RELATIVE 'X' POSITION
         SUBD    SCNGX,X          ;  .
         ASRA                     ;  .    DIVIDE RELATIVE POSITION
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         STB     RXPOS            ;  .    SAVE RELATIVE 'X'
;
         LDD     MAPY             ;  CALCULATE RELATIVE 'Z' POSITION
         SUBD    SCNGY,X          ;  .
         ASRA                     ;  .    DIVIDE RELATIVE POSITION
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         ASRA                     ;  .    .
         RORB                     ;  .    .
         STB     RZPOS            ;  .    SAVE RELATIVE 'Z'
;
         JSR     PRJCTN           ;  CALCULATE PROJECTIONS FOR SCREEN
         BVS     PROJ5            ;  .
;
         LDB     DRWSCX           ;  FORM OBJECT TABLE POINTER
         ADDB    #$80             ;  .    CALCULATE ANGLE TO OBJECT ON SCREEN
         LSRB                     ;  .    .
         LSRB                     ;  .    .
         LSRB                     ;  .    .
         LDU     #OBJTBL          ;  .    CALCULATE TABLE POINTER
         LDA     #OBJLEN          ;  .    .
         MUL                      ;  .    .
         LEAU    D,U              ;  .    .
;
         LDA     <<OBJFLG,U         ;  .    .    OBJECT ANGLE ALREADY ACTIVE ?
         BEQ     PROJ3            ;  .    .    .
         LDA     DRWSCZ           ;  .    .    .    IS NEW OBJECT CLOSER ?
         CMPA    OBJSCZ,U         ;  .    .    .    .
         BHI     PROJ5            ;  .    .    .    .
;
PROJ3    LDD     <<SCNADR,X         ;  SET CURRENT OBJECT PARAMETERS
         TSTA                     ;  .    DOES OBJECT REQUIRE ANIMATION ?
         BEQ     PROJ4            ;  .    .    IS OBJECT SCENERY ?
         LDB     #$01             ;  .    .    .    REQUIRES SPECIAL ANIMATION
PROJ4    STB     <<OBJFLG,U         ;  .    SET OBJECT FLAG
;
         STX     OBJPTR,U         ;  SET CURRENT OBJECT PARAMETERS
;
         LDB     DRWSCZ           ;  .    ON-SCREEN 'Z' AXIS
         STB     OBJSCZ,U         ;  .    .
;
         LDA     DRWSCY           ;  .    ON-SCREEN 'Y' AXIS
         STA     OBJSCY,U         ;  .    .
;
         LDA     DRWSCX           ;  .    ON-SCREEN 'X' AXIS
         STA     OBJSCX,U         ;  .    .
;
         CMPA    #$E0             ;  IS THIS THE CLOSEST IN-FRONT OBJECT ?
         BLE     PROJ5            ;  .    IS THIS OBJECT IN-FRONT ?
         CMPA    #$30             ;  .    .
         BGE     PROJ5            ;  .    .
         CMPB    #$80             ;  .    IS THIS OBJECT TOO FAR AWAY ?
         BHI     PROJ5            ;  .    .
         CMPB    CBXDST           ;  .    IS THIS OBJECT CLOSER THAN ANYOTHER ?
         BHI     PROJ5            ;  .    .
;
         STB     CBXDST           ;  .    SAVE DISTANCE TO IN-FRONT OBJECT
         STX     CBXSCN           ;  .    SAVE GRID SCAN TABLE ENTRY POINTER
         STU     CBXOBJ           ;  .    SAVE OBJECT TABLE ENTRY POINTER
;
PROJ5    LEAX    SCNLEN,X         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .
         BNE     PROJ2            ;  .
;
PROJ6    RTS                      ;  RETURN TO CALLER
;
;         IF      L.GRD = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;         IF      L.FOG = OFF      ;-------------------------------------------
;         LIST    -L               ;--  FOG  ----------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  FOG GAME LOGIC
;  ==============
;
         direct   $D0
;        =====   ===
;
FOG      LDA     FOGFLG           ;  IS FOG CYCLING REQUESTED ?
         LBEQ    FOG8             ;  .
         BMI     FOG2             ;  .
;
         INC     FOGLIM           ;  SET MAXIMUM ALTITUDE OF FOG
         LDA     FOGLIM           ;  .
         CMPA    #$60             ;  .
         BLO     FOG3             ;  .
;
;
         LDA     #$80             ;  CYCLE FOG DOWN
         STA     FOGFLG           ;  .
;
         LDA     SCTINH           ;  .    IS SCOUT ACTION INHIBITED ?
         BNE     FOG1             ;  .    .
;
         LDA     SCTFLG           ;  .    IS SCOUT PRESENT ?
         BEQ     FOG1             ;  .    .    IF SO, CAN'T GET LOST
         DEC     SCTCNT           ;  .    .    .    LIMIT NUMBER OF SCOUT USES
         BPL     FOG2             ;  .    .    .    .
;
         CLR     SCTFLG           ;  .    RESET SCOUT - USED FOR THE LAST TIME
;
FOG1     PSHS    DP               ;  SET-UP FOR NEW POSITION WITHIN MAP
         LDA     #$C8             ;  .    SET 'DP' = RAM
         TFR     A,DP             ;  .    .
         JSR     NEWMAP           ;  .    SET NEW MAP POSITION
         PULS    DP               ;  .    SET 'DP' = I/O
;
;
FOG2     DEC     FOGLIM           ;  DECREMENT ALTITUDE OF FOG
         BLE     FOG7             ;  .
;
FOG3     CLR     ETMP5            ;  RESET FOG ALTITUDE
;
         LDA     FOGLIM           ;  SET INTENSITY
         ADDA    #$20             ;  .
         BVC     FOG4             ;  .
         LDA     #$7F             ;  .
FOG4     JSR     INTENS           ;  .
;
         JSR     RANDOM           ;  POSITION FOG
         ANDA    #$1F             ;  .
         ADDA    #$90             ;  .
         LDB     #$00             ;  .
         JSR     POSITD           ;  .
;
         LDD     #$0158           ;  SET INITIAL DEFLECTION VALUES
         STD     ETMP2            ;  .
;
         JSR     RANDOM           ;  SET VECTOR LENGTH
         ANDA    #$7F             ;  .
         ORA     #$60             ;  .
         STA     T1LOLC           ;  .
;
FOG5     INC     ETMP5            ;  INCREMENT FOG ALTITUDE
         LDA     ETMP5            ;  .
         CMPA    FOGLIM           ;  .
         BHI     FOG8             ;  .
;
         LDD     ETMP2            ;  CALCULATE NEW 'X' AXIS VALUE
         NEGB                     ;  .
         STB     ETMP2 + 1        ;  .
;
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         TST     $FF00            ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
         STB     DAC              ;  SET 'X' AXIS VALUE
;
         LDD     #$FF00           ;  .
         STA     SHIFT            ;  .
         STB     T1HOC            ;  .    START VECTOR RAMP
;
         LDD     #$0040           ;  .
FOG6     BITB    IFLAG            ;  .
         BEQ     FOG6             ;  .
         NOP                      ;  .    &lt;&lt; TIMING &gt;&gt;
;
         STA     SHIFT            ;  VECTOR COMPLETE
;
         JSR     RANDOM           ;  SET LONG VECTOR LENGTH
         ORA     #$C0             ;  .
         STA     T1LOLC           ;  .
         BRA     FOG5             ;
;
FOG7     CLR     FOGFLG           ;  .
         CLR     FOGLIM           ;  .
;
FOG8     JMP     ZERGND           ;  RETURN TO CALLER (VIA 'ZERGND')
;
;
;
;
;  FOG / PLAGUE SCANNER
;  ====================
;
         direct   $C8
;        =====   ===
;
FOGSCN   LDY     #FOGTBL          ;  SET-UP FOR FOG / PLAGUE SCAN
;
         LDA     MAPY             ;  .    OFF-SET MAP POSITION
         SUBA    #$06             ;  .    .    'Y' AXIS
         STA     ETMP1            ;  .    .    .
         LDA     MAPX             ;  .    .    'X' AXIS
         SUBA    #$06             ;  .    .    .
         STA     ETMP2            ;  .    .    .
;
FSCN1    JSR     MAPSCN           ;  SCAN GRID FOR FOG OR PLAGUE
         BCS     FSCN5            ;  .    END OF FOG / PLAGUE SCAN SEQUENCE ?
         BVS     FSCN2            ;  .    TO CLOSE TO BORDER ?
;
         TFR     A,B              ;  .    SCENERY FOG OR PLAGUE ?
         ANDB    #$0E             ;  .    .
         EORB    #$0E             ;  .    .
         BNE     FSCN1            ;  .    .    SKIP IF NOT FOG OR PLAGUE
         ANDA    #$01             ;  .    .    FOG OR PLAGUE ?
         BEQ     FSCN4            ;  .    .    .    SCENERY PLAGUE
         BRA     FSCN3            ;  .    .    .    SCENERY FOG
;
;
FSCN2    JSR     FOGSET           ;  SET-UP BORDER FOG
         LDA     #$01             ;  .    INHIBIT SCOUT ACTION
         STA     SCTINH           ;  .    .
         RTS                      ;  .    RETURN TO CALLER
;
;
FSCN3    JSR     FOGSET           ;  SET-UP SCENERY FOG
         RTS                      ;  .    RETURN TO CALLER
;
;
FSCN4    JSR     PLGSET           ;  SET-UP SCENERY PLAGUE
FSCN5    RTS                      ;  .    RETURN TO CALLER
;
;
;
FOGTBL   DW      $0505            ;  SCAN SEQUENCE FOR FOG / PLAGUE
         DW      $0506            ;  .
         DW      $0507            ;  .
         DW      $0605            ;  .
         DW      $0606            ;  .
         DW      $0607            ;  .
         DW      $0705            ;  .
         DW      $0706            ;  .
         DW      $0707            ;  .
         DW      0                ;  .    SCAN TERMINATOR
;
;         IF      L.FOG = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;         IF      L.PLG = OFF      ;-------------------------------------------
;         LIST    -L               ;--  PLAGUE  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  PLAGUE GAME LOGIC
;  =================
;
         direct   $D0
;        =====   ===
;
PLAGUE   LDA     PLGFLG           ;  IS PLAGUE CYCLING REQUESTED ?
         LBEQ    PLG9             ;  .
         BMI     PLG2             ;  .
;
         INC     PLGLIM           ;  SET MAXIMUM ALTITUDE OF PLAGUE
         LDA     PLGLIM           ;  .
         TFR     A,B              ;  .    MODIFY POINT WARRIOR INTENSITY
         LSRB                     ;  .    .
         STB     WARINT           ;  .    .
         CMPA    #$60             ;  .
         BLO     PLG3             ;  .
;
         LDA     #$80             ;  CYCLE DOWN PLAGUE
         STA     PLGFLG           ;  .
;
         LDA     HLRFLG           ;  .    IS HEALER PRESENT ?
         BEQ     PLG1             ;  .    .    IF SO, SAVE POINT WARRIOR
         DEC     HLRCNT           ;  .    .    .    LIMIT NUMBER OF HEALER USES
         BPL     PLG2             ;  .    .    .    .
;
         CLR     HLRFLG           ;  .    RESET HEALER - USED FOR THE LAST TIME
;
PLG1     CLR     WARFLG           ;  .    KILL POINT WARRIOR
         LDA     #$90             ;  .    .    SET WARRIOR INSERTION TIMER
         STA     TMR1             ;  .    .    .
;
PLG2     DEC     PLGLIM           ;  DECREMENT ALTITUDE OF PLAGUE
         BLE     PLG8             ;  .
;
PLG3     CLR     ETMP1            ;  RESET PLAGUE ALTITUDE
;
         LDA     PLGLIM           ;  SET INTENSITY
         ADDA    #$20             ;  .
         BVC     PLG4             ;  .
         LDA     #$7F             ;  .
PLG4     JSR     INTENS           ;  .
;
         JSR     RANDOM           ;  POSITION PLAGUE
         STA     WARDSH           ;  .    SET POINT WARRIOR DASHING
         ANDA    #$0F             ;  .
         ADDA    #$90             ;  .
         LDB     #$00             ;  .
         JSR     POSITD           ;  .
;
         LDD     #$0158           ;  SET INITIAL DEFLECTION VALUES
         STD     ETMP2            ;  .
;
         JSR     RANDOM           ;  SET VECTOR LENGTH
         ANDA    #$1C             ;  .
         STA     T1LOLC           ;  .
;
PLG5     INC     ETMP1            ;  INCREMENT PLAGUE ALTITUDE
         LDA     ETMP1            ;  .
         CMPA    PLGLIM           ;  .
         BHI     PLG9             ;  .
;
         LDD     ETMP2            ;  CALCULATE NEW 'X' AXIS VALUE
         NEGB                     ;  .
         BMI     PLG6             ;  .
         DECB                     ;  .
PLG6     STB     ETMP2 + 1        ;  .
;
         STA     DAC              ;  SET 'Y' AXIS VALUE
         CLR     CNTRL            ;  .    START SAMPLE / HOLD STROBE
         TST     $FF00            ;  .    .    &lt;&lt; TIMING &gt;&gt;
         INC     CNTRL            ;  .    STOP SAMPLE / HOLD STROBE
         STB     DAC              ;  SET 'X' AXIS VALUE
;
         LDA     DASH             ;  .
         LDB     #$40             ;  .
         STA     SHIFT            ;  .    SET DASH PATTERN IN SHIFT REGISTER
         CLR     T1HOC            ;  .    START VECTOR RAMP
;
PLG7     LDA     DASH             ;  DASH VECTOR
         STA     SHIFT            ;  .
         NOP                      ;  .    &lt;&lt; TIMING &gt;&gt;
         BITB    IFLAG            ;  .    WAIT FOR VECTOR COMPLETION
         BEQ     PLG7             ;  .    .
;
         CLR     SHIFT            ;  VECTOR COMPLETE
         JSR     RANDOM           ;  .    SET DASH PATTERN FOR NEXT LINE
         STA     DASH             ;  .    .
;
         JSR     RANDOM           ;  SET LONG VECTOR LENGTH
         ANDA    #$3F             ;  .
         ADDA    PLGLIM           ;  .
         STA     T1LOLC           ;  .
         BRA     PLG5             ;
;
PLG8     CLR     PLGFLG           ;  RESET PLAGUE
         LDA     #$FF             ;  .    RESET POINT WARRIOR DASHING
         STA     WARDSH           ;  .    .
;
PLG9     JMP     ZERGND           ;  RETURN TO CALLER
;
;         IF      L.PLG = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
