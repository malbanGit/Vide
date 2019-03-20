;
;
;         IF      L.CIT = OFF      ;-------------------------------------------
;         LIST    -L               ;--  CITDEL  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;  DRAW CITADEL SCENERY
;  ====================
;
         direct   $D0
;        =====   ===
;
CITDEL   LDA     LVLTMR           ;  DRAW PLAYER STATUS
         BEQ     CIT0             ;  .    SKIP DISPLAY ?
         DEC     LVLTMR           ;  .    DECREMENT STATUS DISPLAY TIMER
;
         JSR     INTMAX           ;  .    INDICATE ACTIVE GAME LEVEL
         LDU     #RLEVEL          ;  .    .    RASTER MESSAGE 'LEVEL'
         JSR     SMESS            ;  .    .    .
;
         LDU     #PLEVEL          ;  .    .    RASTER LEVEL NUMBER
         LDA     ACTPLY           ;  .    .    .    FETCH FIELD POINTER 
         LDU     A,U              ;  .    .    .    .
         LDY     #$463E           ;  .    .    .    SET POSITION
         JSR     ASMESS           ;  .    .    .
;
         LDD     #$FA38           ;  .    DISPLAY REMAINING BLASTERS
         STD     SIZRAS           ;  .    .    SET MARKER SIZE
         LDX     #$8030           ;  .    .    FETCH BLASTER COUNT
         LDB     BLSCNT           ;  .    .    .
         BMI     CIT0             ;  .    .    .    .
         BEQ     CIT0             ;  .    .    .    .
         LDA     #$68             ;  .    .    SET MARKER CHARACTER
         JSR     DSHIP            ;  .    .    DISPLAY MARKERS
;
;
CIT0     LDA     ACTIVE           ;  .    GATE OPEN ?
         BNE     CIT2             ;  .    .
         LDA     GRDTYP           ;  .    .    STOMPERS ?
         CMPA    #$11             ;  .    .    .
         BLT     CIT2             ;  .    .    .
;
         JSR     INTMAX           ;  .    SET INTENSITY FOR MESSAGE
;
         LDA     LFLAG            ;  .    PRE-KILLER SEQUENCE ?
         CMPA    #$02             ;  .    .
         BGE     CIT1             ;  .    .
;
         LDU     #RPASS           ;  .    DISPLAY GATE OPEN MESSAGE
         JSR     SMESS            ;  .    .
         BRA     CIT2             ;  .    .
;
CIT1     LDU     #RABAND          ;  .    ABANDON ALL HOPE
         JSR     TXTSIZ           ;  .    .
;
;
CIT2     LDA     KILFLG           ;  KILLER SEQUENCE ?
         BNE     KILCIT           ;  .
;
         JSR     INT3Q            ;  DISPLAY ROADWAY FOR MAIN SEQUENCE
         LDU     #XROAD1          ;  .    DRAW VECTOR STRING
         JSR     SPRCNT           ;  .    .
;
         LDA     LFLAG            ;  .    DISPLAY WHICH PORTAL ?
         BEQ     CTDL0            ;  .    .    GATE FOR LOWER ROADWAY ?
         DECA                     ;  .    .    GATE FOR MIDDLE ROADWAY ?
         BEQ     CTDL1            ;  .    .    .
;
         LDA     #$54             ;  .    DISPLAY GATE FOR UPPER ROADWAY
         JSR     INTENS           ;  .    .
         LDU     #XGATE1          ;  .    .    DRAW VECTOR STRING
         JSR     SPRCNT           ;  .    .    .
         LDA     #$48             ;  .    .
         JSR     INTENS           ;  .    .
         LDX     #GATE33          ;  .    .
         JSR     IDUFFY           ;  .    .
         BRA     CTDL5            ;  .    .
;
CTDL0    LDA     #$54             ;  .    DISPLAY GATE FOR LOWER ROADWAY
         JSR     INTENS           ;  .    .
         LDU     #XGATE1          ;  .    .    DRAW VECTOR STRING
         JSR     SPRCNT           ;  .    .    .
         BRA     CTDL5            ;  .    .
;
CTDL1    LDA     #$54             ;  .    DISPLAY GATE FOR MIDDLE ROADWAY
         JSR     INTENS           ;  .    .
         LDU     #XGATE2          ;  .    .    DRAW VECTOR STRING
         JSR     SPRCNT           ;  .    .    .
;
;
CTDL5    JSR     INT2Q            ;  .    DRAW FORTRESS LANDSCAPE
         LDU     #XBCKSC          ;  .    .    DRAW VECTOR STRING
         JSR     SPRCNT           ;  .    .    .
         RTS                      ;  RETURN TO CALLER
;
;
;
KILCIT   LDA     EKLTMR           ;  DISPLAY ROADWAY FOR KILLER SEQUENCE
         BEQ     KILCT1           ;  .    KILLER DISMEMBERMENT ?
;
         JSR     RANDOM           ;  .    KILLER DISMEMBERMENT IN PROGRESS
         STA     DASH             ;  .    .
;
KILCT1   LDA     KLLINT           ;  .    DRAW FORTRESS CITY
         JSR     INTENS           ;  .    .
;
         LDU     #XCITY           ;  .    .
         JSR     SPRCNT           ;  .    .
;
         JSR     INT3Q            ;  .    DRAW FORTRESS BACKGROUND
         LDU     #KBACK           ;  .    .
         JSR     SPRCNT           ;  .    .
;
         RTS                      ;  RETURN TO CALLER
;
;
;         IF      L.CIT = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
