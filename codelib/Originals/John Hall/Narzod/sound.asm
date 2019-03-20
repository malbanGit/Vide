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
         direct   $C8
;        =====   ===
;
SOUND    LDA     EXPLO2           ;  BLASTER EXPLOSION PENDING ?
         LBMI    BEXPL            ;  .
         LBNE    BLUPDT           ;  .
;
         LDA     SIZZLE           ;  FORTRESS DISINTEGRATION PENDING ?
         LBNE    FRTSIZ           ;  .
;
         LDA     SHOOT            ;  IF EFFECT IS PENDING, SKIP TUNE
         ORA     OUCH             ;  .
         ORA     SQUAWK           ;  .
         ORA     EXPLO1           ;  .
         BNE     GRDOCH           ;  .
;
         JSR     REPLAY           ;  PLAY PENDING TUNE
         JMP     SNUP0            ;  .
;
;
;
;  GUARDIAN 'OUCH' HANDLER
;  =======================
;        REQUIRES CHANNEL 'A'
;
GRDOCH   CLR     TSTAT            ;  RESET PENDING TUNE
         LDA     #$FF             ;  CLEAR SOUND GENERATOR
         JSR     CLRSND           ;  .
;
         LDA     EXPLO1           ;  GUARDIAN EXPLOSION PENDING ?
         BMI     GEXPL            ;  .
         BNE     FIRING           ;  .
;
         LDB     OUCH             ;  GUARDIAN 'OUCH' PENDING ?
         BEQ     FIRING           ;  .    SKIP SOUND EFFECT ?
         BPL     GOCH1            ;  .
;
         LDA     #$10             ;  SET-UP GUARDIAN 'OUCH'
         STA     OUCH             ;  .
         LDX     #$0080           ;  .    SET BASE FREQUENCY
         STX     BASFRQ           ;  .    .
;
GOCH1    DEC     OUCH             ;  DECREMENT SOUND EFFECT TIMER
         STB     REQ5             ;  SET AMPLITUDE
         LDX     BASFRQ           ;  GET BASE FREQUENCY
         LDB     OUCH             ;  CALCULATE OFFSET TO BASE FREQUENCY
         BITB    #$01             ;
         BEQ     GOCH2            ;
         LEAX    -16,X            ;  NEGATIVE OFFSET (INCREASE IN FREQUENCY)
         BRA     GOCH3            ;
;
GOCH2    LEAX    12,X             ;  POSITIVE OFFSET (DECREASE IN FREQUENCY)
;
GOCH3    STX     BASFRQ           ;  UPDATE BASE FREQUENCY
         STX     REQC             ;  SET PITCH (CHANNEL A)
         LDA     #%11111110       ;  ENABLE CHANNEL A TONE
         ANDA    REQ6             ;
         STA     REQ6             ;
         BRA     FIRING           ;
;
;
;
;  HANDLE GUARDIAN EXPLOSION
;  =========================
;        REQUIRES CHANNEL 'A'
;
GEXPL    LDA     #$FF             ;  RESET SOUND GENERATOR
         JSR     CLRSND           ;  .
;
         LDA     #$01             ;  RESET EXPLOSION FLAG
         STA     EXPLO1           ;  .
;
         CLR     XACON            ;  ENABLE EXPLOSION
         LDA     #$80             ;  .
         STA     SATUS            ;  .
         LDU     #EXP01           ;  START GUARDIAN EXPLOSION
         JSR     EXPLOD           ;  .
;
;
;
;  BULLET FIRING SOUND HANDLER
;  ===========================
;        REQUIRES CHANNEL 'B' & 'C'
;
FIRING   LDB     SHOOT            ;  BULLET FIRING SOUND PENDING ?
         BEQ     BRDSQK           ;  .    SKIP SOUND EFFECT ?
         BPL     FIRE0A           ;  .
;
         LDA     #$10             ;  SET-UP BULLET 'FIRING' SOUND EFFECT
         STA     SHOOT            ;  .
;
FIRE0A   LDA     SQUAWK           ;  HAS WAR-BIRD CRY STARTED ?
         BMI     FIRE0B           ;  .
         CLR     SQUAWK           ;  .    IF SO, RESET CRY
;
FIRE0B   DEC     SHOOT            ;  DECREMENT SOUND EFFECT TIMER
         CMPB    #10              ;  IF &gt; 10, THEN VALUE BECOMES VOLUME (RAMP DOWN)
         BHS     FIRE2            ;
         CMPB    #7               ;  IF &gt; 7 AND &lt; 10, THEN RAMP UP
         BHS     FIRE1            ;
         LSLB                     ;  IF &lt; 7 THEN SLOW RAMP DOWN
         BRA     FIRE2            ;
;
FIRE1    LDB     #16              ;  RAMP UP
         SUBB    SHOOT            ;  .
;
FIRE2    STB     REQ4             ;  SET AMPLITUDES
         STB     REQ3             ;  .
         LDA     #$18             ;  SET PITCH (CHANNEL B)
         MUL                      ;  .
         STD     REQA             ;  .
         LDB     #16              ;  SET NOISE PERIOD
         SUBB    SHOOT            ;  .
         STB     REQ7             ;  .
         LDA     #$24             ;  SET PITCH (CHANNEL B)
         MUL                      ;  .
         STD     REQ8             ;  .
;
;==========================================================================JJH
;        LDA     #11101001B       ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
;
         LDA     #%11111001       ;  ENABLE CHANNEL B AND C TONE
         ANDA    REQ6             ;  .     AND CHANNEL B NOISE
         STA     REQ6             ;  .     .
         JMP     SNUPDT           ;  .
;
;
;
;  WAR-BIRD SQUAWK HANDLER
;  =======================
;        REQUIRES CHANNEL 'B' & 'C'
;
BRDSQK   LDB     CBRD             ;  ARE BIRDS ACTIVE ON SCREEN ?
         BNE     SQWK0C           ;  .
         CLR     SQUAWK           ;  .    NO BIRD ACTIVE - RESET SQUAWK
         BRA     SQWK1            ;  .    .
;
SQWK0C   LDB     SQUAWK           ;  BIRD SQUAWK PENDING ?
         BEQ     SQWK1            ;  .    SKIP SOUND EFFECT ?
         BPL     SQWK0A           ;  .
;
         LDA     #$20             ;  INITIALIZE BIRD-SQUAWK
         STA     SQUAWK           ;  .
;
SQWK0A   DEC     SQUAWK           ;
         LDA     FRAME            ; SET AMPLITUDE TO TIMER VALUE EVERY OTHER FRAME
         BITA    #$01             ;
         BEQ     SQWK0            ;
         CLRB                     ; SET AMPLITUEE TO 0 EVERY OTHER FRAME
;
SQWK0    ASRB                     ; DIVIDE BY 2
         STB     REQ4             ; SET AMPLITUDES
         STB     REQ3             ;
         LDA     #%11111001       ; ENABLE CHANNEL B AND C TONE
         ANDA    REQ6             ;
         STA     REQ6             ;
         LDA     #$20             ; CALCULATE DESCENDING TONES
         SUBA    SQUAWK           ;
         LDB     #8               ; &lt;-- CHANGES OVERALL PITCH: SMALLER IS HIGHER
         MUL                      ;
         ADDD    #$0080           ; &lt;-- CHANGES OVERALL PITCH: SMALLER IS HIGHER
         STD     REQA             ;
         ADDD    #$0050           ; &lt;-- CHANGES DISTANCE BETWEEN LOWER AND HIGHER
         STD     REQ8             ;
;
SQWK1    BRA     SNUPDT           ;
;
;
;
;  FORTESS DISINTEGRATION SOUND HANDLER
;  ====================================
;        REQUIRES ALL CHANNELS
;
FRTSIZ   CMPA    #$01             ;  FIRST PASS ?
         BNE     SIZL0            ;  .
         CLR     SIZCNT           ;  CLEAR 'SIZCNT' ON FIRST PASS
;
;
SIZL0    LDB     SIZZLE           ;
         LDA     SIZCNT           ; IF SIZCNT IS CLEAR, CONTINUE WITH RAMP 
         BNE     SIZL2            ;
         CMPB    #$80             ; CHECK TO SEE IF AT CENTER OF RAMP (TOP)
         BNE     SIZL1            ;   IF NOT, CONTINUE WITH RAMP
         LDA     #$48             ; IF AT TOP OF RAMP, INITIALIZE SIZCNT TO
         STA     SIZCNT           ;    DELAY BEFORE STARTING DOWN.
;
SIZL1    INC     SIZZLE           ; NORMAL INCREMENT OF RAMP/TIMER VALUE
;
SIZL2    DEC     SIZCNT           ; DECREMENT SIZCNT
         BPL     SIZL3            ;   
         CLR     SIZCNT           ; LIMIT SIZCNT AT 0
;
SIZL3    LDA     #$FF             ; CLEAR ALL CHANNELS
         BSR     CLRSND           ;
         ASRB                     ; CALCULATE AMPLITUDE RAMP
         ASRB                     ;
         ASRB                     ;
         JSR     ABSB             ; ALWAYS POSITIVE THROUGH 256 VALUES
         CMPB    #$0F             ; CANNOT ALLOW TO BE &gt; 15
         BLS     SIZL4            ;
         DECB                     ; 16 BECOMES 15
;
SIZL4    STB     REQ5             ; SET AMPLITUDES 
         STB     REQ4             ;
         STB     REQ3             ;
         STB     REQ7             ; AND NOISE PERIOD
         LDD     #$0100           ; SET PITCHES:
         STD     REQC             ;
         SUBD    #$0070           ; RELETIVELY RANDOM PITCHES    
         STD     REQA             ;   (I THINK THEY ARE EIRRIE)  
         SUBD    #$0030           ;
         STD     REQ8             ;
         LDA     #%11001000       ; ENABLE ALL REGISTERS' TONES,
         ANDA    REQ6             ;   AND CHANNEL B AND C NOISE
         STA     REQ6             ;        
         BRA     SNDRST           ;
;
;
;
;  HANDLE BLASTER EXPLOSION
;  ========================
;        REQUIRES ALL CHANNELS
;
BEXPL    LDA     #$FF             ;  RESET SOUND GENERATOR
         BSR     CLRSND           ;  .
;
         LDA     #$01             ;  RESET EXPLOSION FLAG
         STA     EXPLO2           ;  .
;
         CLR     XACON            ;  ENABLE EXPLOSION
         LDA     #$80             ;  .
         STA     SATUS            ;  .
         LDU     #EXP02           ;  START BLASTER EXPLOSION
         JSR     EXPLOD           ;  .
;
BLUPDT   CLR     SHOOT            ;  RESET PENDING SOUND EFFECTS
         CLR     OUCH             ;  .
         CLR     SQUAWK           ;  .
         CLR     SIZZLE           ;  .
         CLR     EXPLO1           ;  .
;
;
SNUPDT   JSR     EXPLOD           ;  UPDATE EXPLOSION SOUND
;
         LDA     XACON            ;  ARE EXPLOSIONS DONE ?
         BNE     SNUP0            ;  .
;
SNDRST   CLR     EXPLO1           ;  .    RESET EXPLOSION FLAGS
         CLR     EXPLO2           ;  .    .
         CLR     SATUS            ;  .    .
;
SNUP0    PSHS    DP               ;  UPDATE SOUND GENERATOR
         LDA     #$D0             ;  .    SET 'DP' TO I/O
         TFR     A,DP             ;  .    .
         JSR     REQOUT           ;  .    UPDATE SOUND CHIP
         PULS    DP,PC            ;  .    .
;
;
;
;
;  CLEAR SOUND GENERATION PARAMETERS
;  =================================
;
;        ENTRY VALUES
;        ------------
;           A  = BIT 7 = CLEAR ALL SOUND REGISTERS
;                    2 = CLEAR CHANNEL 'C' ONLY
;                    1 = CLEAR CHANNEL 'B' ONLY
;                    0 = CLEAR CHANNEL 'A' ONLY
;
CLRSND   PSHS    D,X,U            ; SAVE ENTRY VALUES
         CLR     TSTAT            ; STOP SONG IF GOING
         TSTA                     ; IF A &lt; 0, THEN CLEAR ALL REGISTERS
         BPL     CLSND0           ;
         JSR     INTREQ           ; RESET ALL REGISTERS
         PULS    D,X,U,PC         ; RETURN
;
CLSND0   ANDA    #%00000111       ; LOWER THREE BITS SIGNIFICANT
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
CLSND1   LSRA                     ; CHECK FOR BITS SET
         BCC     CLSND2           ;
         CLR     B,X              ; CLEAR AMPLITUDE
         LSLB                     ; * 2 FOR OFFSET
         CLR     B,U              ; CLEAR PITCH (MSB)
         INCB                     ;   - NEXT -
         CLR     B,U              ; CLEAR PITCH (LSB)
         DECB                     ; FASTER THAN A PUSH AND PULL
         LSRB                     ;
;
CLSND2   DECB                     ; AGAIN FOR ALL 3 BITS (CHANNELS)
         BPL     CLSND1           ;
;
         PULS    D,X,U,PC         ; RESTORE ENTRY X REG AND RETURN
;
;
;
;
;  EXPLOSION PARAMETERS
;  ====================
;
EXP01    DB      $08,$FF,$00,$02  ;  GUARDIAN EXPLOSION
;
EXP02    DB      $3F,$00,$00,$01  ;  BLASTER EXPLOSION
;
;
;
;
;  OPENING TUNE
;  ============
;
;        TEMPO   60,6
ONE_OVER_FOUR = $0a; #noDoubleWarn 
DOT_ONE_OVER_FOUR= $0f; #noDoubleWarn 
ONE_OVER_EIGHT= $05; #noDoubleWarn 
;
WAGNER   DW      $FEE8            ; FADE CONTROL
         DW      $FEB6            ; VIBRATO CONTROL
         DB      A2 + $80
         DB      E3 + $80
         DB      A4,DOT_ONE_OVER_FOUR
         DB      A2 + $80
         DB      E3 + $80
         DB      E4,ONE_OVER_EIGHT
         DB      A2 + $80
         DB      E3 + $80
         DB      A4,ONE_OVER_FOUR
         DB      A2 + $80
         DB      E3 + $80
         DB      C5,ONE_OVER_FOUR*3
         DB      A2 + $80
         DB      E3 + $80
         DB      A4,ONE_OVER_FOUR*3 
         DB      C3 + $80
         DB      A3 + $80
         DB      C5,DOT_ONE_OVER_FOUR  
         DB      C3 + $80
         DB      A3 + $80
         DB      A4,ONE_OVER_EIGHT   
         DB      C3 + $80
         DB      A3 + $80
         DB      C5,ONE_OVER_FOUR  
         DB      C3 + $80
         DB      A3 + $80
         DB      E5,ONE_OVER_FOUR*3
         DB      C3 + $80
         DB      A3 + $80
         DB      C5,ONE_OVER_FOUR*3
         DB      G3 + $80
         DB      C3 + $80
         DB      E5,DOT_ONE_OVER_FOUR  
         DB      G3 + $80
         DB      C3 + $80
         DB      C5,ONE_OVER_EIGHT   
         DB      G3 + $80
         DB      C3 + $80
         DB      E5,ONE_OVER_FOUR  
         DB      G3 + $80
         DB      C3 + $80
         DB      G5,ONE_OVER_FOUR*3
         DB      G3 + $80
         DB      B3 + $80
         DB      G4,ONE_OVER_FOUR*3
         DB      C4 + $80
         DB      E3 + $80
         DB      C5,DOT_ONE_OVER_FOUR  
         DB      C4 + $80
         DB      E3 + $80
         DB      G4,ONE_OVER_EIGHT   
         DB      C4 + $80
         DB      E3 + $80
         DB      C5,ONE_OVER_FOUR          
         DB      C4 + $80
         DB      E3 + $80
         DB      E5,ONE_OVER_FOUR*10
         DB      E5,$80
;
;
;
;
;  CALL TO ARMS
;  ============
;
;        TEMPO   30,2
TRIPLE_TONE = $05 ; #noDoubleWarn 
ONE_OVER_FOUR = $0f; #noDoubleWarn 

;
GRDTUN   DW      $FDC3            ; FADE CONTROL
         DW      VIBENL           ; VIBRATO CONTROL
         DB      AS5 + $80
         DB      AS4 + $80
         DB      AS3,ONE_OVER_FOUR
         DB      AS5 + $80
         DB      AS4 + $80
         DB      AS3,TRIPLE_TONE
         DB      AS5 + $80
         DB      AS4 + $80
         DB      AS3,TRIPLE_TONE
         DB      AS5 + $80
         DB      AS4 + $80
         DB      AS3,TRIPLE_TONE
         DB      F6 + $80
         DB      F5 + $80
         DB      F4,$7F
         DB      F5,$80
;
;
;         IF      L.SND = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
