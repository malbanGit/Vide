;
;
;         IF      L.SND = OFF      ;-------------------------------------------
;         LIST    -L               ;--  SOUND  --------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  SOUND-EFFECT HANDLER
;  ====================
;
         direct   $D0
;        =====   ===
;
FWAIT    JSR     FRWAIT           ;  WAIT FOR FRAME BOUNDARY
         PSHS    DP               ;  .
         direct   $D0              ;  .
;
         JSR     DEFLOK           ;  PREVENT SCAN COLLAPSE
;
         LDA     SBTN             ;  INPUT CONSOLE SWITCHES
         JSR     DBNCE            ;  .
         LDD     SJOY             ;  READ JOYSTICK
         STD     EPOT0            ;  .    ENABLE BOTH POTS ON JOYSTICK #1
         STD     EPOT2            ;  .    ENABLE BOTH POTS ON JOYSTICK #2
         JSR     JOYBIT           ;  .
;
         LDA     #$C8             ;  SET "DP" REGISTER TO RAM
         TFR     A,DP             ;  .
         direct   $C8              ;  .
;
         LDA     FRAME            ;  CREATE FRAME FLAGS
         ANDA    #$07             ;  .
         STA     FRAM7            ;  .
         ANDA    #$03             ;  .
         STA     FRAM3            ;  .
         ANDA    #$01             ;  .
         STA     FRAM1            ;  .
;
         LDA     TMR1             ;  DOWN-COUNT TIMER #1
         BEQ     FWAIT1           ;  .    IS TIMER PENDING ?
         DEC     TMR1             ;  .
         BNE     FWAIT1           ;  .
         JSR     [TMR1+1]         ;  .    EXECUTE THE USER PROGRAM
;
FWAIT1   LDA     TMR2             ;  DOWN-COUNT TIMER #2
         BEQ     FWAIT2           ;  .    IS TIMER PENDING ?
         DEC     TMR2             ;  .
         BNE     FWAIT2           ;  .
         JSR     [TMR2+1]         ;  .    EXECUTE THE USER PROGRAM
;
FWAIT2   LDA     TMR3             ;  DOWN-COUNT TIMER #3
         BEQ     SOUND            ;  .    IS TIMER PENDING ?
         DEC     TMR3             ;  .
         BNE     SOUND            ;  .
         JSR     [TMR3+1]         ;  .    EXECUTE THE USER PROGRAM
;
;
;
SOUND    LDA     TSTAT            ;  IS A TUNE PENDING ?
         BEQ     SND1             ;  .
         CLR     BOXSQK           ;  .    RESET OTHER SOUND EFFECTS
         CLR     STEPS            ;  .    .
         CLR     THRSND           ;  .    .
         CLR     EXPBRG           ;  .    .
         CLR     EXPWAR           ;  .    .
         JSR     REPLAY           ;  .    IF SO, UPDATE
         JMP     SNUP0            ;  .    .
;
SND1     LDA     #$80             ;  CLEAR-OUT SOUND
         JSR     CLRSND           ;  .
;
         LDA     STEPS            ;  IS WARRIOR FOOTSTEP PENDING ?
         BNE     FOTSTP           ;  .
;
         LDA     BOXSQK           ;  IS BOX SQUEAK PENDING ?
         BNE     SBXSQK           ;  .
;
         LDA     EXPWAR           ;  IS WARRIOR EXPLOSION PENDING ?
         LBMI    WEXPL1           ;  .
         LBNE    WEXPL2           ;  .
;
         LDA     EXPBRG           ;  IS BRIGAND EXPLOSION PENDING ?
         LBMI    BEXPL1           ;  .
;
         LDA     THRSND           ;  IS FLAMOID THROWING SOUND PENDING ?
         LBMI    THRSN1           ;  .
         LBNE    THRSN2           ;  .
;
         JMP     SNUPDT           ;  UPDATE EXPLOSION SOUND EFFECTS
;
;
;
;        HANDLE FOOTSTEPS
;        ----------------
;
;             REQUIRES CHANNEL 'A' & 'B'
;
FOTSTP   LDA     #$03
         JSR     CLRSND
;
         DEC     STEPS
         LDB     STEPS
;
         CMPB    #$04
         BGE     ST0
;
         LSLB
         BRA     ST1
;
ST0      LDB     #$0C
         SUBB    STEPS
;
ST1      ADDB    #$02
         ANDB    #$0F
;
         STB     $C844
         STB     $C843
;
         LDD     #$E708
         ANDA    REQ6 
         SUBB    $C844
         STD     REQ6 
;
         JMP     SNUP0
;
;
;
;        HANDLE BOX OPENING / CLOSING SQUEAK
;        -----------------------------------
;
;             REQUIRES CHANNEL 'A'
;
SBXSQK   LDA     #$01
         JSR     CLRSND
;
         DEC     BOXSQK
         LDB     BOXSQK
;
         CMPB    #$0F
         BLS     SQ2
;
         LDB     #$0F
SQ2      STB     REQ5   
;
         LDX     #$0700
         LDB     FRAME
         LSRB
         LDB     BOXSQK
         BCC     SQ0
;
;
         LDX     #$0000
         NEGB
SQ0      SEX
;
         LSLB
         ROLA
;
         LSLB
         ROLA
;
         LSLB
         ROLA
;
         LSLB
         ROLA
;
         LEAX    D,X
         STX     REQC  
;
         LDA     #$FE
         ANDA    REQ6 
         STA     REQ6 
;
         BRA     SNUP0
;
;
;
;        HANDLE FLAMOID THROWING SOUND
;        -----------------------------
;
;             REQUIRES ALL CHANNELS
;
THRSN1   LDA     #$FF             ;  RESET SOUND GENERATOR
         BSR     CLRSND           ;  .
;
         LDA     #$01             ;  RESET THROWING FLAG
         STA     THRSND           ;  .
;
         CLR     XACON            ;  ENABLE EXPLOSION
         LDA     #$80             ;  .
         STA     SATUS            ;  .
         LDU     #THREXP          ;  START BLASTER EXPLOSION
         JSR     EXPLOD           ;  .
;
THRSN2   CLR     EXPBRG           ;  RESET PENDING SOUND EFFECTS
         BRA     SNUPDT           ;  .
;
;
;
;        HANDLE BRIGAND EXPLOSION
;        ------------------------
;
;             REQUIRES CHANNEL 'A'
;
BEXPL1   LDA     #$FF             ;  RESET SOUND GENERATOR
         JSR     CLRSND           ;  .
;
         LDA     #$01             ;  RESET EXPLOSION FLAG
         STA     EXPBRG           ;  .
;
         CLR     XACON            ;  ENABLE EXPLOSION
         LDA     #$80             ;  .
         STA     SATUS            ;  .
         LDU     #EXP01           ;  START GUARDIAN EXPLOSION
         JSR     EXPLOD           ;  .
;
         BRA     SNUPDT
;
;
;
;        HANDLE WARRIOR EXPLOSION
;        ------------------------
;
;             REQUIRES ALL CHANNELS
;
WEXPL1   LDA     #$FF             ;  RESET SOUND GENERATOR
         BSR     CLRSND           ;  .
;
         LDA     #$01             ;  RESET EXPLOSION FLAG
         STA     EXPWAR           ;  .
;
         CLR     XACON            ;  ENABLE EXPLOSION
         LDA     #$80             ;  .
         STA     SATUS            ;  .
         LDU     #EXP02           ;  START BLASTER EXPLOSION
         JSR     EXPLOD           ;  .
;
WEXPL2   CLR     EXPBRG           ;  RESET PENDING SOUND EFFECTS
;
;
;
;
;        UPDATE SOUND GENERATOR
;        ----------------------
;
SNUPDT   JSR     EXPLOD           ;  UPDATE EXPLOSION SOUND
;
         LDA     XACON            ;  ARE EXPLOSIONS DONE ?
         BNE     SNUP0            ;  .
;
         CLR     EXPBRG           ;  .    RESET EXPLOSION FLAGS
         CLR     EXPWAR           ;  .    .
         CLR     THRSND           ;  .    .
         CLR     SATUS            ;  .    .
;
SNUP0    PULS    DP               ;  UPDATE SOUND GENERATOR
         direct   $D0              ;  .    SET 'DP' = I/O
         JSR     REQOUT           ;  .    UPDATE SOUND CHIP
         RTS                      ;  .    RETURN TO CALLER
;
;
;
;
;        CLEAR SOUND GENERATION PARAMETERS
;        ---------------------------------
;
;        ENTRY VALUES
;        ------------
;           A  = BIT 7 = CLEAR ALL SOUND REGISTERS
;                    2 = CLEAR CHANNEL 'C' ONLY
;                    1 = CLEAR CHANNEL 'B' ONLY
;                    0 = CLEAR CHANNEL 'A' ONLY
;
         direct   $C8
;        =====   ===
;
CLRSND   TSTA                     ; IF A &lt; 0, THEN CLEAR ALL REGISTERS
         BMI     C999             ;
         BNE     C000
;
         CLR     TSTAT
         CLR     STEPS
         CLR     BOXSQK
         CLR     THRSND
         CLR     EXPBRG
         CLR     EXPWAR
;
C999     JSR     INTREQ           ; RESET ALL REGISTERS
         RTS                      ; RETURN
;
C000     ANDA    #%00000111       ; LOWER THREE BITS SIGNIFICANT
         TFR     A,B              ;
         PSHS    D                ; SAVE 2 COPIES ON STACK
         LSLA                     ; SHIFT LEFT 3 TIMES TO SET CORROSPONDING 
         LSLA                     ; NOISE CONTROL BIT
         LSLA                     ;
         ORA     ,S+               ; REASSEMBLE WHOLE BYTE
         ORA     REQ6             ; 
         STA     REQ6             ; SET BITS IN CONTROL REGISTER
         LDX     #REQ0            ; X --&gt; SOUND CHIP MIRROR REGISTERS
         CLR     ,X+               ; CLEAR ENVELOPE TYPE         (ALL CHANNELS)
         CLR     ,X+               ; CLEAR ENVELOPE PERIOD (MSB) (ALL CHANNELS)
         CLR     ,X+               ; CLEAR ENVELOPE PERIOD (LSB) (ALL CHANNELS)
         CLR     REQ7             ; CLEAR NOISE PERIOD
         LDU     #REQ8            ; U --&gt; CHANNEL C PITCH (MSB)
         PULS    A                ; RETRIEVE OTHER COPY OF ENTRY BIT MASK
         LDB     #2               ; B = 2 -- COUNTER AND INDEX OFFSET VALUE
;
C010     LSRA                     ; CHECK FOR BITS SET
         BCC     C020             ;
         CLR     B,X              ; CLEAR AMPLITUDE
         LSLB                     ; * 2 FOR OFFSET
         CLR     B,U              ; CLEAR PITCH (MSB)
         INCB                     ;   - NEXT -
         CLR     B,U              ; CLEAR PITCH (LSB)
         DECB                     ; FASTER THAN A PUSH AND PULL
         LSRB                     ;
;
C020     DECB                     ; AGAIN FOR ALL 3 BITS (CHANNELS)
         BPL     C010             ;
;
         RTS                      ; RESTORE ENTRY X REG AND RETURN
;
;
;
;
;        EXPLOSION PARAMETERS
;        --------------------
;
EXP01    DB      $08,$FF,$00,$02  ;  BRIGAND EXPLOSION
;
EXP02    DB      $3F,$00,$00,$01  ;  WARRIOR EXPLOSION
;
THREXP   DB      $33,$11,$7F,$08  ;  FLAMOID THROWING SOUND
;
;
;
;
;  OPENING TUNE
;  ============
;
;         TEMPO   64,2
;
ONE_OVER_EIGHT = $10
TRIPLE_TONE = $05 * 2
ONE_OVER_SIXTEEN = $08
DOT_ONE_OVER_EIGHT = $18 

OPNING   DW      OPNFAD
         DW      $FEB6
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      FS4 + $80
         DB      A4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      E4 + $80
         DB      A4 + $80
         DB      B4,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      A3 + $80
         DB      E5,DOT_ONE_OVER_EIGHT
;
         DB      GS4 + $80
         DB      B3 + $80
         DB      D5,ONE_OVER_SIXTEEN
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      GS4 + $80
         DB      E4 + $80
         DB      CS5,TRIPLE_TONE/2
;
         DB      FS4 + $80
         DB      A4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      E4 + $80
         DB      A4 + $80
         DB      B4,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS5,ONE_OVER_SIXTEEN
;
         DB      A4 + $80
         DB      E4 + $80
         DB      B4,ONE_OVER_SIXTEEN
;
         DB      A4 + $80
         DB      E4 + $80
         DB      A4,ONE_OVER_SIXTEEN
;
         DB      A4 + $80
         DB      E4 + $80
         DB      B4,ONE_OVER_SIXTEEN
;
         DB      A3 + $80
         DB      E3 + $80
         DB      CS5,$7F
;
         DW      $0080
;
;
OPNFAD   DB      $0F,$FF,$FE,$ED,$DC,$CB,$BA,$A9
         DB      $98,$88,$88,$88,$87,$76,$65,$54
;
;
;
;
;  FAN-FARE FOR BRIGANDS SEQUENCE
;  ==============================
;
;        TEMPO    40,6
;
HALF_TONE = $0C
ONE_OVER_FOUR = $06

BRGFAN   DW      $FDC3            ; FADE CONTROL
         DW      VIBENL           ; VIBRATO CONTROL
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,HALF_TONE
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,HALF_TONE
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,ONE_OVER_FOUR
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,ONE_OVER_FOUR
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,HALF_TONE
         DB      D5 + $80
         DB      D4 + $80
         DB      D3,HALF_TONE 
         DB      CS5 + $80
         DB      CS4 + $80
         DB      CS3,ONE_OVER_FOUR
         DB      CS5 + $80
         DB      CS4 + $80
         DB      CS3,ONE_OVER_FOUR
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,ONE_OVER_FOUR
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,ONE_OVER_FOUR
         DB      A4 + $80
         DB      A3 + $80
         DB      A2,ONE_OVER_FOUR
         DB      B4 + $80
         DB      B3 + $80
         DB      B2,HALF_TONE
         DB      B2,$80
;
;
;
;
;  FOG TUNE
;  ========
;
;         TEMPO   80,4
;
ONE_OVER_FOUR = $14; #noDoubleWarn 

FOGTUN   DW      $FEE8
         DW      $FD79
;
         DB      CS5,ONE_OVER_FOUR
         DB      C5,ONE_OVER_FOUR
         DB      D4,ONE_OVER_FOUR
;
         DB      C5,ONE_OVER_FOUR
         DB      B4,ONE_OVER_FOUR
         DB      FS4,ONE_OVER_FOUR
;
         DB      B4,ONE_OVER_FOUR
         DB      AS4,ONE_OVER_FOUR
         DB      F4,ONE_OVER_FOUR
;
         DB      AS4,ONE_OVER_FOUR
         DB      A4,ONE_OVER_FOUR
         DB      E4,$7F
;
         DW      $0080
;
;
;
;
;  TREASURE TUNE
;  =============
;
;         TEMPO   64,2
;
ONE_OVER_EIGHT = $10; #noDoubleWarn 
TRIPLE_TONE = $05 * 2; #noDoubleWarn 

TRSTUN   DW      OPNFAD
         DW      $FEB6
;
         DB      A5 + $80
         DB      E5 + $80
         DB      CS6,ONE_OVER_EIGHT
;
         DB      GS5 + $80
         DB      E5 + $80
         DB      CS6,TRIPLE_TONE/2
;
         DB      GS5 + $80
         DB      E5 + $80
         DB      CS6,TRIPLE_TONE/2
;
         DB      GS5 + $80
         DB      E5 + $80
         DB      CS6,TRIPLE_TONE/2
;
         DB      FS5 + $80
         DB      A5 + $80
         DB      CS6,ONE_OVER_EIGHT
;
         DB      E5 + $80
         DB      A5 + $80
         DB      B5,ONE_OVER_EIGHT
;
         DB      A4 + $80
         DB      E4 + $80
         DB      CS4,$7F
;
         DW      $0080
;
;
;
;
;  WARRIOR DEAD TUNE
;  =================
;
;         TEMPO   70,4
;
ONE_OVER_FOUR = $11; #noDoubleWarn 
DOT_ONE_OVER_EIGHT = $0c; #noDoubleWarn 
ONE_OVER_SIXTEEN = $04; #noDoubleWarn 
ONE_OVER_EIGHT = $08 ; #noDoubleWarn 

DEDTUN   DW      $FEE8
         DW      $FEB6
;
         DB      G2 + $80
         DB      D3 + $80
         DB      E4,ONE_OVER_FOUR
;
         DB      G2 + $80
         DB      C4 + $80
         DB      E4,DOT_ONE_OVER_EIGHT
;
         DB      G2 + $80
         DB      C4 + $80
         DB      E4,ONE_OVER_SIXTEEN
;
         DB      G2 + $80
         DB      B3 + $80
         DB      E4,ONE_OVER_FOUR
;
         DB      G2 + $80
         DB      C4 + $80
         DB      G4,DOT_ONE_OVER_EIGHT
;
         DB      A2 + $80
         DB      A3 + $80
         DB      FS4,ONE_OVER_SIXTEEN
;
         DB      B2 + $80
         DB      G3 + $80
         DB      FS4,ONE_OVER_EIGHT
;
         DB      B2 + $80
         DB      G3 + $80
         DB      E4,ONE_OVER_EIGHT
;
         DB      B2 + $80
         DB      FS3 + $80
         DB      E4,ONE_OVER_EIGHT
;
         DB      B2 + $80
         DB      FS3 + $80
         DB      DS4,ONE_OVER_EIGHT
;
         DB      B2 + $80
         DB      G3 + $80
         DB      E4,$70
;
         DW      $0080



;
;
;         IF      L.SND = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
