**      This is an assembly source of the monitor ROM in the Vectrex.
*
*       At this point I do not remember if I typed this in by hand
*       from a paper listing, or had it e-mailed to me.  Probably
*       the former, considering the aftertaste it left.


* VERSION 4/17/82  5:00 pm  SMN
*
*
*
* CRYPITIC THOUGHT "ANY PROGRAMMING IS A CHANGE" PAUL NEWELL
*       (crypitic update: "Second rule of management--They don't believe the
*                                                    first rule" JS/ES)
*       another cryptic thought : "The spanish inqistion is in the hands of
*                                 its enemys!!!"  EAP
*
*                                "AND TELL A FRIEND"  GK
*
*                                "They shoot horses, don't they?"
*
*                                "A 'K' a day keeps the Smith's away." MI
*
*                       "When in dought run about scream and shout!!" LC
*
*                       "Nuts!" Brigider General McAlphy
*
*
*
*
*       *******************************************************************
*
*  THIS RUM IS FOR USE WITH THE FINAL COPY OF THE PROGRAM THIS IS THE ONE
*  THAT IS ON THE FINAL CHIP AND SHOULD BE USED THUSLY.
*
*       *******************************************************************
*
*
*
*       * * HERE WE GO ON INTERSYSTEMS! * * *

*       * * RUN-TIME ROM for HOME-ARCADE

*       AUTHOR UNKNOWN, TRADITIONAL

        ORG     $C800   ;RAM
REG0    RMB     1       ;MIRROR SOUND CHIP REGS FINE TUNE -A- 8 BIT
REG1    RMB     1       ;COARSE TUNE -A- 4 BIT
REG2    RMB     1       ;FINE TUNE -B- 8 BIT
REG3    RMB     1       ;COARSE TUNE -B- 4 BIT
REG4    RMB     1       ;FINE TUNE -C-
REG5    RMB     1       ;COARSE TUNE -C-
REG6    RMB     1       ;NOISE PER, 5 BIT
REG7    RMB     1       ;ENABLE BAR- IN BAR/OUT: IOA,IOB
*                       NOISE BAR: C,B,A TONE BAR: C,B,A
REG8    RMB     1       ;AMPL -A-, 4 BIT , 5TH BIT OVERRIDE IF=1
REG9    RMB     1       ;AMPLITUDE -B-  " "
REGA    RMB     1       ;AMPL -C-
REGB    RMB     1       ;FINE TUNE ENVELOPE PER, 8 BITS
REGC    RMB     1       ;COARSE TUNE ENVELOPE PER, 8 BIT
REGD    RMB     1       ;ENVELOPE TYPE, 4 BIT- CONT,ATT,ALT,HOLD
REGE    RMB     1       ;PORT A I/O


TRIGGR  RMB     2       ;BUTTONS INPUT TO PSG- NEW, LAST
HEDGES  RMB     1       ;POS EDGE, 1 BIT PER BUTTON
KEY0    RMB     1       ;POS EDGE, 1 BYTE PER BUTTON, POS LOG
KEY1    RMB     1
KEY2    RMB     1
KEY3    RMB     1
KEY4    RMB     1
KEY5    RMB     1
KEY6    RMB     1
KEY7    RMB     1

POTRES  RMB     1       ;ACCURACY REQ'D FOR POT READ, LESS IS FASTER
*                       ;$40=1 BIT,$20=2 BITS,$01=7 BITS,$00=8 BITS
POT0    RMB     1       ;VALUE READ FROM POTS
POT1    RMB     1
POT2    RMB     1
POT3    RMB     1
DPOT0   RMB     1       ;DELTA FROM LAST TEST
DPOT1   RMB     1
DPOT2   RMB     1
DPOT3   RMB     1

LIST    RMB     1       ;# OF VECTORS IN PRESENT CHART
ZGO     RMB     1       ;IF NONZERO, CAUSES 'ZEROIT' CALL AFTER VECTOR ROUTINES
FRAME   RMB     2       ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED
TENSTY  RMB     1       ;WAST INSTENITY WEVEL

DWELL   RMB     1       ;DOT DWELL TIME, SET IN INITMSC OR AFTER
DASH    RMB     1       ;PATTERN FOR DASHED VECTORS


SIZRAS  RMB     2       ;FOR RASTER - CONTROLS SLEW RATE
*                       ;SIZE,SIZE+1=Y RATE,X RATE
MESAGE  RMB     2       ;START OF STRING


X0      RMB     1
X1      RMB     1       ;INTERVAL TIMERS
X2      RMB     1       ;COUNT DOWN TO 0 PER FRAME IF 'DEKR' CALLED
X3      RMB     1
X4      RMB     1
X5      RMB     1

ABSY    RMB     1       ;FOR COMPAS ROUTINE
ABSX    RMB     1       ;"
ANGLE   RMB     1       ;"
SINE    RMB     2       ;VALUE,OVERFLOW
COSINE  RMB     2
LEG     RMB     1
LAG     RMB     1

XMSEC   RMB     2       ;REFRESH VALUE, INITMSC SETS TO MSEC20

MSEC20  EQU     $3075   ;LO BYTE, HI
MSEC25  EQU     $7C92
MSEC30  EQU     $C8AF

* - - - - - REGS FOR TUNE PLAYING AND SOUND EFFECTS - - - - -

REQ0    RMB     1       ;ENVELOPE TYPE - FOR REQOUT ROUTINE
REQ1    RMB     1       ;TUNE ENVELOPE- MSB (INVERTED ORDER OF REG0-D)
REQ2    RMB     1       ;"    "       LSB
REQ3    RMB     1       ;LEVEL- C
REQ4    RMB     1       ;LEVEL- B
REQ5    RMB     1       ;LEVEL- A
REQ6    RMB     1       ;ENABLES- TONES / NOISE / I-O
REQ7    RMB     1       ;TUNE NOISE- 5 BIT
REQ8    RMB     1       ;TUNE C- MSB
QEQ9    RMB     1       ;"   "  LSB
REQA    RMB     1       ;TUNE B- MSB
REQB    RMB     1       ;"   "  LSB
REQC    RMB     1       ;TUNE A- MSB
REQD    RMB     1       ;"  "  LSB

CHCF    EQU     REQ8    ;CHANNEL C FREQUENCY
CHBF    EQU     REQA
CHAF    EQU     REQC
NOISEF  EQU     REQ7    ;NOISE FREQ
ENVELF  EQU     REQ1    ;ENVELOPE FREQ

CHCV    EQU     REQ3    ;CHANNEL C VOLUME
CHBV    EQU     REQ4
CHAV    EQU     REQ5

SENABL  EQU     REQ6    ;SOUND ENABLE

DOREMI  RMB     2       ;BASE TABLE 2OR NOTES USUALLY=NOTES
FADE    RMB     2       ;FOR TUNE PLAYER USE
VIBE    RMB     2
TUNE    RMB     2
NEWGEN  RMB     1
TSTAT   RMB     1
RESTC   RMB     1
RATEA   RMB     1
VIBA    RMB     1
RATEB   RMB     1       ;VIBRATO
VIBB    RMB     1
RATEC   RMB     1
VIBC    RMB     1
FADEA   RMB     1
FADEB   RMB     1
FADEC   RMB     1
TONEA   RMB     2       ;FREQ BEFORE VIBE
TONEB   RMB     2
TONEC   RMB     2

* - - - - - REGS FOR SOUND EFFECTS - - - - -

SATUS   RMB     1       ;GAME-SOUNDS INTERFACE
LATUS   RMB     1       ;LAST 'SATUS' VALUE
XATUS   RMB     1       ;", EXPLOSION TYPE
GAP     RMB     1       ;TIMES HOLD IN BACKGROUND SOUND
B1FREQ  RMB     2
B2FREQ  RMB     2
F1FREQ  RMB     2
FEAST   RMB     1       ;FIRING STATE COUNTER
PEDGE   RMB     1       ;POSITIVE EDGE OF 'SATUS'
NEDGE   RMB     1       ;NEGATIVE EDGE OF 'SATUS'
K1FREQ  RMB     2       ;BACKGROUND FREQ 1
BACON   RMB     1       ;" SEQUENCER
XACON   RMB     1       ;EXPLO SEQ
SPEKT   RMB     1       ;EXPL SPECTR

PLAYRZ  RMB     1       ;# PLAYERS IN GAME
GAMZ    RMB     1       ;GAME # OPTION

SEED    RMB     2       ;POINTER TO 3 BYTE RANDOM #, USUALLY IS RANCID
RANCID  RMB     3


LASRAM  EQU     *


RAMMES  EQU     $CA00

        ORG     $CBEA

STACK   RMB     1
HEIGH   RMB     7       ;TITLE PAGE HIGH SCORE
INMI    RMB     0
ISWI3   RMB     0
ISWI2   RMB     3
IFIRQ   RMB     3
IIRQ    RMB     3
ISWI    RMB     3
JRES    RMB     2


        ORG     $D000   ;I/O

BPORT   RMB     1
APORT   RMB     1
BPORTD  RMB     1
APORTD  RMB     1
T1LOLC  RMB     1
T1HOC   RMB     1
T1LOL   RMB     1
T1HOL   RMB     1
T2LOLC  RMB     1
T2HOC   RMB     1
SR      RMB     1
ACR     RMB     1
PPCR    RMB     1
IFR     RMB     1
IER     RMB     1
ORAIRA  RMB     1


DAC     EQU     APORT   ;FOR HUMAN INTERFACE
PORT    EQU     BPORT   ;MAIN CONTROL PORT
ZERO    EQU     $CC     ;CODE TO PCR ZERO INTEGRATORS
UNZERO  EQU     $CE     ;CORE FOR RELEASE HOLD ZERO
SCAL1X  EQU     $7F     ;TIMING PARAMETERS FOR VECTOR WRITE
SCAL2X  EQU     $FF
CARTS   EQU     $0      ;ADDRESS OF EXTERNAL ROM PACK
ROMS    EQU     $F000   ;ADDRESS OF ON-BOARD ROM
INHOUS  EQU     $E000

* - - - - - - RESET VECTORS - - - - - - -

        ORG     $FFF2
        FDB     ISWI3   ;RAM INDIRECT VECTORS
        FDB     ISWI2   ;NMI AND SWI HANDLED BY -MAID-
        FDB     IFIRQ
        FDB     IIRQ
        FDB     ISWI    ;NOT IN MAID
        FDB     ISWI    ;NOT IN MAID
        FDB     POWER
* - - - - - - PROGRAM MATERIAL - - - - - -

        ORG     ROMS
WARM
POWER   LDS     #STACK  ;AT RESET
        JSR     INITALL ;BRING UP HWARE, BRANCH IF WARM <----
        LDD     #$7321  ;CHECK WARM OR CLOD BOOT
        CMPD    JRES
        BEQ     WARME
        STD     JRES    ;START COLD BOOT. CONSISTS OF:
        INC     LEG     ;1) PLAY STARTUP TUNE 'VCTRX'
*                       ;   DISPLAY START MESSAGE
*                       ;2) TIMEOUT 13 SEC INTO WARM BOOT
        LDX     #HEIGH
        JSR     SCLR    ;CLR HI SKOR IF COLD

CLOD    JSR     DPRAM   ;SOUND
        direct   $C8
        LDD     FRAME
        CMPD    #$0101  ;WAIT FOR START OF TUNE
        BNE     MFIZZ
        STB     TSTAT   ;(B MUST BE POS)
MFIZZ   ASRB
        ANDB    #3
        LDX     #DABLE
        LDB     B,X
        STB     DASH
        LDB     #2
        STB     ZGO     ;PREPARE DASH LOOP
        LDU     #VCTRX  ;WILL 3TART IF TSTAT=POS NZRO
        JSR     REPLAY
        direct   $D0

DONO    JSR     FRAM20
        JSR     REQOUT
        JSR     INTMAX
        LDA     FRAME+1 ;BLINK TITLE
        LDU     #MCOLD
        BITA    #$20
        BEQ     ONBABY
        LEAU    12,U
ONBABY  JSR     TEXSIZ
        LDX     #DOSH   ;DISPLAY TITLE BLOCK
RETIRE  JSR     POSIT2
        LDA     #3
        JSR     DASHEL
        DEC     ZGO
        BNE     RETIRE
        LDA     FRAME
        CMPA    #1      ;FOR 10 SEC TIMEOUT
        BLS     CLOD

WARME   direct   $C8
        JSR     DPRAM
        LDA     #$CC
        STA     DASH
        LDD     #SECRET
        STD     COSINE  ;FOR LEGAL
        CLR     FRAME
        CLR     FRAME+1
        LDU     #CARTS
        LDX     #SECRET
        LDB     #$0B    ;IGNORE DATE, WHERE B=5,4,3,2
ESCAPE  LDA     ,U+    ;TEST FOR CART PRESENT
        CMPA    ,X+
        BEQ     WARMER
        CMPB    #1
        BEQ     REKKED
        CMPB    #5
        BLS     WARMER
REKKED  LDU     #INHOUS
        BRA     WARMEST

WARMER  DECB
        BNE     ESCAPE
        STB     COSINE  ;INDICATE CART SELECTED
        STB     COSINE+1
WARMEST INC     TSTAT   ;PICK UP TUNE START
        STU     SINE
        LDU     0,U
WARMLY  JSR     DPRAM   ;GAME TITLE LOOP
        LDD     #$F848  ;SET LEAGL SIZ
        STD     SIZRAS
        JSR     REPLAY
        JSR     FRAM20
        JSR     REQOUT
        JSR     INTMAX
        LDD     #$C0C0
        LDU     >COSINE
        JSR     POSDRAS ;DISPLAY LEGAL MESS
        LDA     >LEG
        BNE     NEIGH   ;NOT ON COLD BOOT
        DECA
        LDU     #HEIGH
        STA     6,U     ;BE SURE DELIM IN PLACE
        LDD     #$68D0  ;START HIGH SCORE DISPLAY
        JSR     POSDRAS
NEIGH   LDU     >SINE   ;GAME TEXT
        LEAU    2,U
        JSR     TEXSIZ
        LDA     >TSTAT  ;WAIT FOR TUNE END
        BNE     WARMLY
        LDX     >FRAME  ;WAIT AT LEAST 2.5 SEC
        CMPX    #125
        BLS     WARMLY
        JMP     1,U     ;OFF TO CART OR SCHWEEPEH

DOSH    FDB     $40D6   ;POSITION OF BLOCK
        FDB     $0056,$8100,$00A9,$7E00 ;(DASHED LINES)

        FDB     $39DC   ;SMALLER DASHES, OPPOSTIEE DIR
        FDB     $8E00,$004A,$7200,$00B6

DABLE   FCB     $E0,$38,$0E,$03 ;FOR MOVIE PATTERN
SECRET  FCB     $67,' GCE 1982',$80

MCOLD   FDB     $F160,$27CF     ;DUBL INTENSITY VECTREX
        FCB     'VECTREX',$80
MBOLD   FDB     $F360,$26CF
        FCB     'VECTREX',$80

SACRET  FDB     $FC60
        FDB     $DFE9   ;SECND
        FCB     'GCE',$80

        FDB     $FC38
        FDB     $CCD1
        FCB     'ENTERTAINING',$80

        FDB     $F338
        FDB     $BCDC
        FCB     'NEW IDEAS',$80
        FCB     0       ;END OF TEXT PACKET

INITPIA direct   $D0     ;DO ONCE <----
        BSR     DPIO
        LDD     #$9FFF  ;INIT PIA
        STD     BPORTD
        LDD     #$0100
        STD     BPORT
        LDD     #$9800+SCAL1X   ;SR=SHIFT OUT FAST,T1=ONE SHOT,T2=TIMED INTERRUPT
        STA     ACR     ;SETUP TIMERS
        STB     T1LOLC  ;VEC TIM
        JSR     ZEROIT
        BRA     STAR20  ;RETURNS FROM THERE

        direct   $C8

INITMSC BSR     DPRAM  ; OTHER STUFF TO INIT IF YOU WANT <----
        LDB     # GAMZ-REG0
        LDX     #REG0
        JSR     CLRSOM
        LDD     #RANCID
        STD     SEED
LAHK    INC     RANCID  ;UNLOCK RANDOM
        BEQ     LAHK
        LDA     #$05
        STA     DWELL
        LDD     #MSEC20
        STD     XMSEC   ;SETUP FOR 20 MSEC FRAME RATE
        LDD     #$0103
        STD     DPOT0
        LDD     #$0507  ;SETUP FOR PBANG
        STD     DPOT2
        RTS

        direct   $D0

INITALL BSR     INITMSC ;FOR LAZY INIT <----
        BSR     INITPIA
        JMP     INITPSG

FRAM20  LDX     FRAME   ;INCR FRAME (16 BIT), WAIT FOR 'XMSEC' FRAME EGDE <----
        LEAX    1,X
        STX     FRAME
        BSR     DPIO
        LDA     #$20
OCCULT  BITA    IFR
        BEQ     OCCULT
STAR20  LDD     XMSEC   ;LOW BYTE,HI- INIT TIME <----
        STD     T2LOLC  ;RESET IFR BIT 5,START FRAME TIMER
        JMP     DEFLOK  ;KEEP POWER UP, RETURN FROM THERE


DPIO    LDA     #$D0    ;SET DP REG TO $D0 <----
        TFR     A,DP
        RTS

DPRAM   LDA     #$C8    ;SET DP REG TO $C8
        TFR     A,DP
        RTS

ENPUT   ANDA    TRIGGR  ;ENTRY FOR 'INPUTT' WITH UN-BOUNCE MASK <----
        STA     TRIGGR

INPUT   LDX     #KEY0   ;READ KEYS FROM PSG <----
        LDA     -3,X    ;SAVE IN 'TRIGGR' NEG LOG
        STA     -2,X    ;SAVE LAST READING IN 'TRIGGR'+1
        LDA     #$0E    ;EDGE DETECT, POS LOG IN 'HEDGES'
        STA     APORT   ;FOR EASY TEST OF KEY EDGE, TST KEY0 THRU KEY7
        LDD     #$1901  ;NON ZERO EDGE IS VALID
        STA     BPORT
        NOP
        STB     BPORT   ;SETUP ADDR
        CLR     APORTD  ;INPUT TO PIA
        LDD     #$0901
        STA     BPORT   ;READ FROM PSG
        NOP
        LDA     APORT
        COMA            ;MAKE POS LOG
        STA     -3,X    ;PUT IN MEMRY
        STB     BPORT   ;COMPLETE READ CYCLE
        LDB     #$FF
        STB     APORTD  ;BACK TO OUTPUT
        COMA            ;0= KEY PRESSED AFTER COMA
        ORA     -2,X    ;BEGIN POS EDGE DEBOUNCE
        COMA
        STA     -1,X    ;DEEGDED VALUE
        PSHS    A
        LDB     #1      ;LOAD 8 BYTES FOR EASY LOGIC
IENPUT  TFR     B,A
        ANDA    ,S
        STA     ,X+
        ASLB
        BNE     IENPUT
        PULS    A,PC    ;FINISH KEY INPUTz

POTS4   DEC     LIST    ;READ UP TO 4 POTS, SAR STYLE <----

PBANG4  LDX     #DPOT0  ;QUICK READ UP TO 4 POTS <----
PANG    LDA     ,X+    ;ENABLE EACH READ WITH NONZERO VALUE IN DPOT0-3
        BNE     PBONG
PBRONG  CMPX    #DPOT3+1
        BNE     PANG
        CLR     ,X     ;'LIST' WAS USED FOR BANG/SAR FLAG
        LDA     #1
        STA     PORT    ;FOR CLEAN S/H LATER
        RTS

PBONG   STA     PORT    ;6UX CODE FROM DPOT0-3
        CLR     DAC
        DEC     PORT
        LDB     #$60
PBEST   INCB
        BPL     PBEST
        LDA     LIST    ;USE TO FLAG BANG OR SAR
        BMI     PITS    ;GO TO SAR
        LDA     #$20
        INC     PORT
        BITA    PORT    ;FIRST TEST > OR < 0
        BEQ     PMIN
        LDB     #$40    ;PLUS: CHECK MID-RANGE
        STB     DAC
        BITA    PORT
        BNE     PSTIF   ;VALID IF ABOVE MIDDLE POS VALUE
        BRA     PZRO

PMIN    LDB     #$C0    ;MINUS
        STB     DAC
        BITA    PORT
        BEQ     PSTIF
PZRO    CLRB
PSTIF   STB     -5,X    ;PUTS IN POT0-3
        BRA     PBRONG  ;END OF ROUTINE - - - - --

PAST    TFR     B,A     ;FIRST LINE OF SAR, ENTER BELOW
        ORA     DAC
        STA     DAC
PITS    LDA     #$20    ;BEGIN SAR - - - - - -
        BITA    PORT    ;TEST COMP
        BNE     PARTS
        TFR     B,A
        EORA    DAC
        STA     DAC
PARTS   LSRB
        CMPB    POTRES
        BNE     PAST
        LDB     DAC     ;SAVE AND GO ON
        BRA     PSTIF   ;END OF SAR FOR 'POTS4'


*                       ;WRITES B DATA TO A ADDRESS OF AY3-ETC <----
PSGX    LDX     #REG0   ;USES X REG. A AND X REGS DO NOT CHANGE
*                       ;USE THIS ENTRY IF X ALREADY LOADED <----
PSG     STB     A,X     ;STORE IN MIRROR RAM
        STA     APORT
        LDA     #$19    ;CODE FOR ADDR LATCH
        STA     BPORT
        LDA     #1
        STA     BPORT   ;LATCH ADDRESS TO PSG
        LDA     APORT   ;GET A REG BACK
        STB     APORT
        LDB     #$11
        STB     BPORT   ;LATCH DATA
        LDB     #1
        STB     BPORT
        RTS             ;EXITS WITH ADDRESS STILL IN 'A'


INITPSG LDD     #$0E00  ;INIT    SOUND CHIP ALL REGS=0 <----
SINIT   BSR     PSGX            A=ADDRESS, B=DATA, WILL MIRROR
        DECA
        BPL     SINIT
        JMP     IREQ

PSGLUP  LDX     #REG0   ;SENDS STREAM TO PSG, U REG POINTER <----
        BRA     PSGLPU  ;FORMAT- PSG ADRS, PSG DATA ETC.

PSGULP  BSR     PSG     ;DELIMITER IS PSG ADRS= NEGATIVE
PSGLPU  LDD     ,U++   ;ENTER IF X REG=#REG0 <----
        BPL     PSGULP
        RTS

REQOUT  LDX     #REG0   ;SENDS REQ DATA TO PSG <----
        LDU     #REQ0   ;COMPARES FIRST WITH REG
        LDA     #$0D    ;SENDS OUT 14 REGS
REQOUR  LDB     ,U+    ;STORE INVERTED FOR SANITY
        CMPB    A,X     ;CALL AFTER ALL PSG FIDDLING
        BEQ     REQNOT
        BSR     PSG
REQNOT  DECA
        BPL     REQOUR
        RTS


* - - - - - - - VECTOR WRITING ROUTINES - - - - - - - - - - - --





INT1Q   LDA     #$1F    ;SET INTENSITY TO QTR LEVEL <----
        BRA     INTENS

INTMID  LDA     #$3F    ;SET INTENSITY TO HALF LEVEL <----
        BRA     INTENS

INT3Q   LDA     #$5F    ;SET TO 3/4 LEVEL <----
        BRA     INTENS

INTMAX  LDA     #$7F    ;SET INTENS TO MAX LEVEL <----
INTENS  STA     DAC     ;SET INTENS TO 'A' LEVEL- USE 0-7F <----
        STA     TENSTY
        LDD     #$0504
        STA     PORT
        STB     PORT
        STB     PORT    ;NOP
        LDB     #$01
        STB     PORT    ;LEAVE 4052 AT ADDRESS 0
        RTS

DOTTIM  STB     DWELL   ;ONE DOT, IF B HAS HOLD TIME <----
DOTX    LDD     ,X++    ;DRAWS ONE DOT INDEXED BY X <----
DOTAB   BSR     POSITN  ;DRAWS ONE DOT ACCORDING TO A,B <----
DOT     LDA     #$FF    ;TURNS VIDEO ON FOR DOT <----
        STA     SR
        LDB     DWELL
DADOT   DECB
        BNE     DADOT   ;HOLD FOR INTENSITY
        CLR     SR
        RTS

        DEC     LIST
DIFDOT  BSR     DOTX    ;2 BYTE/ENTRY DOT PACKAGES, USES 'LIST' <----
        LDA     LIST
        BNE     DIFDOT-3
        BRA     ZEROIT

DOTPAK  LDA     ,X+    ;DRAWS DOT, USES PACKET FORMAT <----
        BGT     ZEROIT  ;ENDS THERE
DOKPAT  BSR     DOTX
        BRA     DOTPAK  ;FINISHED WHEN CONTROL BYTE=01


DEFLOK  LDX     #FALWEL ;CALL TO KEEP POWER ON
        BSR     POSIT2  ;SUPER LONG SATURATED KEEP ALIVE PULSE
        JSR     ZERO_
        BSR     POSITX
        BRA     ZEROIT  ;ENDING


POSWID  LDB     #SCAL1X ;REL POS IF X REG POINTS TO 16 BIT DATA (WIDE) <----
        STB     T1LOLC  ;FORCES TO 1X SCALE
        LDA     ,X
        LDB     2,X
        BRA     POSITN

POSITD  STA     DAC     ;REL POS IF IN D REG, CHG TO NORMAL SCALE <----
        PSHS    D
        LDA     #SCAL1X ;DEFINED IN BEGINNING
        STA     T1LOLC
        CLR     PORT
        BRA     POOSI

POSIT2  LDB     #SCAL2X ;REL POSITION VECTORS- 2X SCALE
        BRA     POSITB

POSIT1  LDB     #SCAL1X ;NORMAL SCALE <----
POSITB  STB     T1LOLC  ;IF 'B' HAS TIMER LENGTH <----
POSITX  LDD     ,X++   ;RELATIVE POS VECTOR- IF TIMER SET <----
POSITN  STA     DAC     ;IF ACCUMS AND TIMER ARE LOADED <----
        CLR     PORT    ;BEGIN SAMPLE
        PSHS    D
POOSI   LDA     #UNZERO
        STA     PPCR
        CLR     SR      ;SURE VID OFF
        INC     PORT    ;Y LOADED
        STB     DAC     ;X VALUE
        CLR     T1HOC   ;START RAMP

        PULS    D       ;7 GET Y,X BACK TO FIGURE DELAY
        JSR     ABSVAL  ;37
        STB     -1,S    ;5
        ORA     -1,S    ;5 OR TOGETHER
        LDB     #$40    ;2
        CMPA    #$40    ;2
        BLS     MEDIO   ;3 IF VOLTAGES LOW SKIP DELAY
        CMPA    #$64    ;2
        BLS     FASTO   ;3
        LDA     #8      ;2
        BRA     TEDIO   ;3

FASTO   LDA     #4      ;2

TEDIO   BITB    IFR     ;2 ENDING DELAY FOR VOLTAGES OVER $40
        BEQ     TEDIO   ;3
FARM    DECA            ;2
        BNE     FARM    ;3
        RTS             ;5

MEDIO   BITB    IFR     ;4
        BEQ     MEDIO   ;3
        RTS             ;IF NO EXTRA DELAY-


ZERO_DP JSR     DPIO    ;LEAD IN TO ZEROIT, SETS DP TO I/O <----
        BRA     ZEROIT

ZEGO    LDA     ZGO     ;CAUSE ZEROIT IF 'ZGO' NONZERO <----
        BEQ     ZBONG
ZEROIT  LDD     #ZERO   ;VIDEO OFF, RETURN TO CENTER,SET ZERO REF <----
        STB     PPCR
        STA     SR
ZEREF   LDD     #$0302  ;SET ZERO REF ONLY <----
        CLR     DAC
        STA     PORT
        STB     PORT
        STB     PORT    ;(NOP) FOR S/H TIME
        LDB     #$1
        STB     PORT    ;LEAVE 4052 AT 0 ADDRESS
ZBONG   RTS

ZERO_   LDD     #ZERO   ;VID OF, RET CENTER, NOT SET ZERO REF <----
        STB     PPCR
        STA     SR
        RTS

SIZPRAS LDD     ,U++   ;GET RASTER SIZE, POSITION BY U REG, JMP TO RASTUR <----
DUSTRAG STD     SIZRAS
POSNRAS LDD     ,U++   ;PICK UP INDEUED POSITION, GO TO RASTUR <----
POSDRAS JSR     POSITD  ;POSITION BY A,B, GO TO RASTUR <----
        JSR     DEL28
        JMP     RASTUR

AXOLOT  BSR     SIZPRAS
TEXSIZ  LDA     ,U     ;REPEAT CALLS TO SIZPRAS, 0=END BYTE <----
        BNE     AXOLOT
        RTS

AXLOTL  BSR     POSNRAS
TEXPOS  LDA     ,U     ;REPEAT CALLS TO POSNRAS, 0=END BYTE <----
        BNE     AXLOTL
        RTS


*       TO SHOW NUMBER OF SHIPS
*       INPUT A : ASCII CODE OF SYMBOL   INPUT B : NUMBER - NOT THE ASCII CODE
*                                       :        ( 0-9 SHOW AS  SUCH ,OTHERE SHOW INFINITEE
*       INPUT X POINTS AT/HOLDS POSITION :
*                                        :
*       USES WHATEVER IS IN T1 AND SIZRAS ` 2: ` ` ` ` ' ' '' ` ` ` ' ' ' '
*                                           :
SHIPSAT LDX     ,X      ;       <------------:------------- IF X POINTS AT POSITION
*                                             :
SHIPSHO PSHS    B       ;        <--------------:----------- IF X HOLDS POSITION
        LDB     #$80    ;*                          :
        LEAU    -8,S
        PSHU    D       ;        SHIP SYMBOL,DELIMITER

        PULS    A
        CMPA    #9
        BLS     UNDER
        LDA     #$3C
UNDER   ADDA    #$30

        LDB     #$2D
        PSHU    D        ;       NUMBER,DASH
        PSHU    X        ;       POSITION
        BRA     POSNRAS  ;       EXIT FROM THERE - ALL REGISTER ? ON EXIT
*                               USES 16 BYTES UNDER STACK - HOW LOW CAN YOU GET


*SCORED LDY     #SEG7   DRAWS SCORE IN 7 SEGMENT FASHION <----
*       LDA     SIZSCR  TIME FOR THE VECTORS
*       STA     T1LOLC
*DONDIG LDA     0,U+    U REG POINTS TO LSD OF SCORE- BCD
*       BMI     ZEROIT  WILL END THERE
*       LDA     A,Y
*       LDB     #1      B USED FOR LOOP CTR
*       STD     SCORET
*       LDX     #DRSEG7
*       BRA     SLORED
*
*STORED ASL     SCORET+1
*       BEG     DONDIG
*       LDB     SCORET+1
*SLORED BITB    SCORET
*       BEQ     SCORBL
*       BSR     DIFFY
*       BRA     STORED
*
*SCORBL BSR     DUFFY
*       BRA     STORED


DUFFAX  LDA     ,X+    ;<----
        BRA     DUFLST

DUFTIM  STB     T1LOLC  ;ALL THESE SAME AS DIFFY ENTRIES BUT FIRST LINE BLANK <----
        BRA     DUFFY

DUFFX   LDD     ,X++   ;<----
DUFTLS  STB     T1LOLC  ;<----
DUFLST  STA     LIST    ;"   "     "    BUT HAS A LIST VALUE <----
DUFFY   LDD     ,X      ;SAME AS 'DIFFY', FIRST LINE BLANK <----
DUFFAB  STA     DAC     ;SAME AS 'DIFFAB' "     "    "     <----
        CLR     PORT
        LEAX    2,X
        NOP
        INC     PORT
        STB     DAC
        LDD     #0
        BRA     UNCLE

DIFFAX  LDA     ,X+    ;ENTRY IF LIST VALUE INDEXED
        BRA     DIFLST

DIFTIM  STB     T1LOLC  ;ENTRY IF 'B' HAS TIMER VALUE <----
        BRA     DIFFY

DIFFX   LDD     ,X++   ;ENTER IF #VECTORS, SIZE IF INDEXED <----
DIFTLS  STB     T1LOLC  ;IF 'B' HAS TIME VAL AND 'A' HAS #VECTORS-1 <----
DIFLST  STA     LIST    ;ENTRY IF 'A' HAS #VECTORS-1 <----
*                       ;DIFFY ROUTINE LEAVES 'LIST'=0
DIFFY   LDD     ,X     ;ENTRY FOR 2 BYTE/ENTRY VECTOR DRAWER <----
DIFFAB  STA     DAC     ;IF ACCUMS ARE VALID <----
        CLR     PORT    ;DIFFY LEAVES 'LIST'=0
        LEAX    2,X     ;WANT TIME DELAY HERE
        NOP
        INC     PORT
        STB     DAC
        LDD     #$FF00
UNCLE   STA     SR
        STB     T1HOC   ;START RAMP
        LDD     #$0040
FEXIT   BITB    IFR
        BEQ     FEXIT
        NOP             ;MOUSE LIVES
        STA     SR
        LDA     LIST
        DECA
        BPL     DIFLST  ;PUT BACK TO FEB19 VERSION IF CRT LAG PERMITS
        JMP     ZEGO

PAC2X   LDB     #SCAL2X ;ENTRY IF WANT 2X TIMING, AND NOT SET UP <----
        BRA     PACB

PAC1X   LDB     #SCAL1X ;ENTRY IF WANT 1X " " " <----
        BRA     PACB

PACXX   LDB     ,X+    ;PICK UP TIMER INDEXED <----
PACB    STB     T1LOLC  ;ENTRY IF B HAS TIMER VALUE <----
PACKET  LDD     1,X     ;ENTRY POINT HERE IF T1LOLC VALID <----
        STA     DAC
        CLR     PORT
        LDA     ,X     ;PICK UP VIDEO ENABLE
        LEAX    3,X
        INC     PORT    ;Y S/H
        STB     DAC     ;SETUP X
        STA     SR      ;VID CONTROL
        CLR     T1HOC   ;START RAMP- FOR CRT PUT THIS BEFORE 'STB SR'
        LDD     #$40
EXIT    BITB    IFR
        BEQ     EXIT
        NOP             ;MOUSE DELAY
        STA     SR
        LDA     ,X     ;ANOTHER ONE?
        BLE     PACKET
        JMP     ZEGO

DASHE   DECA
DASHEL  STA     LIST    ;DASHED LINES,ENTRY IF 'A' IS #VECTORS <----
DASHY   LDD     ,X     ;DASHED LINES, 2 BYTES PER ENTRY <----
        STA     DAC
        CLR     PORT
        LEAX    2,X
        INC     PORT
        STB     DAC
        LDA     DASH
        LDB     #$40
        STA     SR      ;MOVE TO AFTER 'CLR T10HC' FOR CRT
        CLR     T1HOC
        BITB    >IFR    ;EXTENDED FOR TIMING
        BEQ     DASIT   ;IF MORE TANE 1 SR LOAD REQ'D
        CLR     SR
        LDA     LIST
        BNE     DASHE   ;DO ONE MORE
        RTS             ;EXIT POINT IF SHORT VECTOR

DEXIT   LDA     DASH
DASIT   STA     SR
        NOP             ;TO PRESERVE 18 CYCLES
        BITB    IFR
        BEQ     DEXIT
        LDA     LIST
        CLR     SR
        TSTA
        BNE     DASHE   ;TO CONTINUE
        JMP     ZEGO    ;EXIT FOR MED-LONG VECTOR

DASHY3  LDA     ZGO     ;DASHED LINES- 3 BYTE PER VECTOR <----
        PSHS    A
        CLR     ZGO
DASH33  LDA     ,X+
        BPL     NOTSOL
        BSR     DASHY   ;$FF ENABLES DOTTED LINE
        BRA     DASH33

NOTSOL  BNE     SOLNOT
        JSR     DUFFY   ;$00 REQUESTS BLANK LINE
        BRA     DASH33

SOLNOT  DECA
        BEQ     DASDON
        JSR     DIFFY   ;$02 IS SOLID LINE
        BRA     DASH33

DASDON  PULS    A       ;$01 DELIMIT
        STA     ZGO
        JMP     ZEGO


*CURVY  LDD     #$8118  DRAW CURVED LINE FROM UPDATE TABLE <----
*       STA     PORT
*       STB     ACR     U - REG IS POINTER
*       BRA     RAINY
*
*JELLO  STB     PORT    FORMAT- Y,ON/OFF,X,X,X
*       STA     SR      0 GOES TO NEXT Y, ADDIT. 0 ENDS
*JALLO  LDA     0,U+
*       BEQ     BRAINY
*       STA     DAC
*       BRA     JALLO
*
*BRAINY LDB     #$81    RAMP OFF
*       STB     PORT
*       STA     SR      VID OFF
*RAINY  LDA     0,U+    NEXT Y
*       BEQ     JFIN    IF DONE
*       STA     DAC     IF GOOD Y VAL
*       DECB
*       STB     PORT    BEGIN S/H
*       LDD     0,U++   A=VID ENBL, B=NEXT X
*       INC     PORT    Y S/H DONE
*       STB     DAC
*       LDB     #$01
*       BRA     JELLO
*
*JFIN   LDA     #$98
*       STA     ACR     PUT BACK
*       RTS



RASTUR  STU     MESAGE  ;IF U REG POINTS TO STRING <----
RASTER  LDX     #ASCII-$20;      FOR STANDARD ASCII <----
        LDD     #$1883  ;ALPHA-NUM USING ASCII CODES <----
        CLR     DAC
*                       SUPPORTS CODES $20-$6F. $20-$5F ARE STANDARD.$80=DELIM
        STA     ACR     ;MINIMUM 3 CHARS. CODES $60-$6F=GRAPHIC CHARS, SEE DATA
        LDX     #ASCII-$20;      DECODE TABLE 5X7
TOFWD   STB     PORT    ;START ZEREF UPDATE
        DEC     PORT
        LDD     #$8081
        NOP
        INC     PORT
        STB     PORT
        STA     PORT    ;START Y=0 SAMPLE
        TST     REG0    ;NOP
        INC     PORT    ;Y S/H FINISHED
GOFWD   LDA     SIZRAS+1
        STA     DAC     ;FOR HORIZ SPEED
        LDD     #$0100
        LDU     MESAGE
        STA     PORT    ;START RAMP
        BRA     DECOD_  ;3

DECOD   LDA     A,X     ;5- CYCLE COUNT
        STA     SR      ;4
DECOD_  LDA     ,U+    ;6
        BPL     DECOD   ;3- TOTAL 18 FOR LOOP

EOLINE  LDA     #$81    ;2
        STA     PORT    ;4. STOP RAMP, TIME=18 CYCLES+18 PER CHAR
        NEG     DAC
        LDA     #$01
        STA     PORT    ;START RETRACE 2X FWD SPEED
        CMPX    #ASCII+448;      $50*6-$20       4
        BEQ     EOMESS  ;                3
        LEAX    $50,X   ;                5
        TFR     U,D     ;6 CYCLES - CALCULATE #CHARS SHOWN
        SUBD    MESAGE  ;7 - RESULT IN B IS 1+#CHARS
        SUBB    #2      ;2
        ASLB            ;2
        BRN     DELRAS  ;3
DELRAS  LDA     #$81    ;2 DECR LOOP = 9 PER
        NOP             ;2
        DECB            ;2
        BNE     DELRAS  ;3

        STA     PORT    ;4  WHOLE RETRACE= 45+ 9 PER B DELAY LOOP
*                       39-12 FOR FWD OVERHEAD=27
*                       EQUIV OF 3 CHARS
H5
        LDB     SIZRAS
        STB     DAC     ;DO Y SHIFT
        DEC     PORT
        LDD     #$8101
        NOP
        STA     PORT    ;END Y SAMPLE
        CLR     DAC
        STB     PORT    ;START RAMP
*       LDB     #$03
        STA     PORT    ;FINISH RAMP
        LDB     #$03    ;MOD ADDED 4/13/82
        BRA     TOFWD   ;END O RASTER

EOMESS  LDA     #$98
        STA     ACR
        JMP     ZEROIT  ;WILL RETURN FROM THERE


* - - - - - - ASTD GEN - - - - - - -

RAND3   PSHS    B,X     ;RANDOM, 3 NEW BITS <----
        LDB     #2
        BRA     PSUDOH  ;ANSWER RETURNS IA 'A'

RANDOM  PSHS    B,X     ;RANDOM, 1 NEW BIT <----
        CLRB
PSUDOH  LDX     >SEED   ;'SEED' IS INDIRECT POINTER
HODUSP  LDA     1,X     ;ABOUT 50 USEC
        ROLA            ;ALL REGS INTACT BESIDES 'A'
        ROLA
        ROLA
        ROLA
        EORA    2,X
        RORA
        ROL     0,X
        ROL     1,X
        ROL     2,X
        DECB
        BPL     HODUSP
        LDA     ,X
        PULS    B,X,PC  ;END OF RANDOM


IREQ    LDB     #$0D    ;CLEAR REQ AREA, SET REQ6=#$3F <----
        LDX     #REQ0   ;(SOUND DRIVER)
        BSR     CLRSOM
        LDA     #$3F
        STA     6,X
        RTS

CLRSOM  CLRA            ;CLEARS B BYTES STARTING AT X <----
        BRA     GILL

CLRMEM  LDX     #$C800  ;CLEARS 256 BYTES STARTING AT $C800 <----
CLR256  LDD     #$00FF  ;CLEARS 256 START AT 'X' <----
GILL    CLR     D,X     ;CLEARS 'D' BYTES START AT 'X' <----
        SUBD    #1
        BPL     GILL
        RTS

NEGSOM  LDA     #$80    ;FILL  BYTES WITH $80 START AT X <----
*                       ;B ONLY BETWEEN 0 AND $7F
FILL    STA     B,X     ;LOADS 'A' DATA INTO 'B' REGS START AT 'X' <----
        DECB            ;ONLY WORKS FOR 'B' BETWEEN 0 AND $7F * * * * * *
        BNE     FILL
        STA     ,X
        RTS

DEKR3   LDB     #2      ;3 INTERVAL TIMERS <----
        BRA     BEKR


DEKR    LDB     #5 ;*6 ;   INTERVAL TIMERS- COUNT DOWN TO 0 ONCE PER FRAME<----
BEKR    LDX     #X0     ;X IS STARTING TIMER, B = #
AEKR    TST     B,X
        BEQ     GEKR
        DEC     B,X
GEKR    DECB
        BPL     AEKR
        RTS

DEL38   LDB     #3      ;DELAY 38 CYCLES INCLUDING JSR TO GET HERE <----
        BRA     DEL

DEL33   LDB     #2      ;DEL 33 <----
        BRA     DEL

DEL28   LDB     #1      ;28 CYCLES <----
        BRA     DEL

DEL20   CLRB            ;20 CLOCK CYCLES <----
DEL     DECB            ;GENERAL DELAY
        BPL     DEL
DEL13   RTS             ;13 CYCLES <----

BITE    LDX     #BITTBL ;DECODE TO BIT POS FOR 0-7 VALUE IN ACC A <----
        LDA     A,X
        RTS

ABSVAL  TSTA            ;GIVES ABSOLUTE VALUE FOR A,B REGS <----
        BPL     AOK     ;FUDGES -128 TO +127
        NEGA
        BVC     AOK
        DECA
AOK     TSTB
        BPL     BOK
        NEGB
        BVC     BOK
        DECB
BOK     RTS

*  - - - - - THESE USE DP REG = $C8 - - - - - - - - - -

        direct   $C8

*               TAKES DELTA X AND DELTA Y IN REG B,A <----
*               GIVES ANGLE CLOSEST OUT OF 64 POSSIBLE
*               ANSWER IN A AND B REG (SAME) AND 'ANGLE' OF 0-$3F
COMPAS  PSHS    X       ;SAVE FOR RETURN
        STD     ABSY
        ROLB
        LDB     #0
        ROLB
        ROLA
        ROLB
        ASLB
        STB     ANGLE

        LDD     ABSY
        BSR     ABSVAL  ;MAKE POS

        STA     ABSY    ;SET FLAG IF Y<X
        CMPB    ABSY
        BLS     RETAEB
        INC     ANGLE   ;BITS 2,1,0=X SIGN,Y SIGN, AND X>Y BIT
        EXG     A,B     ;SWAP X,Y ID Y<X
        BRA     RETAEB

BEATER  LSRA
        LSRB
RETAEB  CMPA    #9
        BHI     BEATER
        STD     ABSY    ;NOW IN RANGE

        LDB     ANGLE   ;INDEXED TRANSLATOR WEIRD TABLE
        LDX     #WEIRD
        LDB     B,X
        LDX     #ROWTRI ;DECODES ROWS FOR TRIANGLE LOOKUP
        LDA     A,X     ;(A HAD LARGER VALUE) GET ROW LOCATION
        ADDA    ABSX    ;ADD IN SMALLER VALUE FOR COLUMN
        ADDA    #10     ;GO TO START OF FIBTBL

        BITB    #1      ;B HAS 'ANGLE'
        BNE     ITSKUL  ;BIT WAZ SET IF ADJUST NEEDED

        ADDB    A,X
        BRA     ITSLOD

ITSKUL  DECB            ;IF Y<X
        SUBB    A,X
ITSLOD  STB     ANGLE
        LDA     ANGLE   ;ANSWER IN BOTH A AND B!
        PULS    X,Y,PC  ;DONE


COSGET  ADDA    #$10    ;GETS COSINE OF 'A' <----
SINGET  LDX     #RTRIGS ;GETS SINE OF 'A' <---- 26-30 CYCLES
        CLRB
        BITA    #$20    ;TEST FOR NEG
        BEQ     SINPOS
        LDB     #$80
SINPOS  ANDA    #$1F
        CMPA    #$10    ;TEST FOR 90 DEG
        BNE     NOTSQR
        INCB            ;INDICATE OVERFLOW
NOTSQR  LDA     A,X
        RTS             ;ANSWER IN D REG, A=VALUE,B=SIGN/OVERFLOW

SINCOS  PSHS    X       ;GETS SINE,COSINE OF 'ANGLE' <----
        LDA     ANGLE
        BSR     SINGET
        STD     SINE
        LDA     ANGLE
        BSR     COSGET
        STD     COSINE
        PULS    X,PC

RATOR   SUBB    #$10    ;SINGLE LINE ROT, A=X VALUE,B=ANGLE,T ASSUMED=0 <----
ROTOR   STB     ANGLE   ;SINGLE LINE ROTATE, B=ANGLE <----
ROTAR   STA     LEG     ;A=Y VALUE, X ASSUMED=0 <----
        BSR     SINCOS
        BSR     RSIN
        NEGA
        PSHS    A
        BSR     RCOS
        PULS    B,PC    ;Y,X COORDS IN A,B REGS AT EXIT


DANROT  STA     >ANGLE  ;'SIFFY' STYLE ROTATE, A HAS ANGLE <----
DISROT  STB     >LIST   ;" ", B HAS #VECTORS-1 <----
DIFROT  PSHS    DP      ;" ", LIST,ANGLE SET
        JSR     DPRAM
        BSR     SINCOS
        BRA     RX      ;OTHER DETAILS SIMILAR TO 'POTATE' BELOW

POTATA  STA     >ANGLE  ;PACKET ROTATE IF ANGLE IN 'A' <----
POTATE  PSHS    DP      ;PACKET ROTATE IF 'ANGLE' VALID <----
        JSR     DPRAM
        STA     LIST    ;MINUS INDICATES POTATE AS OPPOSED TO DIFROT
        BSR     SINCOS  ;X REG POINTS TO PACKET, U REG TO DESTINATION
SHARON  LDA     ,X+    ;TEST CONTROL BYTE
        STA     ,U+
        BLE     RX      ;IF NOT END BYTE
        CLR     LIST
        PULS    DP,PC   ;ADIOS

FROTT   DEC     LIST

RX      LDA     ,X+    ;NEXT LINE SPEC X,Y
        BSR     RCOSA
        STA     ,U     ;1 BYTE FOR INTERMEDIATE RESULTS

        LDA     ,X
        BSR     RSINA
        ADDA    ,U     ;RESULTS IS NEW Y VAL
        STA     ,U+    ;NEW Y=YCOS(ANGLE) + XSIN(ANGLE)

        LDA     -1,X
        BSR     RSINA
        STA     ,U

        LDA     ,X+    ;LEAVES X AND U POINT TO NEXT VECTOR
        BSR     RCOSA
        SUBA    ,U
        STA     ,U+    ;NEW X=XCOS(ANGLE) - SIN(ANGLE)

        LDA     LIST
        BMI     SHARON
        BNE     FROTT
        PULS    DP,PC   ;END OF DIFROT

RSINA   STA     LEG     ;MULTS 'A' BY SINE PREV STORED <----
RSIN    LDD     SINE    ;MULTS 'LEG' BY SINE PREV STORED <----
        BRA     RSC

RCOSA   STA     LEG     ;MULTS  'A' BT COSINE PREV STORED <----
RCOS    LDD     COSINE  ;MULTS 'LEG' BY COSINE PREV GOTTEN <----

RSC     STB     LAG     ;HOLDS SIGN,OVERFLOW BITS 7,0
*                       WARNING NO INPUT=$80 ALLOWED
        BITB    #1      ;SHOULD MULT?
        BEQ     DOALL   ;NO, FLIP ONLY
        LDA     LEG
        BRA     FONLY

DOALL   LDB     LEG     ;LEG IS INPUT VECTOR
        BPL     BEPL
        COM     LAG     ;TWO WRONGS MAKE A RITE
        NEGB
BEPL    MUL
        ADCA    #0
FONLY   LDB     LAG     ;CHECK SIGN FLIP
        BPL     ROUT
        NEGA
ROUT    RTS             ;ANSWER IN A REG

BAGAUX  LDB     A,U     ;STUFFS A+1 VALUES FROM U TO X <----
        STB     A,X
STFAUX  DECA            ;STUFFS A VALUES FROM U TO X <----
        BPL     BAGAUX
RATS    RTS

*       TUNE PLAYER- FOR THIS TO WORK, MUST ALSO CALL 'REQOUT' ONCE/FRAME

*                       TUNE PLAYER <----
REPLAY  LDA     TSTAT   ;TO START, PUT $01 IN TSTAT
        BMI     HEYBAB  ;TSTAT= $80 DURING TUNE, =0 AT IDLE
        BEQ     RATS    ;EXIT IF NOT GOING

SPLAY   LDX     #NOTES  ;TO START TUNE <----

SOPLAY  STX     DOREMI  ;TO START WITH ALTERNATE NOTE TABLE BY X REG <----
YOPLAY  LDA     #$80    ;INIT TUNE, NOT CHANGE NOTE BASE <----
        STA     TSTAT   ;INDICATE START
        LDD     ,U++   ;IF NEW, U SHOULD POINT TO TUNE
        STD     FADE
        LDD     ,U++
        STD     VIBE
        STU     TUNE
        JSR     IREQ    ;CLEAR 13 REGS, SET REQ6=$3F
        LDD     #$1F1F
        STD     FADEB
        LDD     #0
        STD     TONEB
        STD     TONEC
        STA     NEWGEN
        BRA     PICKUP

HEYBAB  LDU     #FADEA  ;REFRESH TONE AMPLITUDES
        LDB     #2
FAHDE   LDA     B,U
        CMPA    #$1F    ;LIMIT AT $1F
        BEQ     THRILL
        INC     B,U
THRILL  DECB
        BPL     FAHDE

        LDX     VIBE    ;PLOGLAMMABLE VIBLATO
        LDU     #RATEA  ;TABLE INDIRECT 'VIBE'
        LDA     #7      ;VARIED RATES
RAZV    INC     ,U
        CMPA    ,U     ;MOD COUNTERS
        BGE     DOC
        CLR     ,U
DOC     LDB     ,U+    ;DECODE TABLE BY TUNE
        ANDB    #7
        LDB     B,X
        STB     ,U+
        INCA
        CMPA    #9
        BLS     RAZV
NOYC    DEC     RESTC   ;CHECK REST
        BNE     UPATEN  ;BRANCH IF NOT TIMED OUT

HITIT   LDA     NEWGEN  ;CYCLE TO NEXT TONE GEN
        DECA
        BPL     SPIN
        LDA     #2
SPIN    STA     NEWGEN

PICKUP  LDB     [TUNE]  ;PICK UP NEW NOTE
        LDU     #FADEA
        CLR     A,U
        BITB    #$40
        BEQ     TONEON
        LDX     #CRT    ;NOISE IS ON FOR THIS NOTE
        LDA     A,X
        ANDA    REQ6
        STA     REQ6
        LDA     NEWGEN
        ADDA    #3
        LDA     A,X
        ORA     REQ6
        STA     REQ6
        ANDB    #$1F
        STB     NOISEF
        BRA     DONALD

TONEON  LDX     #CRATE
        LDA     A,X
        ANDA    REQ6
        STA     REQ6
        LDA     NEWGEN
        ADDA    #3
        LDA     A,X
        ORA     REQ6
        STA     REQ6
        LDA     NEWGEN
        ASLA            ;INDEX FOR NOTE LOC
        ADDA    #3      ;POINT TO NOTES
        LEAU    A,U     ;U NOW HAS PLAE TO DUMP NOTE
        ANDB    #$3F    ;STRIP OFF FLAG
        ASLB
        LDX     DOREMI
        LDD     B,X
        STD     ,U     ;STORE NOTE VALUE

DONALD  LDX     TUNE    ;ANOTHER NOTE?
        LDB     ,X+
        STX     TUNE
        TSTB
        BMI     HITIT   ;YES
        LDB     ,X+
        BPL     RESTY

XPLAY   JSR     IREQ    ;TO STOP TUNE BEFORE END <----
        CLR     TSTAT   ;PREPARE TO END
        RTS             ;CC SET FOR QUICK TEST

RESTY   STX     TUNE    ;SET UP WAIT
        ANDB    #$3F
        STB     RESTC

UPATEN  LDY     FADE    ;GETS ADDR OF FADEOUT TABLE
        LDU     #FADEA  ;FADE SPEC TONE GEN
        LDX     #REQ3
        LDA     #2
IPATEN  LDB     ,U+
        BITB    #1      ;ODD OR EVEN?
        BEQ     PEVEN
        LSRB            ;DIV/2
        LDB     B,Y
        ANDB    #$F
        BRA     JOWL

PEVEN   LSRB
        LDB     B,Y     ;GET IGH BYTE
        LSRB
        LSRB
        LSRB
        LSRB
JOWL    STB     A,X
        DECA
        BPL     IPATEN

VIBO    LDU     #TONEC+2 ;*VIBRATO SECTION HERE
        LDX     #REQ8
HARRY   LDD     ,--U
        TST     -8,U    ;USE ONLY VIBC FOR FIRST
        BPL     RISE
        NEG     -8,U    ;NEG, SHOULD SUBTRACT
        SUBB    -8,U
        SBCA    #0
        NEG     -8,U
        BRA     BUYS

RISE    ADDB    -8,U
        ADCA    #0
BUYS    STD     ,X++
        CMPX    #REQC+2
        BNE     HARRY
HUMAN   RTS

MPLAY   FCB     $20,$C0,$40,$C0,'PLAYER',$80 ;*PLAYER OPTION MESSAGE
MGAME   FCB     $E0,$C0,$01,$C0,' GAME',$80  ;*GAME OPTION MESSAGE

        direct   $C8
OPTION  STD     >FADE   ;DISPLAYS AND SETS PLAYER/GAME OPTIONS <----
        TSTA
        BEQ     BOPTO
        LDA     #1
BOPTO   TSTB
        BEQ     IPTOID
        LDB     #1
IPTOID  STD     >PLAYRZ
        JSR     DPRAM
        LDD     #$F850
        STD     SIZRAS
        STA     LAG     ;TO NOT GLITCH ON EDGE
        BRA     SMILE

POTION  JSR     FRAM20  ;ENTRY VALUES: A=MAX PLAYERS, 0=DON'T SHOW
        CLRA
        JSR     ENPUT   ;              B=MAX GAMES,   " "     "
        JSR     DEKR3
        JSR     INTMAX
        direct   $D0
        LDA     PLAYRZ
        LDY     #MPLAY  ;PLAYER MESSAGE
        BSR     SHOWY
        LDA     GAMZ
        LDY     #MGAME
        BSR     SHOWY

        direct   $C8
        JSR     DPRAM
        LDA     LAG     ;WAIT FOR KEY RELEASE
        BEQ     PWR80
        LDA     TRIGGR
        BNE     SMILE
        CLR     LAG
PWR80   LDA     X1
        BEQ     HUMAN   ;TIMEOUT

        LDA     X0      ;KEY0 PLAYER SEL
        BNE     POTION
        LDA     KEY3
        BNE     HUMAN   ;START KEY
        LDA     KEY0
        BEQ     PAS0
        LDA     PLAYRZ
        BEQ     PAS0
        INCA
        CMPA    FADE    ;LIMIT
        BLS     YIPPIE
        LDA     #1
YIPPIE  STA     PLAYRZ
        BRA     SMILE

PAS0    LDA     GAMZ
        BEQ     POTION
        LDB     KEY1    ;KEY1 GAME UP
        BEQ     PAS1
        INCA
        CMPA    FADE+1
        BLS     BOIGE
        LDA     #1
        BRA     BOIGE

PAS1    LDB     KEY2    ;KEY2 GAME DOWN
        BEQ     POTION
        DECA
        BNE     BOIGE
        LDA     FADE+1  ;WRAP MINUE
BOIGE   STA     GAMZ
SMILE   LDA     #$F3
        STA     X1      ;TIMEOUT PARAM
        COMA
        STA     X0
        BRA     POTION

SHOWY   LDX     #FADEA  ;SHOWS NUMBER AND MESSAGE FOR OPTION ABOVE <----
        PSHS    A
        BSR     SCLR
        LDA     ,S+    ;TO SET CC
        BEQ     YOTION
        BSR     SHADD   ;SHOW NUMBER
        TFR     X,U
        LDD     ,Y++
        JSR     POSDRAS
        TFR     Y,U     ;Y HELP NUMBER,MESSAGE LOC, AND MESSAGE
        JSR     POSNRAS
YOTION  RTS

SCLR    LDD     #$2020  ;CLEARS RASTER TYPE SCORE, 6 DIG+ 1 BYTE END <----
        STD     ,X     ;X IS MSD ADDRESSS
        STD     2,X     ;SHOWS TWO ZEROS
        STA     4,X
        LDD     #$3080  ;LEAVES X REG ALONE
        STD     5,X
        RTS


SHADD   LDU     #0      ;ADDS 1 BYTE HEX IN 'A' TO SCORE <----
CHAD    CMPA    #99     ;X POINTS TO 6 DIG ASCII STYLE SCORE
        BLS     TEN10
        SUBA    #100    ;BINARY -> BCD CONVERT
        LEAU    $0100,U
        BRA     CHAD

TEN10   CMPA    #9
        BLS     ONE1
        SUBA    #10
        LEAU    $0010,U
        BRA     TEN10

ONE1    LEAU    A,U
        TFR     U,D     ;GOES INTO 'SADD'

SADD    PSHS    A       ;SCORE ADDING ROUTINE, 'D' HAS 4 DIG PACK BCD <----
        PSHS    B
SADD2   LDB     #5      ;HERE IF DATA ON STACK
LLAD    CLRA            ;X POINTS TO MSD OF 6 DIG(BYTE) SCORE
        CMPB    #1      ;ADDS 4 PACKED BCD DIGS(2 BYTES)
        BLS     SIDJ    ;DP REG NO CARE
        BITB    #1      ;DOES NOT CHANGE X REG
        BEQ     SADJ
        LDA     ,S
        BRA     SEDJ

SADJ    LDA     ,S+    ;*1ST AND 3RD INPUT DIGS
        LSRA
        LSRA
        LSRA
        LSRA
SEDJ    ANDA    #$0F    ;MASK FROM UNPACKING
SIDJ    ADDA    >LIST   ;SERVES AS CARRY IND
        CLR     >LIST
        ADDA    B,X
        CMPA    #$2F
        BGT     SGDJ    ;ADJUST IF JUST ZERO
        ADDA    #$10
SGDJ    CMPA    #$39    ;SET FOR CARRY
        BLS     SARJ
        SUBA    #10
        INC     >LIST
SARJ    STA     B,X     ;STORE RESULT
        DECB            ;B TICKER
        BPL     LLAD
        CLR     >LIST
        CLRB
ZERBLNK LDA     B,X
        CMPA    #$30
        BNE     BLNKIT
        LDA     #$20
        STA     B,X
        INCB
        CMPB    #5
        BLT     ZERBLNK
BLNKIT  RTS

* WINNER                --      ENTRY VALUES:   X --> SCORE 1
* ======                                        U --> SCORE 2
*                               RETURN VALUES:  A = 0 -- SCORE 1 = SCORE 2
*                                               A = 1 -- SCORE 1 > SCORE 2
*                                               A = 2 -- SCORE 2 > SCORE 1
*                               FUNCTION:       DETERMINE THE GREATER OF TWO SCORED
*                                               STROED IN ASCII (RASTER) FORM
WINNER  PSHS    X,U
        CLRA
WIN_1   LDB     ,X+
        BMI     WIN_RTS
        CMPB    ,U+
        BEQ     WIN_1
        BHI     WIN_2
        INCA
WIN_2   INCA
WIN_RTS PULS    X,U,PC

* HIGHSCR       --      ENTRY VALUES:   X --> SCORE
* =======                               U --> HIGH SCORE
*                       RETURN VALUES:  ???
*                       FUNCTION:       UPDATE HIGH SCORE
HIGHSCR BSR     WINNER
        CMPA    #1
        BNE     HSCR_RTS
HSLOOP  LDA     ,X+
        STA     ,U+
        BPL     HSLOOP
HSCR_RTS
        RTS


*       MARK'S COLLISION TEST WITH PAUL'S OFFSET PROVISION
*
*       mangled together and tested 4/7/82--both routines of the use of the
*       "U" register are needed to make the routine useful to all programmers
*       since half the programs are absolute oriented and the other half are
*       location oriented (the difference between stored data and calculated
*       data)
*
*               A = BOX 'Y' DIMENSION (DELTA Y)
*               B = BOX 'X' DIMENSION (DELTA X)
*               X = YX COORDS OF POINT TO BE TESTED
*               Y = YX COORDS OF THE CENTER OF BOX
*                       if using the offset:
*                               OFF1BOX -- U = address of location of offset
*                               OFF2BOX -- U = actual offset
*                       if not using the offset, U = who cares
*
*               RETURN VALUES -- ALL PRESERVED
*                       (hence the reason for the extra push of the center
*                       of the box so that any offset added to it will not
*                       be returned)
*                       CARRY BIT: 0 (CLEAR) IF NO COLLISION
*                                 1 (SET)   IF COLLISION
BOXDIM  EQU     0
BOXPOS  EQU     4
XBOXPOS EQU     5
PNTPOS  EQU     2

        direct   $C8


OFF1BOX PSHS    Y       ;U REG INDEXES OFFSET <----
        PSHS    A,B,X,Y
        LDD     BOXPOS,S
        ADDA    ,U
        ADDB    1,U
BADGER  STD     BOXPOS,S
        BRA     CHICAGO

OFF2BOX PSHS    Y       ;U REG CONTAINS OFFSET <----
        PSHS    A,B,X,Y
        TFR     U,D
        ADDA    BOXPOS,S
        ADDB    XBOXPOS,S
        BRA     BADGER

FINDBOX PSHS    Y       ;TSET XOB <----
        PSHS    A,B,X,Y
CHICAGO TFR     S,X
        CLRB

COLID_0 ABX
        LDA     BOXPOS,X
        ADDA    BOXDIM,X
        BVC     COL_0
        LDA     #$7F

COL_0   CMPA    PNTPOS,X
        BLT     N_COLID

        LDA     BOXPOS,X
        SUBA    BOXDIM,X
        BVC     COL_2
        LDA     #$80

COL_2   CMPA    PNTPOS,X
        BGT     N_COLID

        INCB
        CMPB    #2
        BCS     COLID_0

        ORCC    #$01
        BRA     COL_EXT

N_COLID ANDCC   #$FE

COL_EXT PULS    A,B,X,Y
        PULS    Y,PC



* PROGRAMMABLE EXPLOSION - - - - - - - - - - !

* THE FOLLOWING ARE ENTRY VALUES BY WAY OF 'U' POINTER

XREQ6   EQU     RATEA   ;LOCAL PSG ENABLES. ROUTINE STEALS REGS FROM TUNE PLAYER
*               LOG ENABLES AS IN PSG BUT USES POS LOG. UP TO 3 TONES, 3 NOISE
*               THE 'AXE' ROUTINE WILL NOT SCREW WITH UNCALLED REGISTERS

N_DIR   EQU     VIBA    ;NOISE FREQ MOVE DIR, 3 CONDITIONS:
*                       1) IF BIT7 SET, THEN LOWER 5 BITS= STEADY NOISE FREQ
*                       2) IF BYTE NON-ZERO NOISE FREQ GOING DOWN
*                       3) IF BYTE=0 NOISE GOING UP

L_DIR   EQU     RATEB   ;LOUDNESS MOVE DIR, 3 CONDITIONS:
*                       1) IF BIT 7 SET, LOWER 4 BITS=STEADY LOUDNESS
*                       2) IF BYTE NON=ZERO VOLUME GOING UP
*                       3) IF BYTE=0 VOL GOING DOWN

X_SPEED EQU     VIBB    ;COUNTDOWN RATE FROM $7F. RANGE 1(LONGEST) TO $80(SHORTEST)

* THE FOLLOWING ARE SCRATCH LOCATIONS

T_COUNT EQU     RATEC   ;FOR RUMBLES
T_NUM   EQU     VIBC
N_NUM   EQU     TUNE
BOTH    EQU     TUNE+1

*       ORG     0

        direct   $C8

AXE     LDA     SATUS   ;EXPLOSION SEQUENCER FOR GI-PSG <----
        BPL     XGO     ;EITHER GOING, NOT GOING, OR REQUEST
*                       DP SHOULD=$C8, USE WITH REQOUT
        ANDA    #$7F    ;REQUEST TO START EXPLOSION
        STA     SATUS
        LDX     #XREQ6  ;LOAD IN 4 PARAMETER BYTES
        LDA     #4
        JSR     STFAUX  ;B HAS 'XREQ6' DATA AT END
        LSRB
        LSRB
        LSRB
        ORB     XREQ6
        ANDB    #$07
        STB     BOTH    ;USE FOR VOL ENABL POS LOG
        LDB     XREQ6
        ANDB    #$38
        STB     N_NUM   ;NONZERO= NOISE SELECTED
        LDB     XREQ6
        ANDB    #$07
        STB     T_NUM   ;BIT POS FOR EACH TONE CHANNEL
        LDB     #2
        STB     T_COUNT ;BIT FOR WHICH RUMBLE
        LDA     #$7F
        BRA     XORE



XGO     LDA     XACON
        BEQ     XBYE    ;NOT GOING

XMORE   SUBA    X_SPEED ;SEQUENCER
        BPL     XORE
        CLRB
        STB     XACON   ;PREPARE TO EXIT
        BRA     LOUDIN

XORE    STA     XACON
        LSRA            ;SCALE TO $1F RANGE
        LSRA            ;SUITABLE FOR NOISE SPEC
        LDB     N_NUM   ;IF=0, NO NOISE ENABLED
        BEQ     LIN     ;SKIP THIS, JUST PUT LOUDNESS IN
        STA     NOISEF
        LDB     N_DIR   ;WANT UP, DOWN, OR STEADY?
        BMI     NIN     ;BIT7 SET= STEADY NOISE FREQ
        BEQ     LIN     ;ZERO BYTE= NOISE FREQ GOING UP
        TFR     A,B     ;NOISE GOING DOWN
        COMB
NIN     STB     NOISEF

LIN     LSRA
        CMPA    #7
        BLS     ROLD
        CMPA    #$0F
        BEQ     ROLD
        INCA            ;STIFFEN ROLLOFF
ROLD    LDB     L_DIR   ;LOUDNESS UP, DOWN, OR STEADY?
        BMI     LGOIN   ;IF BIT 7 SET, STEADY LOUDNESS VAL=L_DIR
        BEQ     LGOINI  ;IF L_DIR=0, LOUDNESS GOING DOWN
        EORA    #$0F
LGOINI  TFR     A,B
LGOIN   BSR     LOUDIN  ;PUTS IN 1-3 REGS CHA,B,CV

*       RUMBLING TONES

        LDB     T_NUM
        BEQ     NOBLE
BNZ     LDA     T_COUNT
        DECA
        BPL     TNZ
        LDA     #2
TNZ     STA     T_COUNT ;CYCLE THRU CHANS
        JSR     BITE    ;TEST BIT POS
        BITA    T_NUM
        BEQ     BNZ     ;FIND IT
        LDB     T_COUNT
        ASLB
        NEGB
        LDX     #CHAF
        LEAX    B,X     ;(CAN'T USE ABX)
        JSR     RANDOM
        ANDA    #$0F
        CMPA    #5      ;FILTER HI TONES
        BHI     NOFLT
        ASLA
        ADDA    #5
NOFLT   STA     ,X
        LDA     RANCID+1
        STA     1,X     ;LO BYTE TOO

NOBLE   LDA     XREQ6
        COMA
        ANDA    REQ6
        STA     REQ6    ;KEEP ENABLED TO AVOID BUG

XBYE    RTS


LOUDIN  LDA     BOTH    ;STUFF A,B,AND/OR C VOLS
        LDX     #CHAV+1 ;PUT LOUD VALUE IN UP TO 3 CHANNELS
NOSE    TSTA
        BEQ     LOUBYE
        LEAX    -1,X
        LSRA
        BCC     NOSE
        STB     ,X
        BRA     NOSE

LOUBYE  RTS

* - - - - - - - DATA TABLES - - - - - - -

BITTBL  FDB     $0102,$0408,$1020,$4080

*SEG7:          7 SEGMENT DECODER FOR SCORE DISPLAY
*       FCB     $77,$11,$6B,$3B,$1D,$3E,$7E,$13 0-7
*       FCB     $7F,$3F,$5F,$7C,$66,$79,$6E,$4E 8-9,A-F
*       FCB     $00,$20,$08,$02,$0F.$78 BLANK,DASHES,SQUARES

CRT     FCB     $F7,$EF,$DF,$01,$02,$04 ;FOR 'REPLAY'
CRATE   FCB     $FE,$FD,$FB,$08,$10,$20

*DRSEG7:                DRAWS SHAPE OF 7 SEG RECTANGLE
*J      EQU     $40
*       FCB     J,0,0,-J,-J,0,0,J,-J,0,0,-J,J,0,0,-J

FALWEL  FCB     $7F,$7F,$80,$80 ;FOR POWER MONITOR

*               5X7 CHARACTER DECODE $20 THRU $6F
*               CHAR SET GROUPED BY ROW, TOP TO BOTTOM
*               $20-$2F= ' !"#$%&'()*+,-./'
*               $30-$3F= '0123456789:*<=>?'
*               $40-$4F= '@ABCDEFGHIJKLMNO'
*               $50-$5F= 'PQRSTUVWXYZ[\]^_'
*               $60-$6F= W.T. CHAR SET. SEE DOC FOR PICTURES

*       $60 = CAR
*       $61 = UP ARROW . FOR RIGHT ARROW USE -> 2 CHARS
*       $62 = MUSICAL NOTE
*       $63 = DOWN ARROW. FOR LEFT ARROW USE <- 2 CHARS

*       $64 = CIRCLE: LARGE, HOLLOW
*       $65 = CIRCLE: LARGE, SOLID
*       $66 = CIRCLE: SMALL, SOLID
*       $67 = COPYRIGHT CIRCLE

*       $68 = SPACE SHIP
*       $69 = SPACEPERSON
*       $6A = HAVE A NICE DAY
*       $6B = HAVE A BAD DAY

*       $6C = INFINITY
*       $6D = HOLLOW SQUARE
*       $6E = 7X8 FILL CHAR .DO NOT USE AT END OF LINE
*       $6F = 7X7 FILL CHAR. OK AT END OF LINE


ASCII   FDB     $0020,$5050,$20C8,$2010,$1040,$2000,$0000,$0008 ;ROW7
        FDB     $3020,$7070,$10F8,$30F8,$7070,$0060,$0000,$0070
        FDB     $7020,$F070,$F0F8,$F878,$8870,$0888,$8088,$88F8
        FDB     $F070,$F070,$F888,$8888,$8888,$F870,$8070,$2000
        FDB     $0020,$0820,$0000,$0038,$1020,$4444,$00FE,$FFFE

        FDB     $0070,$5050,$78C8,$5020,$2020,$A820,$0000,$0008 ;ROW6
        FDB     $4860,$8888,$3080,$4008,$8888,$6060,$1000,$4088
        FDB     $8850,$4888,$4880,$8080,$8820,$0890,$80D8,$C888
        FDB     $8888,$8888,$A888,$8888,$8888,$0840,$8008,$5000
        FDB     $0070,$0C20,$7070,$0044,$1070,$0000,$6C82,$FFFE

        FDB     $0070,$50F8,$A010,$5040,$4010,$7020,$0000,$0010 ;ROW5
        FDB     $4820,$0808,$50F0,$8010,$8888,$6000,$2078,$2008
        FDB     $A888,$4880,$4880,$8080,$8820,$08A0,$80A8,$A888
        FDB     $8888,$8840,$2088,$8888,$5050,$1040,$4008,$8800
        FDB     $70A8,$0A20,$88F8,$60BA,$3820,$0000,$9282,$FFFE

        FDB     $0020,$0050,$7020,$6000,$4010,$A8F8,$0070,$0020 ;ROW4
        FDB     $4820,$7030,$9008,$F020,$7078,$0060,$4000,$1010
        FDB     $B888,$7080,$48E0,$E098,$F820,$08C0,$80A8,$9888
        FDB     $F088,$F020,$2088,$50A8,$2020,$2040,$2008,$0000
        FDB     $FE20,$0820,$88F8,$F0A2,$38F8,$8238,$9282,$FFFE

        FDB     $0000,$00F8,$7040,$A800,$4010,$A820,$4000,$0040 ;ROW3
        FDB     $4820,$8008,$F808,$8840,$8808,$6060,$2078,$2020
        FDB     $B0F8,$4880,$4880,$8088,$8820,$08A0,$8088,$8888
        FDB     $80A8,$A010,$2088,$50A8,$5020,$4040,$1008,$0000
        FDB     $FE20,$78A8,$88F8,$F0BA,$7C20,$4444,$6C82,$FFFE

        FDB     $0000,$0050,$2898,$9000,$2020,$0020,$4000,$0080 ;ROW2
        FDB     $4820,$8088,$1088,$8880,$8810,$6020,$1000,$4000
        FDB     $8088,$4888,$4880,$8088,$8820,$8890,$8888,$8888
        FDB     $8090,$9088,$2088,$20A8,$8820,$8040,$0808,$0000
        FDB     $4820,$F070,$7070,$6044,$6C50,$3882,$0082,$FFFE

        FDB     $0020,$0050,$F898,$6800,$1040,$0000,$8000,$8080 ;ROW1
        FDB     $3070,$F870,$1070,$7080,$7060,$0040,$0000,$0020
        FDB     $7888,$F070,$F0F8,$8078,$8870,$7088,$F888,$88F8
        FDB     $8068,$8870,$2070,$2050,$8820,$F870,$0870,$00F8
        FDB     $0020,$6020,$0000,$0038,$8288,$0000,$00FE,$FFFE

WEIRD   FDB     $0011,$4130,$2110,$2031 ;TRANSLATE 8 WAYS

ROWTRI  FDB     $0001,$0306,$0A0F,$151C,$242D   ;FOR COMPAS ROW DECODE

FIBTBL  FCB     $08             ;QUICK ARC TAN LOOKUP
        FCB     $10,$08
        FCB     $10,$0B,$08
        FCB     $10,$0D,$0A,$08
        FCB     $10,$0E,$0B,$09,$08
        FCB     $10,$0E,$0C,$0A,$09,$08
        FCB     $10,$0E,$0D,$0B,$0A,$09,$08
        FCB     $10,$0F,$0D,$0C,$0B,$0A,$09,$08
        FCB     $10,$0F,$0E,$0C,$0B,$0A,$09,$09,$08
        FCB     $10,$0F,$0E,$0D,$0C,$0B,$0A,$09,$09,$08

RTRIGS  FCB     0,25,50,74      ;SINE TABLE- 16 ANGLES/QUADRANT
        FCB     98,121,142,162  ;VALUES REPRESENT SINE*256
        FCB     181,198,213,226
        FCB     237,245,251,255

        FCB     255,255,251,245
        FCB     237,226,213,198
        FCB     181,162,142,121
        FCB     98,74,50,25
*
*  This is a table of notes (for the game melodies).
*
G2      EQU     0               ;G = 1.5 8ves below middle C
NOTES   FDB     957             ;beginning frequency
GS2     EQU     1               ;G sharp (second 8ve) , etc.
        FDB     903
A2      EQU     2
        FDB     852
AS2     EQU     3
        FDB     804
B2      EQU     4
        FDB     759
C3      EQU     5
        FDB     717
CS3     EQU     6
        FDB     676
D3      EQU     7
        FDB     638
DS3     EQU     8
        FDB     603
E3      EQU     9
        FDB     569
F3      EQU     $0A
        FDB     537
FS3     EQU     $0B
        FDB     507
G3      EQU     $0C
        FDB     478
GS3     EQU     $0D
        FDB     451
A3      EQU     $0E
        FDB     426
AS3     EQU     $0F
        FDB     402
B3      EQU     $10
        FDB     380
C4      EQU     $11
        FDB     358
CS4     EQU     $12
        FDB     338
D4      EQU     $13
        FDB     319
DS4     EQU     $14
        FDB     301
E4      EQU     $15
        FDB     284
F4      EQU     $16
        FDB     268
FS4     EQU     $17
        FDB     253
G4      EQU     $18
        FDB     239
GS4     EQU     $19
        FDB     226
A4      EQU     $1A
        FDB     213
AS4     EQU     $1B
        FDB     201
B4      EQU     $1C
        FDB     190
C5      EQU     $1D
        FDB     179
CS5     EQU     $1E
        FDB     169
D5      EQU     $1F
        FDB     160
DS5     EQU     $20
        FDB     151
E5      EQU     $21
        FDB     142
F5      EQU     $22
        FDB     134
FS5     EQU     $23
        FDB     127
G5      EQU     $24
        FDB     120
GS5     EQU     $25
        FDB     113
A5      EQU     $26
        FDB     107
AS5     EQU     $27
        FDB     101
B5      EQU     $28
        FDB     95
C6      EQU     $29
        FDB     90
CS6     EQU     $2A
        FDB     85
D6      EQU     $2B
        FDB     80
DS6     EQU     $2C
        FDB     75
E6      EQU     $2D
        FDB     71
F6      EQU     $2E
        FDB     67
FS6     EQU     $2F
        FDB     63
G6      EQU     $30
        FDB     60
GS6     EQU     $31
        FDB     56
A6      EQU     $32
        FDB     53
AS6     EQU     $33
        FDB     50
B6      EQU     $34
        FDB     47
C7      EQU     $35
        FDB     45
CS7     EQU     $36
        FDB     42
D7      EQU     $37
        FDB     40
DS7     EQU     $38
        FDB     38
E7      EQU     $39
        FDB     36
F7      EQU     $3A
        FDB     34
FS7     EQU     $3B
        FDB     32
G7      EQU     $3C
        FDB     30
GS7     EQU     $3D
        FDB     28
A7      EQU     $3E
        FDB     27
AS7     EQU     $3F     ;zero frequency for rest
        FDB     0
*
*
* This is the tune to accompany the VECTREX (?) title page.
*
VH      EQU     30
VEQ     EQU     18
TRV     EQU     06
*
*
VCTRX   FDB     FADE4
        FDB     VIBENL
        FCB     D4 | $80
        FCB     D5,TRV+TRV
        FCB     D4 | $80
        FCB     D5,TRV
        FCB     G4 | $80
        FCB     D5 | $80
        FCB     G5,VH*2
        FCB     C4,$80
*
* This is the data table for the beginning melody of BERZERK.
*
TR8     EQU     7               ;frame count in milliseconds (tempo)
TRQTR   EQU     14
ARPEG1  EQU     02
HA      EQU     40
*
*
BZERK   FDB     FADE0,VIBE0
        FCB     E5,TR8          ;eighth note triplets
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TRQTR        ;qtr. note triplet
        FCB     GS4|$80
        FCB     D5|$80
        FCB     G5,$80          ;chord
        FCB     E4|$80
        FCB     AS4|$80
        FCB     DS5,TRQTR       ;chord
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
        FCB     E5,TR8
*THIS AREA DELETED
        FCB     C5|$80
        FCB     FS5|$80
        FCB     B5,TRQTR
        FCB     DS5|$80
        FCB     A5|$80
        FCB     D6,TRQTR
        FCB     F5,ARPEG1               ;final chord in arpeggio form
        FCB     B5,ARPEG1
        FCB     E6,ARPEG1
        FCB     B5,ARPEG1
        FCB     F5,ARPEG1
        FCB     B5,ARPEG1
        FCB     E6,ARPEG1
        FCB     B5,ARPEG1
        FCB     F5,ARPEG1
        FCB     B5,ARPEG1
        FCB     E6,ARPEG1
        FCB     B5,ARPEG1
        FCB     F6,ARPEG1
        FCB     E6,HA
ENDZ    FCB     E5,$80
*
*
FADE0   FDB     $EFFF,$FEDC,$BA00,$0000
        FDB     0,0,0,0
*
*
*
VIBE0   FCB     0,1,2,1,0,$FF,$FE,$FF       ;    -1,-2,-1
*
*
* This is the beginning snare-drum pattern for ARMOR ATTACK. It uses
* the noise channel only.
*
*
QUO     EQU     24              ;frame count in milliseconds (tempo)
EGG     EQU     12
SIP     EQU     06
SIT     EQU     04
SNAR    EQU     $10
*
*
ARMOR   FDB     FADE12
        FDB     VIBENL
        FCB     $40|SNAR+1,QUO+EGG
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,EGG
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,QUO
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,EGG
        FCB     $40|SNAR,EGG
        FCB     $40|SNAR+1,QUO+EGG   ;repeat
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,EGG
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIP
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,QUO
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,SIT
        FCB     $40|SNAR,EGG
        FCB     $40|SNAR,QUO
        FCB     A5,$80
*
FADE12  FDB     $FDBA,$9876,$5544,$3322,$1100,0,0,0
*
* This is the data table for the beginning melody of SCRAMBLE.
*
*
QU      EQU     16              ;frame count in milliseconds (tempo)
EIT     EQU     08
SINTH   EQU     04
HAT     EQU     48
*
*
SCRMBL  FDB     FADE0
        FDB     VIBE0
        FCB     G4|$80      ; first measure (qtr. and sixteenth notes)
        FCB     B4,QU
        FCB     AS7,EIT
        FCB     G4|$80
        FCB     B4,SINTH
        FCB     G4|$80
        FCB     B4,SINTH
        FCB     G4|$80
        FCB     B4,QU
        FCB     AS7,EIT
        FCB     G4|$80
        FCB     B4,SINTH
        FCB     G4|$80
        FCB     B4,SINTH
        FCB     G4|$80      ; all eighth notes until end of tune
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     B4|$80
        FCB     D5,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     G4|$80      ; third measure
        FCB     B4,EIT
        FCB     B4|$80
        FCB     D5,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     G4|$80
        FCB     B4,EIT
        FCB     B4|$80
        FCB     D5,EIT
        FCB     G4|$80      ;         last measure
        FCB     B4,EIT
        FCB     D4|$80
        FCB     G4,EIT
        FCB     B4|$80
        FCB     D5,HAT
        FCB     A4,$80
*
*
FADE1   FCB     $FF,$FE,$DC,$BA,$98,$76,$54,$32,$10
        FCB     0,0,0,0,0,0,0
*
*
* This is the data table for the beginning melody of SOLAR QUEST
*
*
QR      EQU     24             ; frame count in milliseconds (tempo)
DOT8TH  EQU     18
SXTNTH  EQU     06
HALF    EQU     60
*
SOLAR   FDB     FADE2
        FDB     VIBENL
        FCB     G3,QR          ; all quarter notes
        FCB     C4,QR
        FCB     G3,QR
        FCB     C4,QR
        FCB     G3,QR
        FCB     C4,QR
        FCB     G3,DOT8TH
        FCB     G3,SXTNTH
        FCB     C4,QR
        FCB     C5|$80      ; double
        FCB     E5,QR          ;   stops
        FCB     D5|$80
        FCB     FS5,QR
        FCB     E5|$80
        FCB     G5,QR
        FCB     FS5|$80
        FCB     A5,QR
        FCB     D5|$80      ; triad (5-root-3)
        FCB     G5|$80      ; .
        FCB     B5,QR
        FCB     D3,DOT8TH
        FCB     D3,SXTNTH
        FCB     G2,HALF
ENDS    FCB     G4,$80
*
FADE2   FCB     $DE,$EF,$FE,$DC,$BA,$00,$00,$00
        FCB     0,0,0,0,0,0,0,0
*
*
* This is the data table for the beginning melody of ELECTROLUCKS.
*
*
SNTH    EQU     06
EIGHTH  EQU     12
QUR     EQU     24
DQTR    EQU     36
ARPEG   EQU     04
BIG     EQU     50
*
*
LUCKS   FDB     FADE3
        FDB     VIBENL
        FCB     G4,SNTH
        FCB     A4,SNTH
        FCB     B4,EIGHTH
        FCB     G4,EIGHTH
        FCB     A4,EIGHTH+QUR
        FCB     FS5,QUR
        FCB     FS4,SNTH
        FCB     G4,SNTH
        FCB     A4,EIGHTH
        FCB     FS4,EIGHTH
        FCB     G4,EIGHTH+QUR
        FCB     G5,QUR
        FCB     G5|$80
        FCB     B5,EIGHTH
        FCB     FS5|$80
        FCB     A5,EIGHTH
        FCB     E5|$80
        FCB     G5,EIGHTH
        FCB     D5|$80
        FCB     FS5,EIGHTH
        FCB     C5|$80
        FCB     E5,QUR
        FCB     A4|$80
        FCB     D5,QUR
        FCB     FS4,SNTH
        FCB     G4,SNTH
        FCB     A4,EIGHTH
        FCB     FS4,EIGHTH
        FCB     G4,DQTR
        FCB     G5,DQTR
ENDL    FCB     G4,$80
*
*
FADE3   FCB     $FF,$EE,$DD,$CC
VIBENL  FCB     0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
*
* THIS IS THE BEGINNING MELODY FOR GUESS WHAT
*
*
HAQ     EQU     50
TRIQ    EQU     30
ITA     EQU     20
ITB     EQU     10
*
*
TREK    FDB     FADE4
        FDB     VIBENL
        FCB     F4|$80      ; 1ST BEAT (QTR. NOTE)
        FCB     A4|$80
        FCB     C5,TRIQ
        FCB     C4|$80      ; 2ND BEAT  " "
        FCB     E4|$80
        FCB     G4,TRIQ
        FCB     DS4|$80     ; 3RD BEAT  " "
        FCB     G4|$80
        FCB     AS4,TRIQ
        FCB     AS3|$80     ; 4TH BEAT (TRIPLET)
        FCB     DS4|$80
        FCB     G4,ITA
        FCB     F4,ITB
        FCB     G3|$80      ; 5TH BEAT (TRIPLET)
        FCB     C4|$80
        FCB     E4,ITA
        FCB     F4,ITB
        FCB     C4|$80      ; LAST CHORD (HELD)
        FCB     E4|$80
        FCB     G4,HAQ
        FCB     G4,$80
*

FADE4   FDB     $EEFF,$FFEE,$EEDD,$CCBB,$AA99,$8888,$8888,$8888
*

*
* Following is a series of six FANFARES set in various keys,tempi
* and styles. They are 2-4 measures long and may be used to highlight
* particular actions in the games or interrupt and celebrate (or what-
* ever) a particular scoring milestone.
*
*
*
*
* #2 is very fast in a country style.
*
QRTR2   EQU     06
HAFF2   EQU     30
*
*
FFARE2  FDB     FADE8
        FDB     VIBENL
        FCB     B4,QRTR2
        FCB     D5,QRTR2
        FCB     B4,QRTR2
        FCB     G4,QRTR2
        FCB     A4,QRTR2
        FCB     G4,QRTR2
        FCB     E4,QRTR2
        FCB     D4,QRTR2
        FCB     G4,QRTR2
        FCB     D4,QRTR2
        FCB     FS4,QRTR2
        FCB     G4,HAFF2
        FCB     G4,$80
*
*
FADE8   FDB     $FFFF,$EEEE,$DDDD,$CCCC
        FDB     0,0,0,0
*
*
* #3 is a traditional trupmet style fanfare
*
QRTR3   EQU     15
TRATH3  EQU     05
QHELD   EQU     50
*
*
FFARE3  FDB     FADE1
        FDB     VIBENL
        FCB     F4,QRTR3
        FCB     F4,TRATH3
        FCB     F4,TRATH3
        FCB     F4,TRATH3
        FCB     A4,QRTR3
        FCB     F4,QRTR3
        FCB     C5,QRTR3
        FCB     C5,TRATH3
        FCB     C5,TRATH3
        FCB     C5,TRATH3
        FCB     E5,QRTR3
        FCB     C5,QHELD
        FCB     C5,$80
*
*
* FF03 is specifically for BERZERK.
*
*
Q3R     EQU     06
TH3R    EQU     02
QHOLD   EQU     50
*
*
FF03    FDB     FADE1
        FDB     VIBENL
        FCB     F4,Q3R
        FCB     F4,TH3R
        FCB     F4,TH3R
        FCB     F4,TH3R
        FCB     A4,Q3R
        FCB     F4,Q3R
        FCB     C5,Q3R
        FCB     C5,TH3R
        FCB     C5,TH3R
        FCB     C5,TH3R
        FCB     E5,Q3R
        FCB     C5,QHOLD
        FCB     C4,$80
*
*
* #4 is a comic version of #3
*
*
Q4      EQU     15
TR4     EQU     05
H4      EQU     48
HR4     EQU     10
*
FFARE4  FDB     FADE1
        FDB     VIBENL
        FCB     AS4,Q4
        FCB     F4,TR4
        FCB     F4,TR4
        FCB     F4,TR4
        FCB     FS4,H4
        FCB     F4,TR4
        FCB     F4,TR4
        FCB     F4,TR4
        FCB     FS4,H4
        FCB     F4,$80
*
*
*
* #9 is a cutesy little riff in thirds
*
*
Q9      EQU     18
TR9     EQU     12
TR9A    EQU     06
HELD9   EQU     50
*
*
FFARE9  FDB     FADE0
        FDB     VIBENL
        FCB     DS5|$80
        FCB     FS5,Q9
        FCB     DS5|$80
        FCB     FS5,TR9
        FCB     B4|$80
        FCB     DS5,TR9A
        FCB     CS5|$80
        FCB     E5,Q9
        FCB     B4|$80
        FCB     DS5,HELD9
        FCB     D4,$80
*
*
*
* Diminished pattern
*
*
Q16     EQU     16
S16     EQU     04
EI16    EQU     08
*
*
FFARE16 FDB     FADE12
        FDB     VIBENL
        FCB     F4,S16
        FCB     F4,S16
        FCB     F4,S16
        FCB     F4,S16
        FCB     A4,EI16
        FCB     B4,$80




* - - -THESE RAMS ARE FOR 'NIBBY' ONLY
KAOS    EQU     LASRAM ; CONTROL BYTE

* FORMAT OF CONTROL BYTE:
*       0-$F = # VECTORS OF GIVEN TYPE (ON|OFF)
*       OR WITH $20 = ZERO AFTER AND QUIT
*       OR WITH $80 = BEAM ON FOR STRING
*       OR WITH $10 = DO POSITION MOVE
        direct   $D0
*                       1 BYTE/VECTOR, U INDEX <----
NIBBY   LDA     ,Y+    ;GET CONTROL BYTE
        STA     KAOS
        BITA    #$10
        BEQ     DONIB
MORNIB  BSR     ZXXXX
        LDD     ,Y++
        JSR     POSITN  ;NEXT POSITION VECTOR
DONIB   LDA     0,Y     ;START ACTUAL NEXT VECTOR
        ASRA            ;CAREFUL TO SIGN EXTEND
        ANDA    #$F8    ;MASK DEPEND ON TIMES SHIFTED
        LDB     ,Y+
        ASLB
        ASLB
        ASLB
        ASLB

        ASRB
        ANDB    #$F8
        TST     KAOS
        BNE     NIFBY
        JSR     DUFFAB
        BRA     SIDDER  ; TO GET NEXT ITEM

NIFBY   JSR     DIFFAB
SIDDER  LDA     KAOS
        BITA    #$0F
        BEQ     DESEID
        DEC     KAOS
        BRA     DONIB   ;IF ANOTHER VECTOR

DESEID  BITA    #$20
        BEQ     NIBBY
ZXXXX   JMP     ZEROIT


*
*
*       FCB     'KARSSOFT82LDMCBCJ'
*       EOPROG
*
*



        END
