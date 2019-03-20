;
;
;         IF      L.TMR = OFF      ;-------------------------------------------
;         LIST    -L               ;-- TIMERS  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  ***************************************************************
;  ***************************************************************
;  ***                                                         ***
;  ***          P R O G R A M M A B L E   T I M E R S          ***
;  ***                                                         ***
;  ***************************************************************
;  ***************************************************************
;
;  TIMER #1 - INSERT NEW WARRIOR FROM RESERVES
;  ===========================================
;
         direct   $C8
;        =====   ===
;
HANDL1   LDA     WARFLG           ;  WARRIOR REQUESTED ?
         BNE     HNDL12           ;  .    IF NOT, INHIBIT HANDLER
;
         LDA     TROOPS           ;  WARRIORS REMAINING ?
         BLE     HNDL11           ;  .
;
         LDA     #$01             ;  SET NEW WARRIOR
         STA     WARFLG           ;  .
         LDX     #MEN             ;  .    DECREMENT REMAINING WARRIOR COUNTER
         CLRA                     ;  .    .    DUMMY PARAMETER
         JSR     ASCDEC           ;  .    .
         DEC     TROOPS           ;  .    .    DECREMENT HEX COUNTER
;
         LDA     #$01             ;  SET ANIMATION FRAME
         STA     WARFRM           ;  .
;
         LDA     #WARINS          ;  SET-UP FOR MORE WARRIOR INSERTIONS
         STA     TMR1             ;  .    RESET TIMER
;
         CLR     WARINT           ;  .    RESET INTENSITY MODIFICATION
;
         LDA     #$FF             ;  .    RESET WARRIOR DASHING
         STA     WARDSH           ;  .    .
;
         RTS                      ;  .    RETURN TO CALLER
;
;
HNDL11   INC     ABORT            ;  WARRIORS ALL GONE - SET ABORT FLAG
HNDL12   RTS                      ;  .    RETURN TO CALLER
;
;
;
;
;  TIMER #2 - FORCE GOBLIN TO BE DISPLAYED
;  =======================================
;
         direct   $C8
;        =====   ===
;
HANDL2   LDA     CBXAMT           ;  TAIL-END OF BRIGAND FIGHT SCENE ?
         BPL     HNDL21           ;  .    IF SO, LIMIT GOBLIN INSERTION RATE
         LDA     GBLACT           ;  .    .    IS A GOBLIN ALREADY VISIBLE ?
         BNE     HNDL24           ;  .    .    .    IF SO, TRY LATER
;
HNDL21   JSR     RANDOM           ;  FIND A BRIGAND TO DISPLAY
         ANDA    #$07             ;  .
         CMPA    #BRGCNT - 1      ;  .
         BGT     HANDL2           ;  .
         PSHS    A                ;  .
         LDB     #BRGLEN          ;  .
         MUL                      ;  .
         ADDD    #BRGTBL          ;  .
         TFR     D,U              ;  .
         LDB     #BRGCNT          ;  .
         SUBB    ,S+               ;  .
;
HNDL22   LDA     <<BRGFLG,U         ;  .    IS BRIGAND ENTRY ACTIVE ?
         BPL     HNDL23           ;  .    .    INSERT NEW BRIGAND ?
;
         LEAU    BRGLEN,U         ;  .    BUMP TO NEXT ENTRY
         DECB                     ;  .    .
         BNE     HNDL22           ;  .    .
         BRA     HNDL24           ;  .    .    NO OPENING - TRY LATER
;
;
HNDL23   LDA     #$80             ;  DISPLAY THIS BRIGAND
         STA     <<BRGFLG,U         ;  .    SET ANIMATION FLAG
         CLR     BRGTMR,U         ;  .    RESET ANIMATION COUNTER
;
         CLR     GBLKIL           ;  .    RESET LAST GOBLIN KILLED FLAG
;
;
HNDL24   JSR     RANDOM           ;  RESET BRIGAND REQUEST TIMER
         ANDA    #$3F             ;  .
         ORA     #$20             ;  .    SET MINIMUM TIME
         ADDA    #$1C             ;  .    FUDGE TIME UPWARDS
         STA     TMR2             ;  .
;
         RTS                      ;  .    RETURN TO CALLER
;
;         IF      L.TMR = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
