;
;
;         IF      L.KIL = OFF      ;-------------------------------------------
;         LIST    -L               ;--  KILLER  -------------------------------
;         ENDIF                    ;-------------------------------------------
;
;
;
;
;  KILLER SEQUENCE
;  ===============
;
         direct   $C8
;        =====   ===
;
KILLER   LDA     #$01             ;  INITIALIZE KILLER SEQUENCE
         STA     KILFLG           ;  .    SET KILLER SEQUENCE FLAG
;
         LDA     #$50             ;  .    SET FORTRESS INTENSITY
         STA     KLLINT           ;  .    .
;
         JSR     CLRGAM           ;  .    CLEAR GAME TABLES
;
;==========================================================================JJH
;        CLR     ABORT            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        CLR     LOCK             ;  .                               ======JJH
;==========================================================================JJH
;
         LDA     #$40             ;  .    SET-UP FOR SPIKERS TO SPLIT
         STA     GAMCMD           ;  .    .
;
         LDA     #$06             ;  .    SET KILLER HIT COUNTER
         STA     KILHIT           ;  .    .
;
         CLR     KILDED           ;  .    CLEAR KILLER DEAD FLAG
;
         LDD     #$0200           ;  .    SET KILLER 'X' DISPLACEMENT
         STD     KILXD            ;  .    .
;
         LDX     #KLGRD           ;  .    INITIALIZE GUARDIAN TABLE
         LDY     #GRDTBL          ;  .    .
         JSR     SMOVE            ;  .    .
;
         JSR     RANDOM           ;  .    SET-UP SPIKER RELEASE TIMER
         ANDA    #$1F             ;  .    .
         ORA     #$08             ;  .    .
         STA     SPKTIM           ;  .    .
;
         JSR     INTROD           ;  .    SET-UP ROADWAY LIMITS
         BRA     KILL10           ;  .    .
;
;
;
KLOCK1   JSR     LOCKUP           ;  LOCK-UP ON GAME SEQUENCE
;
;
KILL10   PSHS    DP               ;  SET 'DP' TO I/O
         JSR     WAIT             ;  WAIT FOR FRAME BOUNDARY
         JSR     CITDEL           ;  DRAW PLAY FIELD
;
         PULS    DP               ;  SET 'DP' TO RAM
         direct   $C8              ;  .
;
;
         LDD     KILXD            ;  EQUALIZE KILLER FRAGMENTS
         STD     GRD_00 + GRDXD   ;  .    RESET 'X' DISPLACEMENT
;
         LDU     #GRD_00 + GRDYD  ;  .    FRAGMENT #2
         LDX     #GRD_01 + GRDYD  ;  .    .
         LDA     #GRDLEN - 1      ;  .    .
         JSR     BLKMOV           ;  .    .
;
         LDX     #GRD_02 + GRDYD  ;  .    FRAGMENT #3
         LDA     #GRDLEN - 1      ;  .    .
         JSR     BLKMOV           ;  .    .
;
         LDX     #GRD_03 + GRDYD  ;  .    FRAGMENT #4
         LDA     #GRDLEN - 1      ;  .    .
         JSR     BLKMOV           ;  .    .
;
         CLR     TEMP1            ;  .    HAS ANY FRAGMENT BEEN HIT ?
         LDA     GRD_00 + GRDFLG  ;  .    .    FRAGMENT #1
         BPL     KILL20           ;  .    .    .
         ANDA    #$7F             ;  .    .    .    RESET FRAGMENT HIT FLAG
         STA     GRD_00 + GRDFLG  ;  .    .    .    .
         INC     TEMP1            ;  .    .    .    RECORD HIT
;
KILL20   LDA     GRD_01 + GRDFLG  ;  .    .    FRAGMENT #2
         BPL     KILL21           ;  .    .    .
         ANDA    #$7F             ;  .    .    .    RESET FRAGMENT HIT FLAG
         STA     GRD_01 + GRDFLG  ;  .    .    .    .
         INC     TEMP1            ;  .    .    .    RECORD HIT
;
KILL21   LDA     GRD_02 + GRDFLG  ;  .    .    FRAGMENT #3
         BPL     KILL22           ;  .    .    .
         ANDA    #$7F             ;  .    .    .    RESET FRAGMENT HIT FLAG
         STA     GRD_02 + GRDFLG  ;  .    .    .    .
         INC     TEMP1            ;  .    .    .    RECORD HIT
;
KILL22   LDA     GRD_03 + GRDFLG  ;  .    .    FRAGMENT #4
         BPL     KILL23           ;  .    .    .
         ANDA    #$7F             ;  .    .    .    RESET FRAGMENT HIT FLAG
         STA     GRD_03 + GRDFLG  ;  .    .    .    .
         INC     TEMP1            ;  .    .    .    RECORD HIT
;
;
;==========================================================================JJH
;KILL23  LDA     TEMP1            ;  CODE DELETED - REV. B CHANGES   ======JJH
;        LBEQ    KILL30           ;  .                               ======JJH
;==========================================================================JJH
;
;
;==========================================================================JJH
KILL23   LDA     TEMP1            ;  CODE ADDED - REV. B CHANGES     ======JJH
         BEQ     KILL30           ;  .                               ======JJH
;==========================================================================JJH
;
         DEC     KILHIT           ;  .    .    .    DECREMENT HIT COUNTER
;
         LDA     #$80             ;  .    .    .    SET 'OUCH' FLAG
         STA     OUCH             ;  .    .    .    .
         CLR     EXPLO1           ;  .    .    .    .    RESET EXPLOSION FLAG
         CLR     XACON            ;  .    .    .    .    .
;
         LDA     KILHIT           ;  .    .    .    SET NEW ENERGY LEVELS
         CMPA    #$02             ;  .    .    .    .    IS KILLER DEAD ?
         LBLT    KDYING           ;  .    .    .    .    .
;
         STA     GRD_00 + GRDERG  ;  .    .    .
         STA     GRD_01 + GRDERG  ;  .    .    .
         STA     GRD_02 + GRDERG  ;  .    .    .
         STA     GRD_03 + GRDERG  ;  .    .    .
;
;
KILL30   LDA     SPKTIM           ;  RELEASE A SPIKER THIS FRAME ?
         BNE     KILL90           ;  .    SPIKE TIMER = 0 ?
;
         LDA     FRAME            ;  .    RELEASE SPIKER AT TOP OF ARM SWING
         ANDA    #$18             ;  .    .
         CMPA    #$08             ;  .    .
         BEQ     KILL91           ;  .    .
         CMPA    #$10             ;  .    .
         BEQ     KILL91           ;  .    .
;
         LDU     #SPKTBL          ;  .    RELEASE SPIKER
         LDB     #GUARDS + 4      ;  .    .
;
KILL81   LDA     SPKFLG,U         ;  .    .    FIND ACTIVE SPIKER
         BEQ     KILL82           ;  .    .    .
;
         LEAU    SPKLEN,U         ;  .    .    TRY NEXT ENTRY
         DECB                     ;  .    .    .
         BNE     KILL81           ;  .    .    .
         BRA     KILL90           ;  .    .    .
;
KILL82   LDD     GRD_00 + GRDYW   ;  .    .    DROP INDICATED SPIKER
         ADDD    #$0A00           ;  .    .    .    SET 'Y' POSITION
         STD     SPKYW,U          ;  .    .    .    .
         LDD     GRD_00 + GRDXW   ;  .    .    .    SET 'X' POSITION
         STD     SPKXW,U          ;  .    .    .    .
         LDA     SPKYW,U          ;  .    .    .    SET 'YX' POSITION
         LDB     SPKXW,U          ;  .    .    .    .
         STD     SPKYX,U          ;  .    .    .    .
;
         LDA     #$01             ;  .    .    .    SET SPIKER FLAG
         STA     SPKFLG,U         ;  .    .    .    .
;
         JSR     RANDOM           ;  .    .    .    DIRECTED OR RANDOM SHOT ?
         BPL     KILL83           ;  .    .    .    .
;
         LDD     BLSTYX           ;  .    .    .    DIRECTED SPIKER SHOT
         SUBA    SPKYW,U          ;  .    .    .    .    CALCULATE DELTA 'YX'
         SUBB    SPKXW,U          ;  .    .    .    .    .
         JSR     CMPASS           ;  .    .    .    .    CALCULATE ANGLE
         SUBA    #$10             ;  .    .    .    .    .
         STA     SPKANG,U         ;  .    .    .    .    .
         BRA     KILL84           ;  .    .    .    .
;
KILL83   JSR     SWING            ;  .    .    .    RANDOM SPIKER SHOT
         ADDB    #$20             ;  .    .    .    .
         STB     SPKANG,U         ;  .    .    .    .
;
KILL84   LDA     #$50             ;  .    .    .    CALCULATE DISPLACEMENTS
         JSR     CALDSP           ;  .    .    .    .
;
         JSR     RANDOM           ;  .    .    .    RESET SPIKE TIMER
         ANDA    #$0F             ;  .    .    .    .
         ORA     #$04             ;  .    .    .    .
         STA     SPKTIM           ;  .    .    .    .
;
KILL90   DEC     SPKTIM           ;  DECREMENT SPIKE TIMER
;
;
KILL91   JSR     GBLAST           ;  HANDLE BLASTER GAME LOGIC
         JSR     GGUARD           ;  HANDLE KILLER GUARDIAN LOGIC
         JSR     GBULET           ;  HANDLE BULLET GAME LOGIC
         JSR     GSPIKE           ;  HANDLE SPIKER GAME LOGIC
         JSR     CBULT            ;  HANDLE BULLETS VS. BLASTER
         JSR     CGUARD           ;  HANDLE BLASTER VS. KILLER
         JSR     CSPIKE           ;  HANDLE BULLET VS. SPIKER COLLISIONS
         JSR     SOUND            ;  HANDLE TUNES AND SOUND-EFFECTS
         JSR     TAIL             ;  HANDLE TAIL-END LOGIC
;
;
         LDA     ABORT            ;  GAME ABORTED ?
         LBEQ    KILL10           ;  .
;
         LDA     EXPTMR           ;  SCORE ONE FOR KILLER - BLASTER JUST GOT IT
         CMPA    #$30             ;  .    WAIT FOR BLASTER EXPLOSION TO FINISH
         LBGE    KILL10           ;  .    .
;
;==========================================================================JJH
;        LDA     LOCK             ;  CODE DELETED - REV. B CHANGES   ======JJH
;        LBNE    KLOCK1           ;  .                               ======JJH
;        JMP     RSTLVL           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JSR     TAIL6A           ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDA     LOCK             ;  .                               ======JJH
         LBNE    KLOCK1           ;  .                               ======JJH
         JMP     RSTLV0           ;  .                               ======JJH
;==========================================================================JJH
;
;
;
;        KILLER DYING SEQUENCE
;        ---------------------
;
KDYING   LDA     #$7F             ;  SET-UP FOR KILLERS DEATH
         STA     EKLTMR           ;  .    SET EXPLOSION TIMERS
;
         LDX     #GRD_00 + GRDYW  ;  .    INITIATE FRAGMENT #1
         LDU     #EKL_00          ;  .    .
         LDA     #$08             ;  .    .
         JSR     EXPDSP           ;  .    .
;
;==========================================================================JJH
;        LDX     #GRD_00 + GRDYW  ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
         LDU     #EKL_01          ;  .    .
         LDA     #$10             ;  .    .
         JSR     EXPDSP           ;  .    .
;
;
;==========================================================================JJH
;        LDX     #GRD_00 + GRDYW  ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
         LDU     #EKL_02          ;  .    .
         LDA     #$18             ;  .    .
         JSR     EXPDSP           ;  .    .
;
;
;==========================================================================JJH
;        LDX     #GRD_00 + GRDYW  ;  CODE DELETED - REV. B CHANGES   ======JJH
;==========================================================================JJH
         LDU     #EKL_03          ;  .    .
         LDA     #$20             ;  .    .
         JSR     EXPDSP           ;  .    .
;
         LDA     #$20             ;  .    SET EXPLOSION SOUND FLAG
         STA     SIZZLE           ;  .    .
         BRA     KDIE1            ;  .    .
;
;
;
KLOCK2   JSR     LOCKUP           ;  LOCK-UP ON GAME SEQUENCE
;
;
KDIE1    LDA     EKLTMR           ;  KILLER IS DYING
         CMPA    #$30             ;  .    KILLER EXPLOSION DONE ALREADY ?
         LBLT    KDIE2            ;  .    .
         SUBA    #$02             ;  .    DECREMENT TIMER
         STA     EKLTMR           ;  .    .
;
         LDX     #PKLL01          ;  .    HANDLE FRAGMENT #1
         LDU     #RGRD1           ;  .    .
         LDY     #EKL_00          ;  .    .
         LDA     #$FE             ;  .    .
         JSR     MOVEXP           ;  .    .
;
         LDX     #PKLL12          ;  .    HANDLE FRAGMENT #2
         LDU     #RGRD2           ;  .    .
         LDY     #EKL_01          ;  .    .
         LDA     #$02             ;  .    .
         JSR     MOVEXP           ;  .    .
;
         LDX     #PKLL23          ;  .    HANDLE FRAGMENT #3
         LDU     #RGRD3           ;  .    .
         LDY     #EKL_02          ;  .    .
         LDA     #$FD             ;  .    .
         JSR     MOVEXP           ;  .    .
;
         LDX     #PKLL30          ;  .    HANDLE FRAGMENT #4
         LDU     #GRD_01          ;  .    .
         LDY     #EKL_03          ;  .    .
         LDA     #$01             ;  .    .
         JSR     MOVEXP           ;  .    .
;
         PSHS    DP               ;  .    SET 'DP' TO I/O
         direct   $D0              ;  .    .
;
         JSR     WAIT             ;  .    WAIT FOR FRAME BOUNDARY
         JSR     CITDEL           ;  .    DRAW PLAY FIELD
;
         LDA     EKLTMR           ;  .    SET EXPLOSION INTENSITY
         JSR     INTENS           ;  .    .
;
;
;==========================================================================JJH
;        LDD     EKL_00 + EKLYX   ;  CODE DELETED - REV. B CHANGES   ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD1           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     GRD_00 + GRDSIZ  ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
;        LDD     EKL_01 + EKLYX   ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD2           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     GRD_00 + GRDSIZ  ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
;        LDD     EKL_02 + EKLYX   ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #RGRD3           ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     GRD_00 + GRDSIZ  ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;                                                                    ======JJH
;        LDD     EKL_03 + EKLYX   ;  .                               ======JJH
;        JSR     POSITD           ;  .                               ======JJH
;        LDX     #GRD_01          ;  .                               ======JJH
;        LDA     X+               ;  .                               ======JJH
;        LDB     GRD_00 + GRDSIZ  ;  .                               ======JJH
;        JSR     TDUFFY           ;  .                               ======JJH
;==========================================================================JJH
;
;
;==========================================================================JJH
         LDY     EKL_00 + EKLYX   ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDX     #RGRD1           ;  .                               ======JJH
         LDB     GRD_00 + GRDSIZ  ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;                                                                    ======JJH
         LDY     EKL_01 + EKLYX   ;  .                               ======JJH
         LDX     #RGRD2           ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;                                                                    ======JJH
         LDY     EKL_02 + EKLYX   ;  .                               ======JJH
         LDX     #RGRD3           ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;                                                                    ======JJH
         LDY     EKL_03 + EKLYX   ;  .                               ======JJH
         LDX     #GRD_01          ;  .                               ======JJH
         JSR     DFSHRT           ;  .                               ======JJH
;==========================================================================JJH
;
;
         BRA     KDIE3            ;  .    .
;
;
KDIE2    PSHS    DP               ;  .    SET 'DP' TO I/O
         direct   $D0              ;  .    .
;
         JSR     WAIT             ;  .    WAIT FOR FRAME BOUNDARY
         JSR     CITDEL           ;  .    DRAW PLAY FIELD
;
KDIE3    PULS    DP               ;  .    SET 'DP' TO RAM
         direct   $C8              ;  .    .
;
         CLR     SHOOT            ;  .    CLEAR MISC. SOUND FLAGS
         CLR     OUCH             ;  .    .
;
         JSR     GBLAST           ;  .    HANDLE BLASTER GAME LOGIC
         JSR     GBULET           ;  .    HANDLE BULLET GAME LOGIC
         JSR     GSPIKE           ;  .    HANDLE SPIKER GAME LOGIC
         JSR     CBULT            ;  .    HANDLE BULLET VS. BLASTER COLLISIONS
         JSR     CSPIKE           ;  .    HANDLE BULLET VS. SPIKER COLLISIONS
         JSR     SOUND            ;  .    HANDLE SOUND EFFECTS
;
         LDA     FRAME            ;  .    RAMP FORTRESS INTENSITY
         ANDA    #$03             ;  .    .
         BNE     KDIE5            ;  .    .
         LDA     SIZZLE           ;  .    .    RAMP UP OR DOWN ?
         BMI     KDIE4            ;  .    .    .
         BEQ     KDIE4            ;  .    .    .
;
         INC     KLLINT           ;  .    .    RAMP INTENSITY UP
         BVC     KDIE5            ;  .    .    .
         LDA     #$7F             ;  .    .    .    INTENSITY LIMITED TO $7F
         STA     KLLINT           ;  .    .    .    .
         BRA     KDIE5            ;  .    .    .    .
;
KDIE4    LDA     KLLINT           ;  .    .    RAMP INTENSITY DOWN
         BEQ     KDIE5            ;  .    .    .
         DEC     KLLINT           ;  .    .    .
;
KDIE5    JSR     TAIL             ;  .    HANDLE TAIL-END LOGIC
;
         LDA     KLLINT           ;  .    END OF KILLER EXPLOSION SEQUENCE ?
         CMPA    #$20             ;  .    .
         LBGT    KDIE1            ;  .    .
;
;
;
         LDA     ABORT            ;  KILLER SEQUENCE DONE !
         BEQ     KDEAD            ;  .    GAME ABORTED ?
;
;==========================================================================JJH
;        LDA     LOCK             ;  CODE DELETED - REV. B CHANGES   ======JJH
;        LBNE    KLOCK2           ;  .                               ======JJH
;        JMP     RSTLVL           ;  .                               ======JJH
;==========================================================================JJH
;
;==========================================================================JJH
         JSR     TAIL6A           ;  CODE ADDED - REV. B CHANGES     ======JJH
         LDA     LOCK             ;  .                               ======JJH
         LBNE    KLOCK2           ;  .                               ======JJH
         JMP     RSTLV0           ;  .                               ======JJH
;==========================================================================JJH
;
;
;
KDEAD    JSR     INTREQ           ;  CLEAR SOUND REGISTERS
;
         LDX     #PLEVEL          ;  BUMP GAME LEVEL FOR THIS PLAYER
         LDA     ACTPLY           ;  .
         LDX     A,X              ;  .
         LDA     #$01             ;  .
         JSR     BYTADD           ;  .
;
         JSR     ACTPTR           ;  BUMP BLASTER COUNTER FOR THIS PLAYER
         INC     6,Y              ;  .
;
         JSR     CLRGAM           ;  START AT NEXT LEVEL
         CLR     LFLAG            ;  .    RESET LEVEL FLAG
         JMP     SEQNCR           ;  .
;
;
;
KLGRD    DB      (KEGRD - *) - 1  ;  KILLER GUARDIAN
         DB      $19
         DW      $0000,$0200,$E000,$0000,$E000
         DB      $00,$00,$00,$07
;
         DB      $21
         DW      $0000,$0000,$0000,$0000,$0000
         DB      $00,$00,$00,$00
;
         DB      $29
         DW      $0000,$0000,$0000,$0000,$0000
         DB      $00,$00,$00,$00
;
         DB      $31
         DW      $0000,$0000,$0000,$0000,$0000
         DB      $00,$00,$00,$00
KEGRD    EQU     *
;
;
;         IF      L.KIL = OFF      ;-------------------------------------------
;         LIST    *                ;-------------------------------------------
;         ENDIF                    ;-------------------------------------------
