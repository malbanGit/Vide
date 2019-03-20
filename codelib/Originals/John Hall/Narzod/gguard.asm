;
;
;         IF      L.GRD = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GGUARD  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;  GUARDIAN GAME LOGIC
;  ===================
;
         direct   $C8
;        =====   ===
;
GGUARD   LDA     #GUARDS          ;  FIND ACTIVE GUARDIAN
         STA     TEMP1            ;  .
         LDU     #GRDTBL          ;  .
         LDY     #SPKTBL          ;  .
;
NEWGRD   LDA     GRDFLG,U         ;  .    GUARDIAN ACTIVE ?
         LBEQ    NXTGRD           ;  .    .
         LBMI    GDYING           ;  .    .    GUARDIAN DYING ?
;
         LDB     KILFLG           ;  .    .    KILLER SEQUENCE ?
         BNE     GMOV3            ;  .    .    .
;
         ANDA    #$40             ;  .    .    IS GUARDIAN FALLING ?
         BEQ     GMOV1            ;  .    .    .
;
         DEC     GRDTMR,U         ;  HANDLE FALLING GUARDIANS
         BNE     GFALL2           ;  .    CHANGE GUARDIAN MOTION ?
;
         LDD     GUARDY           ;  .    RESET FALLING GUARDIAN
         STD     GRDYD,U          ;  .    .    'Y' AXIS DISPLACEMENT
         LDD     GUARDX           ;  .    .    'X' AXIS DISPLACEMENT
         STD     GRDXD,U          ;  .    .    .
         LDA     GRDFLG,U         ;  .    .    RESET FALLING FLAG
         ANDA    #$BF             ;  .    .    .
         STA     GRDFLG,U         ;  .    .    .
         JSR     RANDOM           ;  .    .    SET NEW TIMER VALUE
         ORA     #$40             ;  .    .    .
         STA     GRDTMR,U         ;  .    .    .
         BRA     GFALL6           ;  .    .
;
GFALL2   JSR     MOVOBJ           ;  .    CALCULATE NEW GUARDIAN POSITION
;
         LDA     GRDYW,U          ;  .    .    LEFT WALL CHECK
         LDX     #CL_LIM          ;  .    .    .
         JSR     PRSPCT           ;  .    .    .
         CMPB    GRDXW,U          ;  .    .    .
         BLT     GFALL3           ;  .    .    .
         STB     GRDXW,U          ;  .    .    .
         BRA     GFALL4           ;  .    .    .
;
GFALL3   LDX     #CR_LIM          ;  .    .    RIGHT WALL CHECK
         LDB     A,X              ;  .    .    .
         CMPB    GRDXW,U          ;  .    .    .
         BGT     GFALL4           ;  .    .    .
         STB     GRDXW,U          ;  .    .    .
;
GFALL4   LDA     GRDYW,U          ;  .    .    LOWER LIMIT CHECK
         CMPA    #LLIMIT          ;  .    .    .
         BGE     GFALL6           ;  .    .    .
;
         LDD     GUARDY           ;  .    .    START GUARDIAN BACK UP
         COMA                     ;  .    .    .    SET 'Y' DISPLACEMENT
         COMB                     ;  .    .    .    .
         ADDD    #$0001           ;  .    .    .    .
         STD     GRDYD,U          ;  .    .    .    .
         LDD     GUARDX           ;  .    .    .    SET 'X' DISPLACEMENT
         STD     GRDXD,U          ;  .    .    .    .
         LDA     GRDFLG,U         ;  .    .    .    SET GUARDIAN TO MARCHING
         ANDA    #$BF             ;  .    .    .    .
         STA     GRDFLG,U         ;  .    .    .    .
         JSR     RANDOM           ;  .    .    .    SET MOTION TIMER
         ORA     #$08             ;  .    .    .    .
         STA     GRDTMR,U         ;  .    .    .    .
GFALL6   BRA     GDSP1            ;  .    .    .    DISPLAY CURRENT GUARDIAN
;
;
GMOV1    DEC     GRDTMR,U         ;  HANDLE MARCHING GUARDIANS
         BNE     GMOV3            ;  .    CHANGE GUARDIAN MOTION ?
;
         LDA     GRDYD,U          ;  .    IS GUARDIAN GOING UP ?
         BPL     GMOV3            ;  .    .
;
         JSR     GRFALL           ;  .    SET-UP FOR FALLING GUARDIAN
         BRA     GDSP1            ;  .
;
GMOV3    LDD     GRDXD,U          ;  .    CALCULATE NEW GUARDIAN POSITION
         ADDD    GRDXW,U          ;  .    .
         STD     GRDXW,U          ;  .    .
;
         LDX     #CL_LIM          ;  .    .    LEFT WALL CHECK
         LDA     GRDYW,U          ;  .    .    .
         JSR     PRSPCT           ;  .    .    .
         CMPB    GRDXW,U          ;  .    .    .
         BLT     GMOV4            ;  .    .    .
         STB     GRDXW,U          ;  .    .    .
         BRA     GMOV5            ;  .    .    .
;
GMOV4    LDX     #CR_LIM          ;  .    .    RIGHT WALL CHECK
         LDB     A,X              ;  .    .    .
         CMPB    GRDXW,U          ;  .    .    .
         BGT     GDSP1            ;  .    .    .
         STB     GRDXW,U          ;  .    .    .
;
GMOV5    LDD     GRDYD,U          ;  .    GUARDIAN HAS MOVED OFF ROADWAY
         ADDD    GRDYW,U          ;  .    .    UPDATE 'Y' POSITION
         STD     GRDYW,U          ;  .    .    .
;
         LDB     GRDYD,U          ;  .    .    IS GUARDIAN GOING UP ALREADY ?
         BMI     GMOV7            ;  .    .    .
         CMPA    #ULIMIT          ;  .    .    .    START GUARDIAN BACK DOWN ?
         BGE     GMOV8            ;  .    .    .    .
         BRA     GMOV9            ;  .    .    .    .
;
GMOV7    CMPA    #LLIMIT          ;  .    .    START GUARDIAN BACK UP ?
         BGE     GMOV9            ;  .    .    .
;
GMOV8    LDD     GRDYD,U          ;  .    .    .    UPDATE 'Y' DISPLACEMENT
         COMA                     ;  .    .    .    .    TWO'S COMPLEMENT
         COMB                     ;  .    .    .    .    .
         ADDD    #$0001           ;  .    .    .    .    .
         STD     GRDYD,U          ;  .    .    .    .    .
;
GMOV9    LDD     GRDXD,U          ;  .    .    UPDATE 'X' DISPLACEMENT
         COMA                     ;  .    .    .    TWO'S COMPLEMENT
         COMB                     ;  .    .    .    .
         ADDD    #$0001           ;  .    .    .    .
         STD     GRDXD,U          ;  .    .    .
         STD     KILXD            ;  .    .    .    SAVE VALUE FOR KILLER
;
;
GDSP1    LDX     #G_SIZ           ;  DISPLAY GUARDIAN FOR THIS ENTRY
         LDA     GRDYW,U          ;  .    UPDATE GUARDIAN SIZE
         STA     GRDYX,U          ;  .    .    SAVE ABSOLUTE 'YX' POSITION
         JSR     PRSPCT           ;  .    .
         STA     TEMP2            ;  .    .    SAVE PERSPECTIVE POINTER
         STB     GRDSIZ,U         ;  .    .
;
         LDB     SPKFLG,Y         ;  .    IS GUARDIAN HOLDING SPIKER ?
         BPL     GDSP2            ;  .    .
;
         LDD     GRDYW,U          ;  .    UPDATE SPIKER POSITION
         STD     SPKYW,Y          ;  .    .
         LDD     GRDXW,U          ;  .    .
         STD     SPKXW,Y          ;  .    .
;
GDSP2    LDA     GRDXW,U          ;  .    SAVE ABSOLUTE 'YX' POSITION
         STA     GRDYX+1,U        ;  .    .
;
         LDX     #CHRLIM          ;  IS GUARDIAN HIDDEN BY WALL ?
         LDB     TEMP2            ;  .    RIGHT WALL ?
         CMPA    B,X              ;  .    .
         BGT     NXTGRD           ;  .    .
         LDX     #CHLLIM          ;  .    LEFT WALL ?
         CMPA    B,X              ;  .    .
         BLT     NXTGRD           ;  .    .
;
;==========================================================================JJH
;GDSP3   PSHS    DP               ;  CODE DELETED - REV. B CHANGES   ======JJH
;        LDA     #$D0             ;  .                               ======JJH
;        TFR     A,DP             ;  .                               ======JJH
;        direct   $D0              ;  .                               ======JJH
;        LDX     #G.ERG           ;  .                               ======JJH
;        LDA     GRDERG,U         ;  .                               ======JJH
;        LDA     A,X              ;  .                               ======JJH
;        JSR     INTENS           ;  .                               ======JJH
;        LDD     GRDYX,U          ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #PGUARD          ;  .                               ======JJH
;        LDA     FRAME            ;  .                               ======JJH
;        LSRA                     ;  .                               ======JJH
;        LSRA                     ;  .                               ======JJH
;        ANDA    #$06             ;  .                               ======JJH
;        ADDA    GRDFLG,U         ;  .                               ======JJH
;        ANDA    #$3E             ;  .                               ======JJH
;        LDX     A,X              ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     GRDSIZ,U         ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;        PULS    DP               ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
GDSP3    PSHS    Y,DP             ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDA     #$D0             ;  .                               ======JJH
         TFR     A,DP             ;  .                               ======JJH
         direct   $D0              ;  .                               ======JJH
         LDX     #G_ERG           ;  .                               ======JJH
         LDA     GRDERG,U         ;  .                               ======JJH
         LDA     A,X              ;  .                               ======JJH
         JSR     INTENS           ;  .                               ======JJH
         LDX     #PGUARD          ;  .                               ======JJH
         LDA     FRAME            ;  .                               ======JJH
         LSRA                     ;  .                               ======JJH
         LSRA                     ;  .                               ======JJH
         ANDA    #$06             ;  .                               ======JJH
         ADDA    GRDFLG,U         ;  .                               ======JJH
         ANDA    #$3E             ;  .                               ======JJH
         LDX     A,X              ;  .                               ======JJH
         LDY     GRDYX,U          ;  .                               ======JJH
         LDB     GRDSIZ,U         ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
         PULS    Y,DP             ;  .                               ======JJH
;==========================================================================JJH
         direct   $C8              ;  .    .
;
;
NXTGRD   LEAU    GRDLEN,U         ;  BUMP TO NEXT ENTRY
         LEAY    SPKLEN,Y         ;  .
         DEC     TEMP1            ;  .    END-OF-GUARDIAN TABLE ?
         LBNE    NEWGRD           ;  .    .
         RTS                      ;  .    .    RETURN TO CALLER
;
;
GDYING   LDA     SPKFLG,Y         ;  GUARDIAN FOR THIS ENTRY IS DYING
         BPL     GDIE0            ;  .    IS IT HOLDING A SPIKER ?
         PSHS    U                ;  .    .    IF SO, DROP IT
         JSR     DRPSPK           ;  .    .    .
         PULS    U                ;  .    .    .
;
GDIE0    LDA     GRDERG,U         ;  .    DONE DYING YET ?
         SUBA    #$01             ;  .    .
         STA     GRDERG,U         ;  .    .
         CMPA    #$48             ;  .    .
         BLE     GDIE1            ;  .    .
;
         LDB     GRDFLG,U         ;  SET-UP FOR GUARDIAN DISMEMBERMENT ROTATION
         LSRB                     ;  .    CALCULATE DUFFY DISPLACEMENTS
         LSRB                     ;  .    .
         ANDB    #$06             ;  .    .
         STB     TEMP2            ;  .    .
;
         PSHS    Y,U              ;  .    ROTATE GUARDIAN SEGMENTS
         TFR     U,Y              ;  .    .
         LDX     #EXGRD1          ;  .    .    FETCH INDICATED DUFFY 
         LDX     B,X              ;  .    .    .
         LDU     #RGRD1           ;  .    .    .
         LDA     GRDYD,Y          ;  .    .    DECREMENT ROTATIONAL VALUE
         SUBA    #$02             ;  .    .    .
         STA     GRDYD,Y          ;  .    .    .
         LDB     ,X+               ;  .    .    SET DUFFY LENGTH
         STB     ,U+               ;  .    .    .
         JSR     DROT             ;  .    .    ROTATE DUFFY
;
         LDX     #EXGRD2          ;  .    .    FETCH INDICATED DUFFY
         LDB     TEMP2            ;  .    .    .
         LDX     B,X              ;  .    .    .
         LDU     #RGRD2           ;  .    .    .
         LDA     GRDYD+1,Y        ;  .    .    INCREMENT ROTATIONAL VALUE
         ADDA    #$02             ;  .    .    .
         STA     GRDYD+1,Y        ;  .    .    .
         LDB     ,X+               ;  .    .    SET DUFFY LENGTH
         STB     ,U+               ;  .    .    .
         JSR     DROT             ;  .    .    ROTATE DUFFY
;
         LDX     #EXGRD3          ;  .    .    FETCH INDICATED DUFFY
         LDB     TEMP2            ;  .    .    .
         LDX     B,X              ;  .    .    .
         LDU     #RGRD3           ;  .    .    .
         LDA     GRDYD+2,Y        ;  .    .    DECREMENT ROTATIONAL VALUE
         SUBA    #$03             ;  .    .    .
         STA     GRDYD+2,Y        ;  .    .    .
         LDB     ,X+               ;  .    .    SET DUFFY LENGTH
         STB     ,U+               ;  .    .    .
         JSR     DROT             ;  .    .    ROTATE DUFFY
         PULS    Y,U              ;  .    .
;
         PSHS    U,DP             ;  .    SET-UP TO DRAW DYING GUARDIAN
         LDB     #$D0             ;  .    .
         TFR     B,DP             ;  .    .
         direct   $D0              ;  .    .
;
         LDA     GRDERG,U         ;  DRAW GUARDIAN DISMEMBERMENT
         JSR     INTENS           ;  .
;
         LDX     GRDYX,U          ;  .    DRAW VECTOR STRING
         LDA     GRDSIZ,U         ;  .    .    SET GUARDIAN SIZE
         JSR     SPRTBL           ;  .    .
;
         PULS    U,DP             ;  .
         direct   $C8              ;  .
         BRA     GDIE9            ;  .
;
;
GDIE1    CLR     GRDFLG,U         ;  GUARDIAN HAS DIED
         PSHS    U                ;  .    INSERT NEW GUARDIAN, IF POSSIBLE
         JSR     GRDINS           ;  .    .
         PULS    U                ;  .    .
         DEC     CGRD             ;  .    RESET GUARDIAN ENTRY
;
GDIE9    JMP     NXTGRD           ;  .    BUMP TO NEXT ENTRY
;
;
;
;
;  SET-UP FOR FALLING GUARDIAN
;  ===========================
;
GRFALL   JSR     SWING            ;  SET FALL ANGLE
         ADDB    #$20             ;  .
         ANDB    #$3F             ;  .
         STB     GRDANG,U         ;  .
;
         LDA     #$30             ;  CALCULATE NEW DISPLACEMENTS
         JSR     CALDSP           ;  .
;
         LDA     GRDFLG,U         ;  SET FALLING FLAG
         ORA     #$40             ;  .
         STA     GRDFLG,U         ;  .
;
         JSR     RANDOM           ;  SET NEW TIMER VALUE
         ANDA    #$1F             ;  .
         ORA     #$08             ;  .    SET MINIMUM TIME
         STA     GRDTMR,U         ;  .
;
         RTS                      ;  RETURN TO CALLER
;
;
;         IF      L.GRD = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
