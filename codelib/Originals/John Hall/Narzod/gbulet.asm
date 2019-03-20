;
;
;         IF      L.BLT = OFF      ;-------------------------------------------
;         LIST    -L               ;--  GBULET  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  BULLET GAME LOGIC
;  =================
;
         direct   $C8
;        =====   ===
;
GBULET   LDX     #BLBNC           ;  SET-UP BULLET BOUNCE TABLE POINTER
         STX     BNCTBL           ;  .
;
         LDA     #BULETS + 4      ;  FIND ACTIVE BULLET
         STA     TEMP1            ;  .
         LDU     #BLTTBL          ;  .
;
GBLT1    LDA     BLTFLG,U         ;  .    BULLET ACTIVE ?
         LBEQ    NEWBLT           ;  .    .
;
         JSR     MOVOBJ           ;  CALCULATE NEW BULLET POSITION
         BVS     GBLT3A           ;  .    BULLET MOVED OFF-SCREEN ?
         BCS     GBLT3A           ;  .    .
;
         LDA     KILFLG           ;  UPDATE PERSPECTIVE INFO
         BEQ     GBLT1B           ;  .    KILLER SEQUENCE ?
;
         LDX     #K_INT           ;  .    SET-UP FOR KILLER PERSPECTIVE INFO
         BRA     GBLT1C           ;  .    .
;
GBLT1B   LDX     #B_INT           ;  .    NORMAL PERSPECTIVE INFO
GBLT1C   LDA     BLTYW,U          ;  .    .    FETCH VERTICAL POSITION
         JSR     PRSPCT           ;  .    .    CALCULATE NEW POINTER
         STA     TEMP2            ;  .    .
         STB     BLTERG,U         ;  .    .    SAVE BULLET ENERGY LEVEL
;
         LDA     KILFLG           ;  .    KILLER SEQUENCE ?
         BNE     GBLT1D           ;  .    .
;
         TSTB                     ;  .    HAS BULLET REACHED ZERO ENERGY ?
         BEQ     GBLT8            ;  .    .
         BRA     GBLT1E           ;  .    .
;
GBLT1D   TSTB                     ;  .    KILLER SEQUENCE - BULLET OFF-SCREEN ?
         BEQ     GBLT3A           ;  .    .
;
;
GBLT1E   LDA     TEMP1            ;  PERFORM BOUNCE TEST
         CMPA    #BULETS          ;  .    WAR-BIRD BULLETS ?
         BLE     GBLT10           ;  .    .
;
         LDA     KILFLG           ;  .    KILLER SEQUENCE ?
         BNE     GBLT13           ;  .    .
;
         LDA     BLTHLD,U         ;  .    BOUNCE HOLD-OFF PENDING ?
         BNE     GBLT12           ;  .    .
;
         JSR     COLIDE           ;  .    PERFORM WALL COLLISION TEST
         BVS     GBLT3A           ;  .    .    IS BULLET OUT-BOUND ?
         BCC     GBLT10           ;  .    .    DID WALL COLLISION OCCUR ?
;
GBLT16   DEC     BLTBNC,U         ;  HANDLE BULLET BOUNCE
         BEQ     GBLT3A           ;  .    TEST BULLET BOUNCE COUNTER
;
GBLT17   LDA     #$7F             ;  .    FORM NEW BULLET DISPLACEMENTS
         JSR     CALDSP           ;  .    .    CALCULATE NEW DISPLACEMENTS
;
         LDA     #$03             ;  .    SET BULLET BOUNCE HOLD-OFF
         STA     BLTHLD,U         ;  .    .
;
GBLT12   DEC     BLTHLD,U         ;  DECREMENT BOUNCE HOLD-OFF
;
;
GBLT10   LDA     BLTXW,U          ;  IS BULLET HIDDEN BY WALL ?
         LDX     #CHRLIM          ;  .    RIGHT WALL ?
         LDB     TEMP2            ;  .    .
         CMPA    B,X              ;  .    .
         BGT     NXTBLT           ;  .    .
         LDX     #CHLLIM          ;  .    LEFT WALL ?
         CMPA    B,X              ;  .    .
         BLT     NXTBLT           ;  .    .
;
GBLT13   PSHS    DP               ;  DISPLAY BULLET FOR THIS ENTRY
         LDA     #$D0             ;  .    SET "DP" TO I/O
         TFR     A,DP             ;  .    .
         LDX     #B_ERG           ;  .    SET BULLET INTENSITY
         LDA     BLTERG,U         ;  .    .
         LDA     A,X              ;  .    .
         JSR     INTENS           ;  .    .
         LEAY    BLTYW,U          ;  .    POSITION BULLET
         JSR     DDOT             ;  .    .
         PULS    DP               ;  .    SET "DP" BACK TO RAM
;
NXTBLT   LEAU    BLTLEN,U         ;  BUMP TO NEXT ENTRY
         DEC     TEMP1            ;  .    END-OF-BULLET TABLE ?
         LBNE    GBLT1            ;  .    .
;
         RTS                      ;  .    RETURN TO CALLER
;
;
;
GBLT3A   CLR     BLTFLG,U         ;  CLEAR BULLET ENTRY
         DEC     CBLT             ;  .    DECREMENT ACTIVE BULLET COUNTER
         BRA     NXTBLT           ;  .    BUMP TO NEXT ENTRY
;
;
GBLT8    LDA     BLTANG,U         ;  BULLET AT TOP OF SCREEN - SEND BACK DOWN ?
         BNE     GBLT3A           ;  .
;
         LDA     #$20             ;  SET BULLET ANGLE
         STA     BLTANG,U         ;  .
;
         BRA     GBLT16           ;  TURN BULLET
;
;
;
NEWBLT   LDA     BFIRE            ;  INSERT NEW BULLET ?
         BNE     NWBLT1           ;  .    IS FIRE BUTTON DEPRESSED ?
         CLR     BLSTMR           ;  .    .    BUTTON 'OFF' - RESET TIMER
         BRA     NXTBLT           ;  .    .    .
;
NWBLT1   LDA     BLSTMR           ;  .    BLASTER INHIBITED ?
         ORA     ABORT            ;  .    GAME ABORTED ?
         BNE     NXTBLT           ;  .    .
;
         LDA     TEMP1            ;  .    DISPLAYING WAR-BIRD BULLETS ?
         CMPA    #BULETS          ;  .    .
         BLE     NXTBLT           ;  .    .
;
         LDA     #$80             ;  INSERT NEW BULLET !
         STA     SHOOT            ;  .    TURN-ON BULLET SOUND
         INC     BLTFLG,U         ;  .    SET BULLET 'ON'
;
         LDD     BLSTY            ;  .    SET BLASTER POSITION
         STD     BLTYW,U          ;  .    .    'Y' AXIS
         LDD     BLSTX            ;  .    .    'X' AXIS
         STD     BLTXW,U          ;  .    .    .
         LDD     BLSTYX           ;  .    .    ABSOLUTE 'YX' POSITION
         STD     BLTYX,U          ;  .    .    .
;
         LDA     #$03             ;  .    SET BULLET BOUNCE COUNTER
         STA     BLTBNC,U         ;  .    .
;
         LDA     #$07             ;  .    SET BULLET ENERGY LEVEL
         STA     BLTERG,U         ;  .    .
;
         LDA     #$08             ;  .    SET BLASTER INHIBIT COUNTER
         STA     BLSTMR           ;  .    .
;
         CLR     BLTANG,U         ;  .    CLEAR BULLET ANGLE
;
         INC     CBLT             ;  .    BUMP ACTIVE BULLET COUNTER
;
         JMP     GBLT17           ;  .    .
;
;
;         IF      L.BLT = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------