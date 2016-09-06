**      This is a kludge/experimental 3D hack resembling the view
*       while riding a roller coaster.
*
*       Again I don't recall whether I typed this in by hand or
*       it was e-mailed to me.

***** EQUATES FROM MONITOR FOLLOW

        ORG     $C800   RAM
REG0    RMB     1       MIRROR SOUND CHIP REGS FINE TUNE -A- 8 BIT
REG1    RMB     1       COARSE TUNE -A- 4 BIT
REG2    RMB     1       FINE TUNE -B- 8 BIT
REG3    RMB     1       COARSE TUNE -B- 4 BIT
REG4    RMB     1       FINE TUNE -C-
REG5    RMB     1       COARSE TUNE -C-
REG6    RMB     1       NOISE PER, 5 BIT
REG7    RMB     1       ENABLE BAR- IN BAR/OUT: IOA,IOB
*                       NOISE BAR: C,B,A TONE BAR: C,B,A
REG8    RMB     1       AMPL -A-, 4 BIT , 5TH BIT OVERRIDE IF=1
REG9    RMB     1       AMPLITUDE -B-  " "
REGA    RMB     1       AMPL -C-
REGB    RMB     1       FINE TUNE ENVELOPE PER, 8 BITS
REGC    RMB     1       COARSE TUNE ENVELOPE PER, 8 BIT
REGD    RMB     1       ENVELOPE TYPE, 4 BIT- CONT,ATT,ALT,HOLD
REGE    RMB     1       PORT A I/O


TRIGGR  RMB     2       BUTTONS INPUT TO PSG- NEW, LAST
HEDGES  RMB     1       POS EDGE, 1 BIT PER BUTTON
KEY0    RMB     1       POS EDGE, 1 BYTE PER BUTTON, POS LOG
KEY1    RMB     1
KEY2    RMB     1
KEY3    RMB     1
KEY4    RMB     1
KEY5    RMB     1
KEY6    RMB     1
KEY7    RMB     1

POTRES  RMB     1       ACCURACY REQ'D FOR POT READ, LESS IS FASTER
*                       $40=1 BIT,$20=2 BITS,$01=7 BITS,$00=8 BITS
POT0    RMB     1       VALUE READ FROM POTS
POT1    RMB     1
POT2    RMB     1
POT3    RMB     1
DPOT0   RMB     1       DELTA FROM LAST TEST
DPOT1   RMB     1
DPOT2   RMB     1
DPOT3   RMB     1

LIST    RMB     1       # OF VECTORS IN PRESENT CHART
ZGO     RMB     1       IF NONZERO, CAUSES 'ZEROIT' CALL AFTER VECTOR ROUTINES
FRAME   RMB     2       INCRS EVERY TIME FRAM20 OR FRAM30 CALLED
TENSTY  RMB     1       WAST INSTENITY WEVEL

DWELL   RMB     1       DOT DWELL TIME, SET IN INITMSC OR AFTER
DASH    RMB     1       PATTERN FOR DASHED VECTORS


SIZRAS  RMB     2       FOR RASTER - CONTROLS SLEW RATE
*                       SIZE,SIZE+1=Y RATE,X RATE
MESAGE  RMB     2       START OF STRING


X0      RMB     1
X1      RMB     1       INTERVAL TIMERS
X2      RMB     1       COUNT DOWN TO 0 PER FRAME IF 'DEKR' CALLED
X3      RMB     1
X4      RMB     1
X5      RMB     1

ABSY    RMB     1       FOR COMPAS ROUTINE
ABSX    RMB     1       "
ANGLE   RMB     1       "
SINE    RMB     2       VALUE,OVERFLOW
COSINE  RMB     2
LEG     RMB     1
LAG     RMB     1

XMSEC   RMB     2       REFRESH VALUE, INITMSC SETS TO MSEC20

MSEC20  EQU     $3075   LO BYTE, HI
MSEC25  EQU     $7C92
MSEC30  EQU     $C8AF

* - - - - - REGS FOR TUNE PLAYING AND SOUND EFFECTS - - - - -

REQ0    RMB     1       ENVELOPE TYPE - FOR REQOUT ROUTINE
REQ1    RMB     1       TUNE ENVELOPE- MSB (INVERTED ORDER OF REG0-D)
REQ2    RMB     1       "    "       LSB
REQ3    RMB     1       LEVEL- C
REQ4    RMB     1       LEVEL- B
REQ5    RMB     1       LEVEL- A
REQ6    RMB     1       ENABLES- TONES / NOISE / I-O
REQ7    RMB     1       TUNE NOISE- 5 BIT
REQ8    RMB     1       TUNE C- MSB
QEQ9    RMB     1       "   "  LSB
REQA    RMB     1       TUNE B- MSB
REQB    RMB     1       "   "  LSB
REQC    RMB     1       TUNE A- MSB
REQD    RMB     1       "  "  LSB

CHCF    EQU     REQ8    CHANNEL C FREQUENCY
CHBF    EQU     REQA
CHAF    EQU     REQC
NOISEF  EQU     REQ7    NOISE FREQ
ENVELF  EQU     REQ1    ENVELOPE FREQ

CHCV    EQU     REQ3    CHANNEL C VOLUME
CHBV    EQU     REQ4
CHAV    EQU     REQ5

SENABL  EQU     REQ6    SOUND ENABLE

DOREMI  RMB     2       BASE TABLE 2OR NOTES USUALLY=NOTES
FADE    RMB     2       FOR TUNE PLAYER USE
VIBE    RMB     2
TUNE    RMB     2
NEWGEN  RMB     1
TSTAT   RMB     1
RESTC   RMB     1
RATEA   RMB     1
VIBA    RMB     1
RATEB   RMB     1       VIBRATO
VIBB    RMB     1
RATEC   RMB     1
VIBC    RMB     1
FADEA   RMB     1
FADEB   RMB     1
FADEC   RMB     1
TONEA   RMB     2       FREQ BEFORE VIBE
TONEB   RMB     2
TONEC   RMB     2

* - - - - - REGS FOR SOUND EFFECTS - - - - -

SATUS   RMB     1       GAME-SOUNDS INTERFACE
LATUS   RMB     1       LAST 'SATUS' VALUE
XATUS   RMB     1       ", EXPLOSION TYPE
GAP     RMB     1       TIMES HOLD IN BACKGROUND SOUND
B1FREQ  RMB     2
B2FREQ  RMB     2
F1FREQ  RMB     2
FEAST   RMB     1       FIRING STATE COUNTER
PEDGE   RMB     1       POSITIVE EDGE OF 'SATUS'
NEDGE   RMB     1       NEGATIVE EDGE OF 'SATUS'
K1FREQ  RMB     2       BACKGROUND FREQ 1
BACON   RMB     1       " SEQUENCER
XACON   RMB     1       EXPLO SEQ
SPEKT   RMB     1       EXPL SPECTR

PLAYRZ  RMB     1       # PLAYERS IN GAME
GAMZ    RMB     1       GAME # OPTION

SEED    RMB     2       POINTER TO 3 BYTE RANDOM #, USUALLY IS RANCID
RANCID  RMB     3


LASRAM  EQU     *


RAMMES  EQU     $CA00

        ORG     $CBEA

STACK   RMB     1
HEIGH   RMB     7       TITLE PAGE HIGH SCORE
INMI    RMB     0
ISWI3   RMB     0
ISWI2   RMB     3
IFIRQ   RMB     3
IIRQ    RMB     3
ISWI    RMB     3
JRES    RMB     2


        ORG     $D000   I/O

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


DAC     EQU     APORT   FOR HUMAN INTERFACE
PORT    EQU     BPORT   MAIN CONTROL PORT
ZERO    EQU     $CC     CODE TO PCR ZERO INTEGRATORS
UNZERO  EQU     $CE     CORE FOR RELEASE HOLD ZERO
SCAL1X  EQU     $7F     TIMING PARAMETERS FOR VECTOR WRITE
SCAL2X  EQU     $FF
CARTS   EQU     $0      ADDRESS OF EXTERNAL ROM PACK
ROMS    EQU     $F000   ADDRESS OF ON-BOARD ROM
INHOUS  EQU     $E000
***** EQUATES FROM MONITOR PRECEDE
*****   FOLLOWING ARE THE MONITOR ENTRY POINTS
POWER   EQU     $F000
WARM    EQU     $F004
INITPIA EQU     $F14C
INITMSC EQU     $F164
INITALL EQU     $F18B
FRAM20  EQU     $F192
STAR20  EQU     $F1A2
DPIO    EQU     $F1AA
DPRAM   EQU     $F1AF
ENPUT   EQU     $F1B4
INPUT   EQU     $F1BA
POTS4   EQU     $F1F5
PBANG4  EQU     $F1F8
PSGX    EQU     $F256
PSG     EQU     $F259
INITPSG EQU     $F272
PSGLUP  EQU     $F27D
PSGULP  EQU     $F282
PSGLPU  EQU     $F284
REQOUT  EQU     $F289
INT1Q   EQU     $F29D
INTMID  EQU     $F2A1
INT3Q   EQU     $F2A5
INTMAX  EQU     $F2A9
INTENS  EQU     $F2AB
DOTTIM  EQU     $F2BE
DOTX    EQU     $F2C1
DOTAB   EQU     $F2C3
DOT     EQU     $F2C5
DIFDOT  EQU     $F2D5
DOTPAK  EQU     $F2DE
POSWID  EQU     $F2F2
POSITD  EQU     $F2FC
POSIT1  EQU     $F30C
POSITB  EQU     $F30E
POSITX  EQU     $F310
POSITN  EQU     $F312
ZERO_DP EQU     $F34A
ZEGO    EQU     $F34F
ZEROIT  EQU     $F354
ZEREF   EQU     $F35B
ZERO_   EQU     $F36B
SIZPRAS EQU     $F373
POSNRAS EQU     $F378
POSDRAS EQU     $F37A
TEXSIZ  EQU     $F385
TEXPOS  EQU     $F38C
SHIPSAT EQU     $F391
SHIPSHO EQU     $F393
DUFFAX  EQU     $F3AD
DUFTIM  EQU     $F3B1
DUFFX   EQU     $F3B5
DUFTLS  EQU     $F3B7
DUFLST  EQU     $F3B9
DUFFY   EQU     $F3BC
DUFFAB  EQU     $F3BE
DIFTIM  EQU     $F3D2
DIFFX   EQU     $F3D6
DIFTLS  EQU     $F3D8
DIFLST  EQU     $F3DA
DIFFY   EQU     $F3DD
DIFFAB  EQU     $F3DF
PAC2X   EQU     $F404
PAC1X   EQU     $F408
PACXX   EQU     $F40C
PACB    EQU     $F40E
PACKET  EQU     $F410
DASHEL  EQU     $F434
DASHY   EQU     $F437
DASHY3  EQU     $F46E
RASTUR  EQU     $F495
RASTER  EQU     $F498
RASCII  EQU     $F49B
RAND3   EQU     $F511
RANDOM  EQU     $F517
IREQ    EQU     $F533
CLRSOM  EQU     $F53F
CLRMEM  EQU     $F542
CLR256  EQU     $F545
GILL    EQU     $F548
NEGSOM  EQU     $F550
FILL    EQU     $F552
DEKR3   EQU     $F55A
DEKR    EQU     $F55E
DEL38   EQU     $F56D
DEL33   EQU     $F571
DEL28   EQU     $F575
DEL20   EQU     $F579
DEL13   EQU     $F57D
BITE    EQU     $F57E
ABSVAL  EQU     $F584
COMPAS  EQU     $F593
COSGET  EQU     $F5D9
SINGET  EQU     $F5DB
SINCOS  EQU     $F5EF
RATOR   EQU     $F5FF
ROTOR   EQU     $F601
ROTAR   EQU     $F603
DANROT  EQU     $F610
DISROT  EQU     $F613
POTATA  EQU     $F61F
POTATE  EQU     $F622
RSINA   EQU     $F65B
RSIN    EQU     $F65D
RCOSA   EQU     $F661
RCOS    EQU     $F663
BAGAUX  EQU     $F67F
STFAUX  EQU     $F683
REPLAY  EQU     $F687
SPLAY   EQU     $F68D
SOPLAY  EQU     $F690
YOPLAY  EQU     $F692
XPLAY   EQU     $F742
OPTION  EQU     $F7A9
SHOWY   EQU     $F835
SCLR    EQU     $F84F
SHADD   EQU     $F85E
SADD    EQU     $F87C
OFF1BOX EQU     $F8E5
OFF2BOX EQU     $F8F3
FINDBOX EQU     $F8FF
AXE     EQU     $F92E
NIBBY   EQU     $FF9F
*****   PRECEDING WHERE THE MONITOR ENTRY POINTS
*****   OTHER STUFF FROM MONITOR
ASCII   EQU     $F9F4
VCTRX   EQU     $FD0D
*****   PRECEDING WAS OTHER MONITOR STUFF
*
*
*
*
*
UZEROX  EQU     $CF             UNZERO
ZEROX   EQU     $CD             ZEROIT
DISPAR  EQU     $28             DISPARITY TIMER
MAXBOX  EQU     $80             MAXIMUM BOX SIZE
SHPTIM  EQU     $3F             TIMER FOR SHIP
MAXTUN  EQU     $6F             MAXIMUM TUNNEL SIZE
TUNSIZ  EQU     $7F             TIMER DISTANCE BETWEEN BOXES
SECOND  EQU     28              BASE TIMER 37 MS
DBASE   EQU     $60             DISPARITY BASE
PLUG    EQU     $40             MASK FOR PLUG DIRECTION BIT
ENABLE  EQU     $07             ENABLE REGISTER ADDRESS
OUTPUT  EQU     $F25B           RUM OUTPUT ROUTINE, MINUS MIRRORED RAM

***********
**
** SOUND EQUATES
**
***********
EXPSND  EQU     $80             EXPLOSION SOUND
BULSND  EQU     $20             BULLET FIRE
FALSND  EQU     $40             FALLING SOUND
FULSND  EQU     $10             GET FUEL SOUND
WALSND  EQU     $08             PASS WALL SOUND
GUYSND  EQU     $04             ENEMY SOUND
BELSND  EQU     $02             BELL WARNING
BAKSND  EQU     $01             BACKGROUND SOUND
*
* 3D SPRITE RAM TABLE
*
SPRXY   EQU     0               SPRITE XY
SPRDIS  EQU     2               SPRITE DISPARITY
SPRTIM  EQU     3               SPRITE TIME
SPRZOM  EQU     5               SPRITE ZOOM

SPRCOL  EQU     7               SPRITE COLOR
SPRINT  EQU     8               SPRITE INTENSITY
SPRPTR  EQU     9               POINTER TO SPRITE ICON
*                               MOTION PARAMETERS FOR SPRITES
SPRXX   EQU     13
SPRYY   EQU     15
SPRXXV  EQU     17
SPRYYV  EQU     19

*                               PATH WIDTH  XLEFT,XRIGHT  YLEFT,YRIGHT
SPRXXW  EQU     21
SPRYYW  EQU     23

*                               BODY SIZE
SPRMX   EQU     25
SPRMY   EQU     26
*                               TUNNEL INFO (ANOTHER PATCH)
SPRTUN  EQU     27
SPRTXY  EQU     28
*                               EXPLOSION JUNK
SPREXP  EQU     30              EXPLOSION FLAG
SPRXTM  EQU     31              EXPLOSION TIME
*                               ROUTINE TO DRAW  WITH
SPRDRW  EQU     32
SPREND  EQU     34


CBLUE   EQU     1
CGREEN  EQU     2
CRED    EQU     3
*
*
*************
**
** RAM ALLOCATIONS  /WBH
**
*************
        ORG     $C880

EXTRA   RMB     1
TRKSPD  RMB     1
ZOMSPD  RMB     1
MAXWALL RMB     1
TUNSPD  RMB     1
MAXKILL RMB     1               MAXIMUM NUMBER TO KILL
SCRADD  RMB     2
HITMAN  RMB     1
JNKFLG  RMB     1
MANTYP  RMB     2


GUYVX   RMB     2
GUYVY   RMB     2


PEMP0   RMB     1
PEMP1   RMB     1
PEMP2   RMB     1
PEMP3   RMB     1
PEMP4   RMB     1
PEMP5   RMB     1
PEMP6   RMB     1
PEMP7   RMB     1
PEMP8   RMB     1
PEMP9   RMB     1

***********
**
** SOUND RAM
**
***********
SNDWRD  RMB     1
CHAN    RMB     1
MASK    RMB     1
NUSND   RMB     1
SNDGO   RMB     1
SNDMAB  RMB     1
NOSEFR  RMB     1
EXPLOS  RMB     1
RANGE   RMB     1



HITSID  RMB     1
RIGHT   RMB     1               LEFT , RIGHT EYE FLAG
TUNPTR  RMB     2               POINTER TO NEXT TUNNEL
NEWTUN  RMB     2
NXTSTA  RMB     2               THE END MUST BE NEAR
OPTIME  RMB     2               OPENING TIME
BOXFLG  RMB     1               TO DISPLAY OR NOT
FULPICK RMB     1
NUMKILL RMB     1               NUMBER OF ENEMY KILLED
TUNDONE RMB     1               TUNNEL DONE FLAG
WALDONE RMB     1               WALL DONE ( DONT ENTER ANYMORE)
NUMWALL RMB     1               NUMBER OF WALLS WE PASSED
WALLTYP RMB     1               WALL TYPE FOR FUEL/WALL
WALCOL  RMB     1               WALL COLOR
VARTIM  RMB     2               VARIABLE TIMER FOR EXPLOD
EXPDONE RMB     1               EXPLOSION FLAG
HITSHIP RMB     1               SHIP HIT FLAG
JUNKSP  RMB     1               SPACE JUNK VELOCITY
JUNKHIT RMB     1               SPACE JUNK HIT
LEVEL   RMB     1
SHPRAS  RMB     6               SHIPS
SHPNUM  RMB     2               SHIP NUMBER + TERM
SCORE   RMB     7               SCORE
ENDGAM  RMB     1               SET TO $FF WHEN ALL SHIPS SHOT
ZOOM    RMB     9       3*3     ZOOM (RMB 2) INTENSITY (RMB 1)
****************
**
** THE INFAMOUS SPRITE TABLE HOLDING ALL THE KEYS TO THE AGES
** SUCH AS COLOR POISITION SIZE ETC.
** STICK IT ANYWHERE CHARLY
**
******************
SPRTAB  RMB     12*SPREND
SPRTAX  RMB     4
SPRTPTR RMB     2                SPRITE TABLE POINTER

CURTAB  RMB     2                CURRENT SPRITE POINTER
FUEL    RMB     3                FUEL LEVEL
DELFUEL RMB     3
NOFUEL  RMB     1
ONFUEL  RMB     1


LSTEDG  RMB     2
UNTILL  RMB     2
TEMP    RMB     2
ZMSTRT  RMB     1               ALLOWS N ZOOM STARTS
ONROTS  RMB     4               MOTOR-ON ROTATIONS COUNTERS
*                               JUST(T-0),LAST(T-1),(T-2),(T-3)
SMPLCN  RMB     1               MOTOR STATISTICS SAMPLE COUNTER
DUNFLG  RMB     1               SET TO FF WHEN DRAWING IS STARTED
*                               SET TO 00 IF DRAWING COMPLETED
MOT_PW  RMB     4               MOTOR PULSE WIDTH IN TERMS OF A
*                               DECREMENTING T2 TIMER VALUE
*                                0: ON ROTATION POWER PULSE WIDTH
*                                1: POWER PULSE WIDTH WORKING REGISTER
*                                2: OFF ROTATION POWER PULSE WDTH
*                                3: OFF ROT PWR PW LSB (2 IS MSB)
SNDRAM  RMB     32
FIRRAM  RMB     12
OUTRAM  RMB     12
        ORG     $0000
        SETDP   $D0
        FCB     $67,' GCE 1983',$80     INTERNAL ROM LINKAGE KEY
        FDB     VCTRX           VECTREX OPENING DOT-DA-DEE MLDY
        FDB     $F840           RASTER SIZE
        FDB     $10D0           TITLE POSITION
        FCB     'ROCKET SLEDGE',$80     GAME TITLE
        FCB     $00


START   JSR     INITALL
        JSR     IREQ
        JSR     REQOUT
        CLR     DPOT2
        CLR     DPOT3

        LDX     #NEWGAM
        STX     NXTSTA

        CLR     SNDWRD
        CLR     SNDGO


        LDA     #$01
        STA     EXPLOS           SET UP EXPLOSION

        LDD     #$00E0          LSB,MSB
        STD     XMSEC           APPROX 37 MSEC ?
        STB     MOT_PW+2        SETUP MINIMUM OFF ROTATION POWER
        LDD     #$0008
        STD     ONROTS          SETUP ONROTS JUST AND LAST COUNTER
*                               CLEAR ONROTS AND MAKE LAST ALL ON
        STB     SMPLCN          START SAMPLE COUNTER (08)
        CLR     MOT_PW          SETUP WIDE ON ROT PWR PULSE WIDTH
        CLR     MOT_PW+1        IN RUNNING TEMP TOO
        LDD     #$7E82
        STA     IIRQ            JUMP CODE (7E) AS PART OF 3 BYTE
*                               VECTOR LINKAGE INSTRUCTION
        STB     IER             SET (8), CA1 (2) IN THE PIA AS
*                               THE IRQ INTERRUPT SOURCE
        LDD     #MOTOR          LOCATION OF MOTOR INTERRUPT ROUTINE
        STD     IIRQ+1          REST OF 3 BYTE INTERRUPT RAM LINK
        LDA     #$CD            SETUP CA1 POSITIVE EDGE
        STA     PPCR            TO PRODUCE CA1 IRQ INTERRUPT FLAG
*                               IN FIRST INTERRUPT ROTATION AFTER
*                               UPSPD

        CLR     PEMP0

UP2SPD  LDD     XMSEC           SPIN UP WHEEL
        STD     T2LOLC          SET WHEEL DURATION TIMER
        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        BSR     PSGIN           GET 1ST VALUE
        STA     LSTEDG          LAST EDGE
UP35
        LDB     REQ6            FIND OUT CURRENT SETTING
        ORB     #PLUG           SELECT OUTPUT
        LDA     #ENABLE         ADDRESS FOR ENABLES
        JSR     OUTPUT          SEND IT OUT TO PSG
        LDD     #$0E80
        JSR     PSGX
        LDB     #$60
UP4     DECB                    TILL B PW OVER
        BNE     UP4
        LDD     #$0EFF
        JSR     PSGX
        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        BSR     PSGIN
        TST     LSTEDG
        BNE     UP5
        TSTA                    SEE IFF OFF
        BNE     UP6
UP5     STA     LSTEDG
        BRA     UP35
UP6     LDA     IFR
        BITA    #$20
        BNE     UP2SPD          NOT UP TO SPEED
* SEE IF ENUF TIMES
* MUST BE FAST 3 TIMES
        INC     PEMP0
        LDA     PEMP0
        CMPA    #$03
        BNE     UP2SPD

        BRA     MAIN


PSGIN   LDA     #$0E
        STA     APORT
        LDD     #$1901
        STA     BPORT
        NOP
        STB     BPORT
        CLR     APORTD
        LDD     #$0901
        STA     BPORT
        NOP
        LDA     APORT
        NOP
        STB     BPORT
        LDB     #$FF
        STB     APORTD
        ANDA    #$80
        RTS

**
**START OF MAIN LOOP--ALSO CARRIED OUT THRU TEST  /WBH
**
MAIN    JSR     STAR20

SCENE
* SET TIMER
        LDD     XMSEC
        STD     T2LOLC

        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        JSR     INPUT
        LDB     REQ6            FIND OUT CURRENT SETTING
        ORB     #PLUG           SELECT OUTPUT
        LDA     #ENABLE         ADDRESS FOR ENABLES
        JSR     OUTPUT          SEND IT OUT TO PSG
        LDD     #$0E80
        JSR     PSGX
        LDD     #$FF02
        STA     DUNFLG          SCENE NOT DRAWN (STARTED)(FF)
        STB     IFR             CLEAR CAI INTERRUPT FLAG (02)
        ANDCC   #$EF            ENABLE 6809 IRQ RECEPTION

        LDD     FRAME
        ADDD    #$01
        STD     FRAME

        JSR     TEST
        CLR     LIST
        JSR     PBANG4
        JSR     ZEROO
        JSR     ZEREF

        LDB     #$10            WHEEL VELOCITY JITTER WINDOW TIME
SC3     DECB
        BNE     SC3             PAD TIME TO AVOID LINE DROPPING
        CLR     DUNFLG          SCENE GOT COMPLETELY DRAWN (NO IRQ)

        CWAI    #$EF
****************
**
** QUIET
** DO THE SOUND
**************
QUIET
* DO THE SOUNDS
        JSR     REQOUT
        CLR     TSTAT
        JSR     DPRAM
        JSR     SOUND
        JSR     DPIO
        SETDP   $D0
        RTS


**************
**
** PENB
**
** MORE DELAY ON THE LINES
**
*************

PENB    STB     T1LOLC
PENB1   LDD     1,X
        STA     DAC
        CLR     PORT
        LDA     0,X
        LEAX    3,X
        INC     PORT
        STB     DAC
        STA     SR
        CLR     T1HOC
        LDD     #$40
PENB2
        BITB    IFR
        BEQ     PENB2

        EXG     X,X

        STA     SR
        LDA     0,X
        BLE     PENB1
        RTS


*************
**
** ANIM
**
** DRAW THE GROUP OF PACKETS 4 FRAME ANIMATION
** REG X POINTS TO ANIM TABLE
** PACKET POINTS TO 4 ADDRESS USE FRAME COUNTER TO ADDRESS PACKET
**
*************

ANIM
        LDA     FRAME+1
        LSRA
        LSRA            : DIVIDE BY *
        ANDA    #$03
        LSLA             MULT BY 2
        LDX     A,X      GET ADDRESS
        BRA     PENB
**************
**
** PENTIM
**
** USES A VARIABLE TIMER ( VARTIM ) TO EXPAND LINES WITH $02
**
*************

PENTIM
        PSHS    B
PENT1   LDB     0,S              GET BASE TIMER
        STB     T1LOLC
        LDD     1,X
        STA     DAC
        CLR     PORT
        LDA     0,X
        BLE     PENT2
        LDA     VARTIM
        STA     T1LOLC
        CLRA
PENT2
        LEAX    3,X
        INC     PORT
        STB     DAC
        STA     SR
        CLR     T1HOC
        LDD     #$40
PENT4
        BITB    IFR
        BEQ     PENT4
        EXG     X,X
        STA     SR
        LDA     0,X
        CMPA    #$01
        BNE     PENT1
        PULS    B
        JMP     ZEROO
************
**
** DOTTIE
** PACKET DOTS
**
*************

DOTTIE
        STB     T1LOLC
DOTTI1  LDD     1,X
        STA     DAC
        CLR     PORT
        CLRA
        LEAX    3,X
        INC     PORT
        STB     DAC
        STA     SR
        CLR     T1HOC
        LDD     #$40
DOTTI2
        BITB    IFR
        BEQ     DOTTI2
        EXG     X,X

        COM     SR
        NOP
        NOP
        COM     SR

        LDA     0,X
        BLE     DOTTI1

        RTS
*************
**
** TA DA !!! JOHN'S GREAT DRAWING ROUTINE !!! YEA!!!  /WBH
**
***************
*                               FORMAT: STATUS,Y,X,ZOOM MULT (2**N)
*                                       STATUS=00=BEAOM OFF
*                                       STATUS=FF=BEAM ON
*                                       STATUS=01=END OF PACKET

DRAW
        BSR     DRAWZ
        LDA     #$CD
        STA     PPCR     ZERO THE BEAM
        RTS

DRAWZ
        CLR     PORT            SET MULTIPLEXER TO YAXIS S/H
        LDA     1,X             A HAS YAXIS VOLTAGE
        STA     DAC             SET YAXIS VOLTAGE INTO Y S/H
*                               FOLLOWING IS Y AXIS SAMPLE TIME
        LDB     3,X             B HAS ZOOM PWR OF 2 MULTIPLIER
        STB     UNTILL+1        ZOOM MULT WORKING REG
        LDB     #$55            MAKES A TOTAL OF 4 ADDED EVERY 2 2X
        STB     TEMP            IN THE 2X MULTIPLY LOOP (DR1)
        LDB     UNTILL          B HAS ZOOM TIMER LSB
        CLRA                    SETUP FOR DOUBLE PRECIS
        DEC     UNTILL+1        NO ZOOM IF ZERO
        BMI     DR2             NO ZOOM, SETUP TIMER AND Y SAMPLE/H
DR1     ASL     TEMP             (IF >4X EVER USED)
        ROLB                    ZOOM VALUE =ZOOM VALUE X2
        ROLA                    A HAS ZOOM MSB
        ADDB    #$03            ZOOM 00 IS A TIME QUANTITY OF ~3.75
        ADCA    #$00
        DEC     UNTILL+1        NO MORE ZOOM IF 0
        BPL     DR1             2X AGAIN
DR2     STB     T1LOLC          SET TIMER LSB = ZOOM LSB
        LDB     2,X             B HAS XAXIS VOLTAGE
        INC     PORT            SET TO XAXIS PORT
*                               END OF Y S/H TIME
        STB     DAC             SET X VOLTAGE
        LDB     0,X             B HAS BLANKING
        ORCC    #$10            DISABLE IRQ DURING DRAW OF LINE
        STB     SR              SET BEAM ON OR OFF PER BLANKING
        STA     T1HOC           SET TIMER MSB = ZOOM MSB
*                               START RAMP TIMER
        LDB     #$40            TIMER FLAG BIT POSN MASK
DR3     BITB    IFR
        BEQ     DR3             WAIT FOR RAMP TIMER

        LEAX    4,X             WAIT FOR BEAM
        LEAX    0,X
*                               X POINTS AT START OF NEXT PACKET
        CLR     SR              TURN OFF BEAM
        ANDCC   #$EF            RE-ENABLE INTERRUPTS AFTER LINE

        LDA     MOT_PW+1        GET MOTOR WORKING PULSE WIDTH
        BEQ     DR4             DONT MESS WITH JOB IF LOCKED OUT

        CMPA    T2HOC           COMPARE TO WHEEL TIMER MSB
        BHI     DR5             IF MSB LOWER THAN PW, MOTOR OFF

DR4     LDA     0,X             GET NEXT STATUS
        BLE     DRAW            CONTINUE IF $FF OR $00
        RTS

DR5     LDD     #$0EFF          FOLLOWING TURNS MOTOR OFF
        JSR     PSG+2           WITH OUT WRECKING X
        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        CLR     MOT_PW+1        LOCK-OUT DR5 ONCE
        BRA     DR4             CHECK NEXT VECTOR STATUS FOR END

**************
**
** CKMOTOR
**
** CHECK THE MOTOR TIMER AND SEE IF TIME TO FINIS
**
**************

CKMOTOR

        LDA     MOT_PW+1
        BNE     CKMOT2
        RTS
CKMOT2
        CMPA    T2HOC
        BHI     CKMOT4
        RTS
CKMOT4
        LDD     #$0EFF
        JSR     PSG+2
        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        CLR     MOT_PW+1
        RTS
***********************
** MOTOR
***********************
*                               (C) JOHN ROSS 1983
MOTOR   CLR     SR              BEAM OFF
        LDA     IFR             GET INTERRUPT FLAGS FROM PIA
        BITA    #$20            CHECK T2 TIME-OUT FLAG
        BNE     MOT_2           TIMER OVER SO MOTOR IS SLOW
        LDA     MOT_PW+2        MOTOR IS FAST SO  MINIMUM POWER
        STA     MOT_PW+1        IS USED IN THE NEXT ROTATION
        DEC     SMPLCN          ONE 'MOTOR OFF' ROTATION
        BGT     MOT_66          CHECK FRAME TIME ALLOWANCE
        BRA     MOT_3           IF SMPLCN=0=DONE, CHECK STATISTICS

MOT_2   LDA     MOT_PW          POWER PULSE WIDTH IN RELATION TO A
*                               DECREMENTING T2 TIMER
        STA     MOT_PW+1        PULSE WIDTH  FOR NEXT ROTATION
        INC     ONROTS          ONE 'MOTOR ON' ROTATION
        DEC     SMPLCN          ONE ROTATION.
MOT_66  BGT     MOT_65          CHECK FRAME TIME ALLOWANCE
MOT_3   LDB     #$08            1/4 STATISTIC SAMPLE TOTAL COUNT
        STB     SMPLCN          RESET SAMPLE COUNTER
        LDB     ONROTS          NUMBER OF ON ROTATIONS JUST NOW
        ADDB    ONROTS+1        ON ROTATIONS FROM LAST 1/2 SAMPLE
        TFR     B,A             SETUP TO CHANGE ON PWR BY ROT ERROR
        SUBA    #$0D            OPTIMUM NO. OF ONROTS SET HERE----.
        NEGA                    A HAS -ONROTS ERROR FROM OPTIMUM  |
        CMPB    #$0D            OPTIMUM NO. OF ONROT3 SET HERE TOO|
        BEQ     MOT_6           NO ADJUSTMENT TO ON PW
        BPL     MOT_53          GROW ON PW IF TOO MANY ON ROTATIONS
        ADDA    MOT_PW          SHRINK ON PW IF TOO FEW ONROTS
        BCS     MOT_6           UNTILL IT WOULD ROLL OVER
        STA     MOT_PW          SAVE IF NOT ROLLED OVER
        BRA     MOT_6           THEN ADJUST OFF POWER PULSE WIDTH

MOT_53  ADDA    MOT_PW          GROW ON POWER PW IF TOO MUCH ONROT
        BCC     MOT_6           UNTILL IT WOULD ROLL OVER
        STA     MOT_PW          SAVE IF NOT ROLLED OVER
MOT_6   ADDB    ONROTS+2        ADD T-2 ONROTS TO T-1 AND T-0
        ADDB    ONROTS+3        ADD T-3 ONROTS TO T-0, 1, AND 2
        SUBB    #$18            SET OPTMM NO_ OF ONROTS IN $20 HERE
        BEQ     MOT_64          PROPAGATE ONROTS IF OPTIMUM
        TFR     B,A             A HAS ERROR MSB
        CLRB                    SETUP B FOR DIVIDE SHIFTING. A MSB,
        NEGA                    WHICH IS USED IN NEGATIVE FEEDBACK
        ASRA                    AT A RATIO OF 1/2 (OR 1/4 OK TOO)
        RORB                    DOUBLE PRECISION FOR NOW, MAKE LSB.
        TSTA                    RECOVER SIGN OF ERROR
        BMI     MOT_62          GROW OFF ROT PWR IF TOO MANY ONROTS
        ADDD    MOT_PW+2        SHRINK OFF PWR IF TOO FEW ONROTS
        BCS     MOT_64          UNTILL IT ROLLS OVER
        STD     MOT_PW+2        SAVE NEW SMALLER IF NOT ROLLED OVER
        BRA     MOT_64          PROPAGATE ONROTS COUNTERS

MOT_62  ADDD    MOT_PW+2        GROW OFF ROT PWR IF TOO FEW OFFROTS
        BCC     MOT_64          UNTILL IT ROLLS OVER,THEN PROPAGATE
        STD     MOT_PW+2        SAVE NEW LARGER IF NOT ROLLED OVER
MOT_64  LDA     MOT_PW+2        GET OFF ROTATION POWER
        SUBA    #$1A            SET ON/OFF POWER DISTANCE HERE
        SUBA    MOT_PW          DISTANCE FROM ROTATION POWER
        BHI     MOT_61          OFF PWR OK IF >THAT
        LDA     MOT_PW          GET ON PWR
        ADDA    #$1A            OFFSET BY ON/OFF DISTANCE
        STA     MOT_PW+2        SAVE AS NEW OFF POWER
MOT_61  LDD     ONROTS+1            GET T-1, T-2
        STD     ONROTS+2             SAVE AS T-2, T-3
        LDA     ONROTS          GET T-0
        STA     ONROTS+1        SAVE AS T-1
        CLR     ONROTS          CLR T-0 FOR NEXT ON ROTATION COUNT
MOT_65  NOP                     XMSEC (WHEEL ROT TIME) NOT ADJUSTED
*                               IN THIS VERSION---
MOT_9   LDD     #$0EFF          FOLLOWING TURNS THE MOTOR OFF
        JSR     PSGX            BUT MAKES THE PORT IN OUTPUT MODE
        LDB     REQ6            FIND OUT CURRENT SETTING
        ORB     #PLUG           SELECT OUTPUT
        LDA     #ENABLE         ADDRESS FOR ENABLES
        JSR     OUTPUT          SEND IT OUT TO PSG
        JSR     ZEROIT          ZERO THE BEAM POSITION
        LDS     #STACK          CLEAN-UP THE STACK
        JMP     SCENE
****************
**
** PROGRAM
**
****************

****************
**
** DRWBOX
**
** DRAW THE BOX POINTED AT BY REG X
**
** ZOOM,TIMER INFO POINTED AT BY REG Y
**
****************

DRWBOX
        LDA     0,Y
        CMPA    #$FF
        BNE     DRWBB2
        RTS
DRWBB2
        PSHS    X
        LDB     #DISPAR          DISPARITY TIMER
        STB     T1LOLC
        LDD     0,X++            GET OFFSET
        STA     DAC
        CLR     PORT
        LDA     #UZEROX
        STA     PPCR
        INC     PORT
        STB     DAC
        LDB     #$40
        CLR     T1HOC
DRWB_2
        BITB    IFR
        BEQ     DRWB_2
        LDA     0,Y
        STA     UNTILL
        ADDA    #$40
        BPL     DRWB_4
        LDA     #$7F
DRWB_4
        JSR     INTENS
        JSR     DRAW
        PULS    X
ZEROO
        LDA     #ZEROX           ZERO BEAM
        STA     PPCR
        JSR     ZEREF
        JSR     DEL13
        RTS

******************
**
** WALL
**
** DRAW THE WALL AND THEN THE BOX
**
*****************
WALL
        PSHS    X                POINTER TO BOX
        LDX     #TUN9
TRAW
        CLR     PORT            SET MULTIPLEXER TO YAXIS S/H
        LDA     1,X             A HAS YAXIS VOLTAGE
        STA     DAC             SET YAXIS VOLTAGE INTO Y S/H
*                               FOLLOWING IS Y AXIS SAMPLE TIME
        LDB     3,X             B HAS ZOOM PWR OF 2 MULTIPLIER
        STB     UNTILL+1        ZOOM MULT WORKING REG
        LDB     #$55            MAKES A TOTAL OF 4 ADDED EVERY 2 2X
        STB     TEMP            IN THE 2X MULTIPLY LOOP (DR1)
        LDB     UNTILL          B HAS ZOOM TIMER LSB
        CLRA                    SETUP FOR DOUBLE PRECIS
        DEC     UNTILL+1        NO ZOOM IF ZERO
        BMI     TR2             NO ZOOM, SETUP TIMER AND Y SAMPLE/H
TR1     ASL     TEMP             (IF >4X EVER USED)
        ROLB                    ZOOM VALUE =ZOOM VALUE X2
        ROLA                    A HAS ZOOM MSB
        ADDB    #$03            ZOOM 00 IS A TIME QUANTITY OF ~3_75
        ADCA    #$00
        DEC     UNTILL+1        NO MORE ZOOM IF 0
        BPL     TR1             2X AGAIN
TR2     STB     T1LOLC          SET TIMER LSB = ZOOM LSB
        LDB     2,X             B HAS XAXIS VOLTAGE
        INC     PORT            SET TO XAXIS PORT
*                               END OF Y S/H TIME
        STB     DAC             SET X VOLTAGE
        LDB     0,X             B HAS BLANKING
        ORCC    #$10            DISABLE IRQ DURING DRAW OF LINE
        STB     SR              SET BEAM ON OR OFF PER BLANKING
        STA     T1HOC           SET TIMER MSB = ZOOM MSB
*                               START RAMP TIMER
        LDB     #$40            TIMER FLAG BIT POSN MASK
TR3     BITB    IFR
        BEQ     TR3             WAIT FOR RAMP TIMER

        LEAX    4,X             WAIT FOR BEAM
        LEAX    0,X
*                               X POINTS AT START OF NEXT PACKET
        CLR     SR              TURN OFF BEAM
        ANDCC   #$EF            RE-ENABLE INTERRUPTS AFTER LINE

        LDA     MOT_PW+1        GET MOTOR WORKING PULSE WIDTH
        BEQ     TTR4            DONT MESS WITH JOB IF LOCKED OUT

        CMPA    T2HOC           COMPARE TO WHEEL TIMER MSB
        BHI     TR5             IF MSB LOWER THAN PW, MOTOR OFF

TTR4    LDA     0,X             GET NEXT STATUS
        BLE     TRAW            CONTINUE IF $FF OR $00
        BRA     WALL_9

TR5     LDD     #$0EFF          FOLLOWING TURNS MOTOR OFF
        JSR     PSG+2           WITH OUT WRECKING X
        LDB     REQ6            GET CURRENT SETTING
        ANDB    #.NOT.PLUG      SELECT INPUT
        LDA     #ENABLE         ADDRESS OF ENABLE BITS
        JSR     OUTPUT          WRITE TO PSG
        CLR     MOT_PW+1        LOCK-OUT DR5 ONCE
        BRA     TTR4            CHECK NEXT VECTOR STATUS FOR END

WALL_9
        LDA     #UZEROX
        STA     PPCR

        LDD     SPRTXY,Y
        STA     DAC              Y POSITION
        CLR     PORT
        LDA     SPRZOM,Y
        STA     T1LOLC
        EXG     X,X
        INC     PORT
        STB     DAC              X POSITION
        LDB     #$40
        CLR     T1HOC
WALL_2
        BITB    IFR
        BEQ     WALL_2
        PULS    X
        JSR     DRAW
        RTS
****************
**
** DRWSPR
**
** DRAW THE SPRITE PINTED TO BY REG X
**
** PACKET INFO:
**
**      Y,X     : RMB 2
**      DISPAR  : RMB 1
**      TIMER   : RMB 2
**      ZOOM    : RMB 1 (SPRITE)
**      SPRPTR  : RMB 4 (LEFT SPRITE, RIGHT SPRITE)
**
**
****************

DRWSPR

        PSHS    X,U
        LDB     #DISPAR          DISPARITY TIMER
        STB     T1LOLC
        LDB     SPRDIS,X
        NEGB                     DISPARITY POSITIVE
        SEX
        ADDD    #DBASE           DISPARITY BASE
        CLR     DAC
        CLR     PORT
        LDA     #UZEROX
        STA     PPCR
        INC     PORT
        TST     RIGHT
        BEQ     DRWS_2
        NEGB                     GO OTHER WAY
DRWS_2
        STB     DAC
        LDB     #$40
        CLR     T1HOC
DRWS_4
        BITB    IFR
        BEQ     DRWS_4
        LDD     SPRXY,X
        STA     DAC              Y POSITION
        CLR     PORT
        LDA     SPRTIM,X
        STA     T1LOLC
        EXG     X,X
        INC     PORT
        STB     DAC              X POSITION
        LDB     #$40
        CLR     T1HOC
DRWS_6
        BITB    IFR
        BEQ     DRWS_6
        LDA     SPRZOM,X
        STA     UNTILL
        TST     SPRTUN,X
        BEQ     DRWZ_6
        LDD     SPRPTR,X
        CMPD    #FOOL
        BNE     DRWZ_6
        LDD     SPRTXY,X
        STA     DAC              Y POSITION
        CLR     PORT
        LDA     SPRZOM,X
        STA     T1LOLC
        EXG     X,X
        INC     PORT
        STB     DAC              X POSITION
        LDB     #$40
        CLR     T1HOC
DRWZ_2
        BITB    IFR
        BEQ     DRWZ_2
DRWZ_6
        LDA     SPRINT,X
        JSR     INTENS
        LEAU    SPRDRW,X
        TFR     X,Y
        TST     RIGHT
        BEQ     DRWS_8
        LDX     SPRPTR,X
        BRA     DRWS_9

DRWS_8  LDX     SPRPTR+2,X
DRWS_9
        STX     MESAGE           FOR RASTER
        LDB     UNTILL
        JSR     [0,U]
        PULS    X,U
        JMP     ZEROO
************************
**
** COLOR TABLE SUBROUTINES HERE
**
** WORK OFF A COMMON TABLE ACCESS BY ALL BUT PICK OUT DIFFERENT FIELDS
**
** SCAN FROM TOP TO BOTTOM
**
** USING A QUICK SEARCH PROGRAM
** USED FOR SPRITES ( NOT BOXES )
**
** RMB 1 : COLOR ( IF NO MATCH IGNORE )
** RMB 2 : POSITION
** RMB 4 : ZOOM ,ETC ,ETC ,ETC
** YOU GET THE PICRURE
** FIGUR IT OUT YOURSELF
** YOU SON OF A BITCH
** I MEAN LIKE WHERE HAVE YOU BEEN BEFORE
**
***************************

L_BLUE
        COM     RIGHT            LEFT EYE
        JSR     IOBJTAB          INIT THE OBJECT TABLE
L_BLU2
        LDA     #CBLUE
        JSR     GETOBJ
        TSTA
        BNE     L_BLU4
        RTS

L_BLU4
        JSR     DRWSPR
        BRA     L_BLU2


****************************

L_GREEN
        JSR     IOBJTAB          INIT THE OBJECT TABLE
L_GRE2
        LDA     #CGREEN
        JSR     GETOBJ
        TSTA
        BNE     L_GRE4
        LDU     #LIBROM         DRAW BOTTOM BOX AS RAIL START
        JSR     DRWGRP
        JSR     QUIET
        RTS

L_GRE4
        JSR     DRWSPR
        BRA     L_GRE2

LIBROM  FDB     LIBBOX
        FDB     LIBPOX

***************************

L_RED
        JSR     IOBJTAB          INIT THE OBJECT TABLE
L_RED2
        LDA     #CRED
        JSR     GETOBJ
        TSTA
        BNE     L_RED4
        RTS

L_RED4
        JSR     DRWSPR
        BRA     L_RED2

***************************

R_BLUE
        CLR     RIGHT
        JSR     IOBJTAB          INIT THE OBJECT TABLE
R_BLU2
        LDA     #CBLUE
        JSR     GETOBJ
        TSTA
        BNE     R_BLU4
        RTS

R_BLU4
        JSR     DRWSPR
        BRA     R_BLU2

***************************

R_GREEN
        JSR     IOBJTAB          INIT THE OBJECT TABLE
R_GRE2
        LDA     #CGREEN
        JSR     GETOBJ
        TSTA
        BNE     R_GRE4
        LDU     #RIBROM         DRAW BOTTOM BOXES AS TRACK STARTS
        JSR     DRWGRP
        RTS

R_GRE4
        JSR     DRWSPR
        BRA     R_GRE2

RIBROM  FDB     RIBBOX
        FDB     RIBPOX

****************************

R_RED
        JSR     IOBJTAB          INIT THE OBJECT TABLE
R_RED2
        LDA     #CRED
        JSR     GETOBJ
        TSTA
        BNE     R_RED4
        RTS

R_RED4
        JSR     DRWSPR
        BRA     R_RED2

******************************

PASTER
        LDX     #ASCII-$20
        LDD     #$1883
        CLR     DAC
        STA     ACR
TOFWDP
        STB     PORT
        DEC     PORT
        LDD     #$8081
        NOP
        INC     PORT
        STB     PORT
        STA     PORT
        NOP
        NOP
        INC     PORT
GOFWDP
        LDA     SIZRAS+1
        STA     DAC
        LDD     #$0100
        LDU     MESAGE
        STA     PORT
        BRA     PECOD_

PECOD
        LDA     A,X
        STA     SR
PECOD_
        LDA     0,U+
        BPL     PECOD

POLINE
        LDA     #$81
        STA     PORT
        NEG     DAC
        LDA     #$01
        STA     PORT
        CMPX    #ASCII+448      $50*6-$20
        BEQ     POMESS
        LEAX    $50,X
        TFR     U,D
        SUBD    MESAGE
        SUBB    #2
        ASLB
        BRN     PELRAS
PELRAS  LDA     #$81
        NOP
        DECB
        BNE     PELRAS
        STA     PORT

        LDB     SIZRAS
        STB     DAC
        DEC     PORT
        LDD     #$8101
        NOP
        STA     PORT
        CLR     DAC
        STB     PORT
        STA     PORT
        LDB     #$03
        BRA     TOFWDP

POMESS  LDA     #$98
        STA     ACR
        JMP     ZEROO

****************
**
** MAIN CONTROL CENTER FOR THIS GAME
**
** DRAW THE VARIOUS BOXES
**
****************

TEST
        JSR     [NXTSTA]
        LDY     #SECFUN
        LDU     #SECTIM
TEST_1
        LDD     0,U
        BNE     TEST_2
        RTS

TEST_2
        JSR     CKMOTOR
        LDD     0,U
        CMPA    T2HOC            TIME YET
        BLS     TEST_2
        LDX     0,Y++
        PSHS    Y,U
        JSR     0,X
        PULS    Y,U
        LEAU    2,U              NEXT TIMER
        BRA     TEST_1

*****************
**
** ZOOMBK
**
** ZOOM THE BACKGROUND
**
****************
ZOOMBK
        LDA     ZOOM+6
        CMPA    #MAXBOX
        BLS     ZOOM_2
        LDD     ZOOM+3
        STD     ZOOM+6
ZOOM_2
        LDX     #ZOOM+6
        LDA     TRKSPD
        BSR     EXPON
        JSR     MATCH
        RTS



********************
**
** ZOOMLV
**
** LEAVE THE ZOOMING BOXES
**
********************
ZOOMLV
* SEE IF LAST TOO BIG
        CLR     TUNDONE          FLAG TO TELL IF WERE DONE
        LDA     ZOOM+6
        CMPA    #MAXBOX
        BLS     ZOLL_2
        LDA     ZOOM+3
        STA     ZOOM+6
        CMPA    #$FF
        BNE     ZOML_2
        COM     TUNDONE
        RTS

ZOML_2
        LDA     ZOOM
        CMPA    #$FF
        BEQ     ZOML_4

        LDA     #$FF
        STA     ZOOM             BLANK OUT FIRST
        BRA     ZOLL_2

ZOML_4
        STA     ZOOM+3
ZOLL_2
        LDX     #ZOOM+6
        LDA     ZOMSPD
        BSR     EXPON
        LDA     ZOOM+6
        LDB     #$50     IT WORKS
        MUL
        LDB     ZOOM+3
        CMPB    #$FF
        BNE     ZOLL_4
        RTS

ZOLL_4
        STA     ZOOM+3
        LDB     #$4A     FUDGE
        MUL
        LDB     ZOOM
        CMPB    #$FF
        BNE     ZOLL_6
        RTS

ZOLL_6
        STA     ZOOM
        RTS
************
**
** EXPON
**
** REG X POINTS TO THE VALUE
** REG A CONTAINS SPEED
**
************
EXPON
        PSHS    A
        LDD     0,X
        BNE     EXPO_2
        PULS    A
        RTS

EXPO_2
        LDA     1,X
        LDB     0,S
        MUL
        ADCA    #0
        TFR     A,B
        CLRA
        STD     PEMP0
        LDA     0,X
        LDB     0,S
        MUL
        ADDD    PEMP0
        ADDD    0,X
        STD     0,X
        PULS    A
        RTS
**************
**
** NEXPON
**
** DO A NEGATIVE EXPONENTIAL GROWTH
**
** REG X POINTS TO SPRITE
**
************
NEXPON
        LDD     SPRTIM,X
        BNE     NXPO_2
        RTS

NXPO_2
        LDA     SPRTIM+1,X
        LDB     #$1F
        MUL
        ADCA    #0
        TFR     A,B
        CLRA
        PSHS    D
        LDA     SPRTIM,X
        LDB     #$1F
        MUL
        ADDD    0,S++
        SUBD    SPRTIM,X
        COMA
        COMB
        ADDD    #$01
        STD     SPRTIM,X
*                                        NOW CREATE DISPARITY
*                                        SIMPLY MULTIPLY
*                                        TEMPO FIX FOR NOW
*                                        ONLY FOR THIS SHIP
        ASLA             MAKE $3F TO MAX 1111111
        ASLA
        LDS     #$40
        MUL
        STA     SPRDIS,X
        LDA     SPRTIM,X
        ADDA    #$40
        BPL     NEXP4
        LDA     #$7F
NEXP4
        STA     SPRINT,X
        RTS
*************
**
** MATCH
**
** TAKES THE TIMER IN THE HIGHEST ZOOM
** AND CALCS TE OTHER TWO ZOOMS ON THAT VALUE
** BY MULTIPLY .38 TIMES THE TIMER VALUE
**
**************
MKEY    EQU     $68      _38 FRACTIONAL

MATCH
        LDA     ZOOM+6
        LDB     #$50     IT WORKS
        MUL
        STA     ZOOM+3
        LDB     #$4A     FUDGE
        MUL
        STA     ZOOM
        RTS
********************
**
** GETOBJ
**
** GET THE NEXT OBJECT FROM THE STACK
**
********************
GETOBJ
        STA     PEMP1
        JSR     CKMOTOR
        LDA     PEMP1
        LDX     CURTAB
GETO_2
        TST     SPRCOL,X
        BGE     GETO_4
        CLRA
        RTS

GETO_4
        CMPA    SPRCOL,X
        BNE     GETO_6
        TFR     X,U
        LEAU    SPREND,U
        STU     CURTAB
        LDA     #$FF
        RTS

GETO_6
        LEAX    SPREND,X
        BRA     GETO_2
*
IOBJTAB
        LDX     #SPRTAB
        STX     CURTAB
        RTS
*************
**
** MOVSHP
**
** MOVE THE SPACE SHIP
**
*************
MOVSHP
        LDA     TRKSPD
        TST     POT1
        BEQ     MOVS_4
        BLT     MOVS_2
        CMPA    #$60
        BGE     MOVS_4
        ADDA    #$01
        STA     TRKSPD
        BRA     MOVS_4

MOVS_2
        CMPA    #$00
        BLE     MOVS_4
        ADDA    #-1
        STA     TRKSPD
MOVS_4
        RTS
*BILNOTE--- USED TO INIT SPRITE TABLE...
INTSHP
        LDX     #SPRTAB
        CLR     SPRTUN,X                 NOT A TUNNEL

        LDA     #CRED
        STA     SPRCOL,X

        LDD     #PENB
        STD     SPRDRW,X

        LDA     #$40
        STA     SPRDIS,X

        LDA     #SHPTIM                  SHIP TIMER

* CALC DISPARITY
        LDB     #$80
        MUL
        ASLA
        STA     SPRDIS,X

        LDA     #$10
        STA     SPRZOM,X

        LDA     #$7F
        STA     SPRINT,X

*       LDD     #RSHIP
*       STD     SPRPTR,X

*       LDD     #LSHIP
*       STD     SPRPTR+2,X

        CLRA
        CLRB
        STD     SPRXY,X

        CLR     SPREXP,X

        RTS

*BILNOTE--- SEE BILNOTE BELOW
INTJNK
* INIT DEBRIS
        LDA     #$02
        STA     JUNKSP

        LDX     #JNKTAB
        CLR     SPRTUN,X                 NOT A TUNNEL

        LDA     #CRED+$10                SET TO NO ACT
        STA     SPRCOL,X

        TST     JNKFLG
        BNE     INTJJK
        RTS

INTJJK
        LDD     #PENB
        STD     SPRDRW,X

        LDA     #$40
        STA     SPRDIS,X

        LDA     #SHPTIM                  SHIP TIMER
        STA     SPRTIM,X

* CALC DISPARITY
        LDB     #$80
        MUL
        ASLA
        STA     SPRDIS,X

        LDA     #$10
        STA     SPRZOM,X

        LDA     #$7F
        STA     SPRINT,X


        CLR     SPREXP,X


        RTS



*BILNOTE---USED FOR INITIALIZING SPRITE TABLE...
*INTBUL LDX     #SPRTAB+SPREND
*       LDA     #CBLUE+$10
*       JSR     INTBLL
*       LDA     #CGREEN+$10
*       JSR     INTBLL
*       LDA     #CRED+$10
*       JSR     INTBLL
* SET TERM
*       LDA     #$FF
*       STA     SPRCOL,X
*       RTS
*
*
*INTBLL
*       STA     SPRCOL,X
*       LDD     #PENB
*       STD     SPRDRW,X
*       CLR     SPRTUN,X                 NOT A TUNNEL
*       LDA     #$10
*       STA     SPRZOM,X
*       LDD     #BULLET
*       STD     SPRPTR,X
*       STD     SPRPTR+2,X
*       LEAX    SPREND,X
*       RTS
*
*BILNOTE--- ANOTHER SPRITE TABLE INIT ROUTINE...
INTGUY  LDX     #SPREND*5+SPRTAB
        LDA     #CGREEN+$10
        STA     SPRCOL,X
        LDA     #$01
        STA     SPRZOM,X
        LDD     MANTYP
        STD     SPRPTR,X
        STD     SPRPTR+2,X
        LDD     #PENB
        STD     SPRDRW,X

* INIT PATH
*       LDD     #0100
        LDD     GUYVX
        STD     SPRXXV,X
        LDD     GUYVY
        STD     SPRYYV,X

*       LDD     #$FF00
*       STD     SPRYYV,X

        LDD     #$0000
        STD     SPRXX,X
        STD     SPRYY,X
        LDD     #$C03F
        STD     SPRXXW,X
        STD     SPRYYW,X
        LEAX    SPREND,X
        LDA     #$FF
        STA     SPRCOL,X
        RTS
**********************
**
** MOVMEN
**
** UPDATE THE ENEMY MEN
**
**********************
MEMSPR  EQU     SPREND*5+SPRTAB
JNKTAB  EQU     SPREND*4+SPRTAB

MOVMEN
        CLR     HITMAN
        CLR     HITSHIP
        LDX     #MEMSPR
        LDB     SPRCOL,X         ACTIVE
        BITB    #$10
        BEQ     MOVME2
        LDY     NXTSTA
        CMPY    #SHOOT
        BEQ     MIVMIM
        RTS

MIVMIM
        ANDB    #$0F
        STB     SPRCOL,X
        LDD     #ANIM
        STD     SPRDRW,X
        LDD     #$0100
        STD     SPRTIM,X
        LDA     SNDGO
        ORA     #GUYSND
        STA     SNDGO
        LDA     RANCID
        ANDA    #$3F
        TST     RANCID
        BMI     JKLP
        NEGA
JKLP
        LDB     RANCID+1
        ANDB    #$3F
        TST     RANCID+1
        BMI     JJKLP
        NEGB
JJKLP

*       LDD     SPRTAB           GET POSITION  OF SHIP
        STD     SPRXY,X
        STA     SPRYY,X
        STB     SPRXX,X

        CLR     SPREXP,X         CLEAR EXPLOSION FLAG
        LDD     MANTYP
        STD     SPRPTR,X
        STD     SPRPTR+2,X
MOVME2
        PSHS    X
        LEAX    SPRTIM,X
        LDA     #$08
        JSR     EXPON
        PULS    X
        LDA     SPRTIM,X
        LDB     SPRTIM,X
        NEGB
        SUBB    #$10
        STB     RANGE
        CMPA    #$90
        BLS     MOVME4
        LDA     SPRCOL,X
        ORA     #$10
        STA     SPRCOL,X
        LDA     SNDGO
        ANDA    #.NOT.GUYSND
        STA     SNDGO
        RTS

MOVME4
        LDB     #$80
        MUL
        ASLA
        STA     SPRDIS,X
        LDA     SPRTIM,X
        ADDA    #$40
        BPL     MOVME6
        LDA     #$7F
MOVME6
        STA     SPRINT,X
        LDA     SPRTIM,X
        LSRA
        LSRA
        STA     SPRZOM,X
        TST     SPREXP,X
        BEQ     MOVMI6
        DEC     SPRXTM,X
        BEQ     MOVMI2
*       LDU     #EXPTAB
*       LDA     FRAME+1
*       ANDA    #$03
*       ASLA
*       LDD     A,U
*       STD     SPRPTR,X
*       STD     SPRPTR+2,X
        RTS

MOVMI2
        LDA     SPRCOL,X
        ORA     #$10
        STA     SPRCOL,X
        RTS

MOVMI6
        JSR     COLBUL
        TSTA
        BNE     MOVME8
        JSR     COLSHP
        TSTA
        BNE     MOVME7
        RTS

MOVME7
        LDA     #$FF
        STA     HITSHIP          GO INTO HIT MODE
MOVME8
        LDA     SNDWRD
        ORA     #EXPSND
        STA     SNDWRD
        CLR     EXPLOS
        COM     SPREXP,X
        LDA     #$12
        STA     SPRXTM,X
*       LDD     #XXPLO1
*       STD     SPRPTR,X
*       STD     SPRPTR+2,X
        LDD     #DOTTIE
        STD     SPRDRW,X
        INC     NUMKILL
        COM     HITMAN
        RTS
******************
**
** NEWGAM
**
** RESET LEVEL TO 0
** AND SET SHIPS TO MAX
**
******************
NEWGAM
        LDA     #$01
        STA     SNDWRD
        CLR     SNDGO

        CLR     EXTRA
        CLR     NUMKILL
        CLR     LEVEL
        LDX     #OPEN
        STX     NXTSTA
        JMP     OPEN
***************
**
** OPEN
**
** DRAW THE OPENING SEQUENCE
** AND THE GO TO THE CUBES CMING
**
***************

OPEN
*       JSR     INTSHP           INIT THE SHIP
*       JSR     INLEVEL
        JSR     CUBOPEN
        LDD     #4*SECOND
        STD     OPTIME           OPENING TIME

        CLR     BOXFLG
        LDX     #OPWAIT
        STX     NXTSTA           THE INFAMOUS
        RTS
***************
**
** OPWAIT
**
** WAIT FOR THE TIME TO DIE OUT THE BRING UP THE BOXES
**
***************
OPWAIT
        JSR     MOVSHP
*       JSR     INWALL
        LDD     OPTIME
        SUBD    #$01
        STD     OPTIME
        BNE     OPWA2
OPBOX
        LDX     #TUNUP
        STX     NXTSTA
        COM     BOXFLG
        CLRA
        CLRB
        STD     ZOOM
        STD     ZOOM+3
        LDD     #$0300
        STD     ZOOM+6
        JSR     ZOOMBK           NO GLITCH
*       JSR     INTBUL
OPWA2
        RTS
***************
**
** TUNUP
**
** BRING THE TUNNEL UP TO ITS MAX STATE
** AND THEN DITCH TO THE GAME STATE
**
***************
TUNUP
        JSR     MOVSHP
        JSR     ZOOMBK
        LDA     ZOOM+6
        CMPA    #MAXBOX
        BLS     TUNUP2
*       JSR     INTBUL           INIT THE BULLETS
        JSR     INTJNK           INIT THE JUNK
        JSR     INTGUY           INIT THE BADGUY
*       JSR     MOVBUL
*       JSR     MOVJNK
        JSR     MOVMEN

        LDX     #SHOOT           GO INTO SHOOT SEQUENCE
        STX     NXTSTA
TUNUP2
        RTS
**************
**
** NORMAL GAME STATE /WBH
**
**************

SHOOT
        JSR     ZOOMBK
        JSR     MOVSHP


*       LDX     #LEVBOX          LEAVE THE BOXES
*       STX     NXTSTA
*
*       LDD     #5*SECOND
*       STD     OPTIME
*
*       LDA     #$FF
*       STA     SPRTAB+SPREND+SPRCOL     STAMP OUT OBJECTS

        RTS
**************
**
** LEVBOX
**
** WAIT A WHILE TO LEAVE
**
**************

LEVBOX
        JSR     MOVSHP
*       JSR     MOVBUL
*       JSR     MOVMEN
* CLEAR OUT ALL THE BULLETS
        LDA     #$FF
        STA     SPRTAB+SPREND+SPRCOL
* WAIT FOR BOXES TO GO
        JSR     ZOOMLV
        TST     TUNDONE
        BEQ     LEVB_X
* GO TO TUNNEL SEQUENCE
        JSR     INTTUN
        JSR     TUNNEL
        LDX     #TUNTUN
        STX     NXTSTA
        CLR     BOXFLG

        CLR     NUMWALL         NO WALLS PASSES
        CLR     WALDONE         NOT EXIT


LEVB_X
        RTS
**************
**
** TUNTUN
**
** DO THE TUNNEL SEQUENCE UNTIL
** WE HAVE GONE THROUGH ALL THE BOXES
**
**************
TUNTUN

        CLR     ONFUEL
        CLR     FULPICK
        CLR     TUNDONE
        JSR     MOVSHP

        JSR     COLWALL
        BGE     TUNT2

        LDD     #TITS
        STD     NXTSTA
        CLRA
        CLRB
        STD     VARTIM
        LDA     #EXPSND
        ORA     SNDWRD
        STA     SNDWRD
        LDA     #$01
        STA     EXPLOS

        RTS

TUNT2
        CMPA    #$02
        BNE     TUNA2
        COM     FULPICK
        LDA     SNDWRD
        ORA     #FULSND
        STA     SNDWRD
        LDA     FUEL
        ADDA    #5
        CMPA    #$60
        BLE     PUMA2
        LDA     #$60
PUMA2
        STA     FUEL
TUNA2
        CMPA    #$01
        BNE     TINA9
        LDA     SNDWRD
        ORA     #WALSND
        STA     SNDWRD
TINA9
        JSR     TUNNEL
TUNA3
        TST     TUNDONE
        BEQ     TUNT4
*       JSR     INWALL
        JMP     OPBOX            GO TO OPEN BOX

TUNT4
        RTS


TITS
        LDX     #OPEN
        STX     NXTSTA
        RTS
****************
**
** CUBOPEN
**
** OPENING SEQUENCE
** DISPLAY NUMBER OF SHIP AND THE SHORE
** FOR A COUPLE SECONDS
**
** THE LET THE BOXES APPEAR
**
** RELEASE TO SHOOT WHEN DONE
**
****************

CUBOPEN

        LDD     #$F840
        STD     SIZRAS
*       LDX     #BULSPR
*
        LDX     #SPRTAB
*
*       CLR     SPRTUN,X                 NOT A TUNNEL
*
*       LDA     #CBLUE
*       STA     SPRCOL,X
*
*       LDD     #PASTER
*       STD     SPRDRW,X
*
*       LDA     #$20
*       STA     SPRDIS,X

* FIX FOR TUNNEL SEQUENCE
*       LDA     #$7F
*       STA     SPRTIM,X
*
*       LDA     #$10
*       STA     SPRZOM,X
*
*       LDA     #$7F
*       STA     SPRINT,X
*
*       LDD     #SHPRAS
*       STD     SPRPTR,X
*       LDD     #SHPRAS
*       STD     SPRPTR+2,X
*
*       LDD     #$60B0
*       STD     SPRXY,X
*
* SHOW SCORE
*
*       LEAX    SPREND,X
*       CLR     SPRTUN,X                 NOT A TUNNEL
*
*       LDA     #CGREEN
*       STA     SPRCOL,X
*
*       LDA     #PASTER
*       STDDSPRDRW,X

*       LDA     #$20
*       STA     SPRDIS,X
*
** FIX3FOR TUNNEL SEQUENCE
*       LDA     #$7F
*       STA     SPRTIM,X
*
*       LDA     #$10
*       STA3SPRZOM,X
*
*       LDA     #$7F
*       STA     SPRINT,X
*
*       LDD     #SCORE
*       STD     SPRPTR,X
*       LDD     #SCORE
*       STD     SPRPTR+2,X
*
*       LDD     $6020
*       STD     SPRXY,X
*
* SET UP TERMINATOR

*       LEAX    SPREND,X
        LDA     #$FF
        STA     SPRCOL,X
        RTS


ISHPNUM
        RTS





********************
**
** DRWGRP
**
** DRAW THE GROUP OF BOXES
**
** REG X POINTS TO THE SPRITE FOR THAT COLOR
**
** GO THROUGH THE ZOOM TABLE ITSELF
**
****************
DRWGRP
        TST     BOXFLG
        BNE     BARF23
        RTS

BARF23
        PSHS    Y
        LDA     #$03
        STA     PEMP0
* POINT TO THE ZOOM
        LDY     #ZOOM+6
* SEE IF THIS BYTE IS EMPTY
DRWG_1
        LDX     0,U
        LDA     0,Y
        BEQ     DRWG_2
        CMPA    #$60
        BLS     DRWGG1
        LDX     2,U
DRWGG1
* DRAW THE BOX
        JSR     DRWBOX
* PICK UP NEXT BOX
DRWG_2
* REMOVE
        LEAY    -3,Y
        DEC     PEMP0
        BNE     DRWG_1

        PULS    Y

        RTS

DFUEL
        RTS

COLBUL
        RTS

COLSHP
        RTS




****************
**
** COLWALL
**
** CHECK OUT IF SHIP HITS WALL
**
**
** REG A = $FF HIT
**      = $00 NO ON SAME LEVEL
**      = $02 HIT FUEL
**      = $01 PASS THROUGH HOLE
*************
COLWALL

* GO DOWN THE WALL LIST UNTIL YOU HIT THE PROPER TIME
* OR UNTIL YOU HIT THE END

        LDX     #TUNSPR

COLW_1
        TST     SPRCOL,X
        BGE     COLW_2
* NOT FOUND
        CLRA
        RTS

COLW_2
* SEE IF TIMER THE SAME
        LDA     SPRZOM,X
        CMPA    #SHPTIM
        BEQ     COLW_4
* TRY AGAIN SUCKER
        LEAX    SPREND,X
        BRA     COLW_1
*
* CHECK FOR COLLISION
*
COLW_4
* FIRST COMPARE FOR Y
        LDB     SPRTAB+SPRXY             GET SHIP Y
        SEX
        STD     PEMP0
        LDB     SPRTXY,X
        SEX
        SUBD    PEMP0                    GET DIFFERENCE
* SEE IF OUTSIDE BOX
        BGE     COLZ_2
        COMA
        COMB
        ADDD    #$01
COLZ_2
        STD     PEMP0                    Y POSITION

COLZ_4
* NOW SEE ABOUT X
        LDB     SPRTAB+SPRXY+1           GET SHIP Y
        SEX
        STD     PEMP2
        LDB     SPRTXY+1,X
        SEX
        SUBD    PEMP2
* SEE IF OUTSIDE BOX
        BGE     COLZ_6
        COMA
        COMB
        ADDD    #$01
COLZ_6
        STD     PEMP2
* NOW CHECK IF THIS IS A BOX OR A FUEL CELL
        LDD     SPRPTR,X
        CMPD    #FOOL
        BNE     COLQ_2
* ITS A FUEL CELL
* SEE IF WE HIT IT
        LDD     PEMP0
        CMPD    #$0A
        BLS     COLZ_7
* MISSED
        CLRA
        RTS

COLZ_7
        LDD     PEMP2
        CMPD    #$0A
        BLS     COLZ_8
* MISSED
        CLRA
        RTS

COLZ_8
* HIT THE SUCKER
* MAKE IT INVISIBLE
        LDA     #$10
        STA     SPRCOL,X
        LDA     #$02
        RTS
*
* SEE IF WE GO THROUGH THE HOLE IN THE WALL
*
* BIG HOLE

COLQ_2
        LDD     SPRPTR,X
        CMPD    #BBOX
        BNE     DOLQ_2

* BID HOLE

        LDD     PEMP0    GET X
        CMPD    #$0C     BIG X
        BLS     COLQ_4
* HIT
        LDA     #$FF
        RTS
COLQ_4
        LDD     PEMP2
*       CMPD    #$06
        CMPD    #$0C
        BLS     COLQ_6
* HIT
        LDA     #$FF
        RTS
COLQ_6
* MADE IT THROUGH
        LDA     #$01             MADE IT THROUGH
        RTS
*
* SMALL BOX
*
DOLQ_2
        LDD     PEMP0    GET X
        CMPD    #$08     BIG X
        BLS     DOLQ_4
* HIT
        LDA     #$FF
        RTS

DOLQ_4
        LDD     PEMP2
        CMPD    #$04
        BLS     DOLQ_6
* HIT
        LDA     #$FF
        RTS

DOLQ_6
* MADE IT THROUGH
        LDA     #$01             MADE IT THROUGH
        RTS




******************
**
** GETWALL
**
** RETURN THE VARIOUS
**
** REG X POINTS TO PACKET
**
**
*******************

GETWALL
* 32 POSITIONS FOR THE HOLE
* GET RANDOM NUMBER
        LDA     RANCID           GET NUMBER
        ANDA    #$1E             16*2
        LDU     #WALTAB
* GET POSITION
        LDD     A,U              GET X,Y
        STD     SPRTXY,X
* SEE IF FUEL OR WALL
        TST     WALLTYP
        BEQ     GETWA2
* ITS A FUEL CELL
        LDD     #FOOL
        STD     SPRPTR,X
        STD     SPRPTR+2,X

        LDD     #DRAW
        STD     SPRDRW,X

        BRA     GETWA4
*ITS A HOLE
GETWA2
        LDD     #WALL
        STD     SPRDRW,X
* NOW SEE IF ITS BIG OR SMALL
        LDU     #BBOX
        LDA     NUMWALL
        CMPA    #$08
        BLS     GETWA3
        LDU     #SMBOX
GETWA3
        STU     SPRPTR,X
        STU     SPRPTR+2,X

* NOW ADD IN COLOR
GETWA4
        COM     WALLTYP
        LDA     WALCOL
        CMPA    #3
        BNE     GETWA6
        CLRA
GETWA6
        LDU     #KOLTAB
        LDB     A,U
        INCA
        STA     WALCOL
        STB     SPRCOL,X
* UP WALL COUNTER
        INC     NUMWALL
        RTS

KOLTAB
        FCB     CBLUE
        FCB     CGREEN
        FCB     CRED




WALTAB
        FDB     $0000
        FDB     $0048
        FDB     $00B8
        FDB     $4800

        FDB     $B800
        FDB     $4848
        FDB     $48B8
        FDB     $B848

        FDB     $B8B8
        FDB     $0020
        FDB     $00E0
        FDB     $2000

        FDB     $E000
        FDB     $2020
        FDB     $20E0
        FDB     $E020






*********************
**
** TUNNEL
**
** DRAW THE TUNNEL
**
** USE TOP  WALL FOR BASE TIMER AND
**
** USE A FAKE QUEUE TO MOVE THEM AROUND
** LAST OBJECT ALWAYS DRAWN FIRST
**
*********************
TUNSPR  EQU     SPRTAB+SPREND

TUNNEL
* GET TOP ELEMENT
        LDA     TUNSPR+SPRZOM
        CMPA    #MAXTUN
        LBLO    MOV_ON
*
* FUCK THE STACK
*

* MOVE UP THE ZOOM
        LDD     SPRZOM+SPREND+TUNSPR
        STD     SPRZOM+TUNSPR

* MOVE UP THE COLOR

        LDA     SPRCOL+SPREND+TUNSPR
        STA     SPRCOL+TUNSPR
        LDA     2*SPREND+TUNSPR+SPRCOL
        STA     SPRCOL+SPREND+TUNSPR
        LDA     3*SPREND+TUNSPR+SPRCOL
        STA     2*SPREND+TUNSPR+SPRCOL

* MOVE UP THE POINTERS

        LDD     SPRPTR+SPREND+TUNSPR
        STD     SPRPTR+TUNSPR
        STD     SPRPTR+2+TUNSPR

        LDD     2*SPREND+TUNSPR+SPRPTR
        STD     SPRPTR+SPREND+TUNSPR
        STD     SPRPTR+SPREND+2+TUNSPR

        LDD     3*SPREND+TUNSPR+SPRPTR
        STD     2*SPREND+TUNSPR+SPRPTR
        STD     2*SPREND+2+TUNSPR+SPRPTR


* MOVE UP THE DRAW FUNCTION

        LDD     SPRDRW+SPREND+TUNSPR
        STD     SPRDRW+TUNSPR
        LDD     2*SPREND+TUNSPR+SPRDRW
        STD     SPRDRW+SPREND+TUNSPR
        LDD     3*SPREND+TUNSPR+SPRDRW
        STD     2*SPREND;+TUNSPR+SPRDRW

* SHIFT POSITION
        LDD     SPRTXY+SPREND+TUNSPR
        STD     SPRTXY+TUNSPR
        LDD     2*SPREND+TUNSPR+SPRTXY
        STD     SPRTXY+SPREND+TUNSPR
        LDD     3*SPREND+TUNSPR+SPRTXY
        STD     2*SPREND+TUNSPR+SPRTXY


*
* NOW GET THE NEXT ELEMENT
*

* SEE IF TO ONLY ADD IN BLANK

        LDB     NUMWALL
        CMPB    MAXWALL
        BLS     DUNN_2
        LDA     #$FF             TERMINATOR
        STA     3*SPREND+TUNSPR+SPRCOL
        BRA     DUNM_3

DUNN_2
        LDX     #3*SPREND+TUNSPR
        JSR     GETWALL

*
* GET FUNCTION
*       LDD     0,X++
*       STD     SPRDRW+3*SPREND+TUNSPR
*
* GET SPRITE
*       LDD     0,X++
*       STD     SPRPTR+3*SPREND+TUNSPR
*       STD     SPRPTR+2+3*SPREND+TUNSPR

* GET POSITION
*       LDD     0,X++
*       STD     SPRTXY+3*SPREND+TUNSPR
*       STX     TUNPTR
DUNM_3

* IF TOP ELEMENT IS DEAD THEN WERE DEAD
        TST     SPRCOL+TUNSPR
        BGE     DUNN_4

* DEAD IN THE WATER
        COM     TUNDONE
        RTS


DUNN_4
*
* ZOOM THE STACK
*

MOV_ON
        LDX     #TUNSPR+SPRZOM
        LDA     TUNSPD
        JSR     EXPON

* NOW CREATE ZOOM VALUES
        LDA     SPRZOM+TUNSPR

        LDB     #TUNSIZ
        MUL
        STA     SPRZOM+SPREND+TUNSPR

        LDB     #TUNSIZ
        MUL
        STA     2*SPREND+TUNSPR+SPRZOM

        LDB     #TUNSIZ
        MUL
        STA     3*SPREND+TUNSPR+SPRZOM

* NOW CREATE DISPARITY AND INTENSITY

        LDA     #$04
        STA     PEMP0

        LDX     #TUNSPR

NIVER
        LDA     SPRZOM,X
        LDB     #$80
        MUL
        ASLA
        STA     SPRDIS,X
        LDA     SPRZOM,X
        ADDA    #$40

        BPL     MIVER

        LDA     #$7F

MIVER
        STA     SPRINT,X
        LEAX    SPREND,X
        DEC     PEMP0
        BNE     NIVER

        RTS
********************
**
** INTTUN
**
** INIT THE TUNNEL
**
** PLACE THE TABLE INTO
** SET UP THE TIMERS
** ETC.
**
*******************
INTTUN
* SET UP THE INITIAL TIMER
        LDD     #$0800
        STD     SPRZOM+TUNSPR
* SET UP COLOR AND DATA
        LDX     #TUNSPR

        CLR     NUMWALL
        CLR     WALLTYP
        CLR     WALCOL

        LDA     #4
        STA     PEMP6


INTT_2

        LDB     #$FF
        STB     SPRTUN,X

        JSR     GETWALL
        JSR     RANDOM

        LDD     #$0000
        STD     SPRXY,X

        LDD     #$01
        STD     SPRTIM,X

        LEAX    SPREND,X

        DEC     PEMP6
        BNE     INTT_2

INTTUX

        STA     SPRCOL,X


        RTS
**
** .ASM DATA TABLES /WBH
FOOL
        FCB     $00,$10,$00,$00
        FCB     $FF,$F0,$10,$00
        FCB     $FF,$F0,$F0,$00
        FCB     $FF,$10,$F0,$00
        FCB     $FF,$10,$10,$00
        FCB     $01


TUN9
* BIG BOX
        FCB     $00,$7F,$7F,$00
        FCB     $FF,$00,$81,$01
        FCB     $FF,$81,$00,$01
        FCB     $FF,$00,$7F,$01
        FCB     $FF,$7F,$00,$01
* REZEROING
        FCB     $00,$81,$81,$00
        FCB     $01

BBOX
* SMALL HOLE
        FCB     $00,$18,$30,$00
        FCB     $FF,$00,$A0,$00
        FCB     $FF,$D0,$00,$00
        FCB     $FF,$00,$60,$00
        FCB     $FF,$30,$00,$00
        FCB     $01

SMBOX   FCB     $00,$14,$20,$00
        FCB     $FF,$00,$C0,$00
        FCB     $FF,$D8,$00,$00
        FCB     $FF,$00,$40,$00
        FCB     $FF,$28,$00,$00
        FCB     $01



*************
** SECTOR TIMER TABLE
*************

SECTIM
* RIGHT BLUE
        FDB     $F000
* RIGHT GREEN
        FDB     $BD00
* RIGHT RED
        FDB     $9600

* LEFT BLUE
        FDB     $6800
* LEFT GREEN
*       FDB     $4D00
        FDB     $4000
* LEFT RED
*       FDB     $2700
        FDB     $2000
* FINIS
        FDB     $0000



*************
**
** SUBROUTINE TO CALL AT EACH SECTOR
**
*************

SECFUN
* RIGHT EYE
        FDB     R_BLUE
        FDB     R_GREEN
        FDB     R_RED
* LEFT EYE
        FDB     L_BLUE
        FDB     L_GREEN
        FDB     L_RED



*  **************************************************************************
*  *                                                                        *
*  *     NARROW ESCAPE          BILL HAWKINS            SOUND.SUB           *
*  *                                                                        *
*  *            SOUND PACKAGE. ORIGINAL SOURCE:  DUNCAN MUIRHEAD            *
*  *              3 CHANNEL TOTALLY FLOATING SOUNDS.                        *
*  *                                                                        *
*  *                *******PROGRAM SET UP FOR TERMINAL INPUT*********       *
*  *       TO PUT INTO PROGRAM CHANGE NDWRD TO SNDWRD, REMOVE LINES         *
*  *       MARKED '*****REMOVE', UN-COMMENT LINE MARKED '*****INSERT',      *
*  *        SEE ALSO:  SOUND.DOC FOR INSTALLATION NOTES.                    *
*  **************************************************************************



        SETDP   $C8
SOUND   JSR     $F533   IREQ INTREQ
        CLR     REQ6
        LDY     #SNDRAM         32 BYTES
        LDU     #SNDSUB

        LDD     #$C380
        STD     CHAN
*
        CLR     NUSND
        LDA     SNDWRD          INPUT NEW SOUNDS
        ORA     SNDGO           SOUNDS ALREADY GOING
        STA     SNDMAB          CANDIDATE SOUNDS THIS TIME

LOOP    LDA     MASK
        ANDA    SNDMAB
        BEQ     NOTHIZ

        TFR     A,B
        ORA     NUSND
        STA     NUSND
        BITB    SNDWRD
        BNE     NOWSND
        ANDB    SNDGO
        BNE     GOING

NOWSND  LDD     2,U
        STD     ,Y
        LDD     4,U
        STD     2,Y
        LDA     #$1F
        STA     NOSEFR
        STA     REQ7            SEVEN WRECKS
GOING   JSR     [,U]

        LDA     CHAN
        BEQ     DUNN
*
NOTHIZ  LEAU    7,U
        LEAY    4,Y
        LSR     MASK
        BNE     LOOP

DUNN
        LDA     SNDGO                                           ****INSERT
        ANDA    #$07            KLAXON, BACKGRND,INCOMING SURVIVE       ****INSERT
        ORA     NUSND           PLUS CURRENT SOUNDS             ****INSERT
        STA     SNDGO
        CLR     SNDWRD                                          ****INSERT
        RTS


*********************************

SNDSUB  FDB     BANGS           EXPLOSIONS - SUBROUTINE
        FDB     $1A0                        - START PERIOD
        FCB     0,0,$FF                     - START AMPLITUDE
*                               2 TYPES OF EXPLOSION: 00 OR 01 IN EXPLOS

        FDB     FULOUT          FUEL OUT FALLING SOUND
        FDB     $0010
        FCB     $0E,$0E,$00

        FDB     FIRSND          PLAYER MUNITION LANCH SOUND
        FDB     $0000
        FCB     $0F,$18,$FF

        FDB     FEULIN          FEULING SOUND
        FDB     $0200
        FCB     $0C,$05,$FF     03:NOISE  00:TONE   FF:BOTH

        FDB     PASTRU          PASSING THROUGH WALL SOUND
        FDB     $0FFF
        FCB     $10,$18,$FF


        FDB     INCOME          INCOMING MUNITIONS PROPULSION SOUND
        FDB     $0070
        FCB     $0A,$01,$00

        FDB     KLAXON          "FUEL LOW" WARNING KLAXON
        FDB     $0055
        FCB     $10,$00,0

        FDB     BAKGND          BACKGROUND DRONE SOUND
        FDB     $0C00
        FCB     $0C,$18,$00

*
*
KLAXON  LDD     #$1040          SETUP ENVALOPE PERIOD
        STD     REQ1
        LDA     #$08            SETUP ENVALOPE TYPE
        STA     REQ0
        JMP     STUVIT
*
*
FIRSND: LDY     #FIRRAM
        LDA     SNDWRD
        ANDA    MASK
        BEQ     PRESET
        LDD     #0
        STA     ,Y
        LDD     #3
        STD     4,Y
        LDD     #5
        STD     8,Y
        LDD     #$F18
        STD     2,Y
        STD     6,Y
        STD     10,Y
PRESET: LDU     #FIRTBL-6
        LDD     #$00A0          SETUP ENVALOPE PERIOD
        STD     REQ1
        CLR     REQ7            SETUP WHITE NOISE FREQ TO MAX
        LDA     #$0E            SETUP ENVALOPE TYPE
        STA     REQ0
        BSR     SWP_DN
        LEAY    4,Y
        LEAU    1,U
        BSR     SWP_DN
        LEAY    4,Y
        LEAU    1,U
        BSR     SWP_DN
        CLR     CHAN
        RTS

SWP_DN  DEC     3,Y
        LBEQ    SHUTIT
        LDA     3,Y
SWPDN0  CMPA    #$0E
        BGT     SWPDN1
        STA     2,Y             DECAY AMPLITUDE WHEN TIMER  IS LESS THAN 0E
*
SWPDN1  LDX     ,Y
        LEAX    $02,X
        STX     ,Y
        JMP     STUVIT
*
FULOUT: LDY     #OUTRAM
        LDA     SNDWRD
        BITA    MASK
        BEQ     QRESET
*       ANDA    #$FD                                            ****REMOVE
*       STA     SNDWRD                                          ****REMOVE
        LDA     SNDMAB
        ANDA    #$FD
        STA     SNDMAB
        LDA     SNDGO                                           ****INSERT
        ANDA    #$FD                                            ****INSERT
        STA     SNDGO                                           ****INSERT
        LDD     #$10
        STD     ,Y
        STD     4,Y
        LDD     #$E0E
        STD     2,Y
        LDD     #0
        STD     8,Y
        LDD     #$E07
        STD     6,Y
        LDD     #$F03
        STD     10,Y
QRESET: BSR     NOMOGO
        LEAY    4,Y
        BSR     NOMOGO
        LEAY    4,Y

NOMOGO  DEC     3,Y     CHECK TIMER
        BNE     STUVIT  NO CHANGE TILL EVERY TIMER CYCLE
        LDA     #$03    RESET TIMER WHEN OVER
        STA     3,Y
        LDX     0,X     DROP FREQUENCY
        LEAX    1,X
        STX     0,Y
        BRA     STUVIT
*
*
FEULIN:
*       LDA     SNDWRD                                          ****REMOVE
*       ANDA    #$FD                                            ****REMOVE
*       STA     SNDWRD                                          ****REMOVE
        LDA     SNDMAB
        ANDA    #$FD
        STA     SNDMAB
        LDA     SNDGO                                           ****INSERT
        ANDA    #$FD                                            ****INSERT
        STA     SNDGO                                           ****INSERT
        LDD     0,Y     RAISE TONE FREQUENCY
        SUBD    #$030
        STD     0,Y
        DEC     NOSEFR  RAISE NOISE FREQUENCY
        LDA     NOSEFR
        STA     REQ7
        CMPA    #$0F
        BGT     FUELI1
        STA     2,Y
FUELI1  BNE     STUVIT
        BRA     SHUTIT
*
PASTRU  LDD     #$2F40
        STD     REQ1    SETUP ENVALOPE PERIOD
        LDA     #$03
        STA     REQ0    SETUP ENVALOPE TYPE
        DEC     3,Y     CHECK TIMER
        BNE     STUVIT
        LDA     #$02    RESET ENVALOPE GEN IF DONE
        STA     REQ0
        BRA     SHUTIT
*
BAKGND  LDD     0,Y
        SUBD    #$03
        STD     0,Y
        CMPD    #$0A00
        BHI     STUVIT
        LDD     #$0C00
        STD     0,Y
        BRA     STUVIT
*
INCOME  DEC     3,Y
        BNE     INCOM1
        LDA     #$04
        STA     3,Y
        LDA     RANGE   BYTE HAS RANGE TO INCOMING ROUND AS
        STA     1,Y      $FF TO $20 MINIMUM
        BRA     STUVIT

INCOM1  LDA     #$04
        SUBA    3,Y
        ASLA
        ASLA
        NEGA
        ADDA    1,Y
        STA     1,Y
STUVIT  LDX     #REQ3
        DEC     CHAN
        LDA     CHAN
        LDB     2,Y
        STB     A,X

        ASLA
        ADDA    #5
        LEAX    A,X
        LDD     ,Y
        STD     ,X

        LDX     #NABLE
        LDA     6,U
        BMI     BBOTH
        ADDA    CHAN
        LDA     A,X
        ORA     REQ6
        STA     REQ6
BBOTH   RTS


SHUTIT  LDA     MASK
        COMA
        ANDA    NUSND
        STA     NUSND
        RTS


BANGS   LDA     SNDWRD
        ANDA    MASK
        BEQ     SGNAB
        STA     SATUS

SGNAB   PSHS    U
        LDA     EXPLOS
        LDU     #BANGTYP
        ASLA
        ASLA
        LEAU    A,U
        LDA     1,U
        STA     REQ7
        JSR     $F29E   AXE EXPLOD
        CLR     CHAN
        PULS    U

        LDA     XACON
        BEQ     SHUTIT
        RTS


BANGTYP FCB     $38,$10,$00,$08         TABLES FOR AXE
        FCB     $3F,$03,$00,$04

NABLE   FCB     32,16,8,4,2,1

FIRTBL: FCB     $FF,$00,$00,0           FIRE ENABLES
*
*
**********************
**
** SPRITES
**
*********************

*********************
**
** ROLLER TRACK  /WBH
**
********************
*               STAT,Y,X,2**N ZOOM MULT

RIBBOX  FDB     $0060
        FCB     $00,$B7,+59,1
        FCB     $FF,+66,$CA,0
        FCB     $FF,+0,$AC,1
        FCB     $FF,$BE,$A6,0
        FCB     $FF,$A6,$8C,0
        FCB     $00,+90,$74,0
        FCB     $FF,+0,+78,2
        FCB     $FF,$A6,$48,0
        FCB     $01

*
*
RIBPOX  FDB     $0060
        FCB     $00,$B7,+59,1
        FCB     $FF,+66,$CA,0
        FCB     $FF,+0,$AC,1
        FCB     $FF,$BE,$A6,0
*       FCB     $FF,-90,$8C,0
*       FCB     $00,+90,$74,0
        FCB     $FF,+0,+78,2
*       FCB     $FF,-90,$48,0
        FCB     $01



LIBPOX  FDB     $00A0
        FCB     $00,$B7,$C5,1
        FCB     $FF,+66,+54,0
        FCB     $FF,+0,+84,1
        FCB     $FF,$BE,+90,0
*       FCB     $FF,-90,$74,0
*       FCB     $00,+90,$8C,0
        FCB     $FF,+0,$B2,2
*       FCB     $FF,-90,$48,0
        FCB     $01


LIBBOX  FDB     $00A0
        FCB     $00,$B7,$C5,1
        FCB     $FF,+66,+54,0
        FCB     $FF,+0,+84,1
        FCB     $FF,$BE,+90,0
        FCB     $FF,$A6,$74,0
        FCB     $00,+90,$8C,0
        FCB     $FF,+0,$B2,2
        FCB     $FF,$A6,$48,0
        FCB     $01


        END

