**      Play a tune, an display a graphic representation thereof.
*
*       The first version of this added line segments to the beginning
*       of the list, and moved the whole list up.  This got to be time-
*       consuming if the list was large (many short segments).  This version
*       implements an improvement guided by the edict that data motion is
*       wasteful, and now slogs pointers around instead.  This version is
*       then necessarily somewhat more intricate.

**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.

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
REQ9    RMB     1       "   "  LSB
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
*****   PRECEDING WERE THE MONITOR ENTRY POINTS
*
*       This assembler is so stupid that it cannot fit numbers
*       between -127 and -1 into 8 bits.  ARGH!
*
*       Besides which it has terrible trouble with direct references
*
*       RULE #1:  ANY BIZARRE PROGRAM BEHAVIOR IS VERY PROBABLY
*       THE RESULT OF AN ASSEMBLER BUG, RATHER THAN PROGRAMMER INSANITY!

        ORG     LASRAM

BLANK   RMB     1               AUTO-BLANKING
TONE    RMB     2               LAST TUNE VALUE
WIDTH   RMB     2               HOW WIDE THE SCREEN IS
DISPL   RMB     4               DISPLACEMENT VECTOR
ONE     RMB     2               ADDRESS OF FIRST BUFFER BLOCK
TWO     RMB     2               ADDRESS OF SECOND BUFFER BLOCK

ADDR    EQU     0               BUFFER ADDRESS OFFSET
FINI    EQU     2               TERMINATOR ADDRESS OFFSET
SIZE    EQU     4               DURATION OFFSET

ONEADDR RMB     6               FIRST BUFFER BLOCK
TWOADDR RMB     6               SECOND BUFFER BLOCK

FIRST   RMB     0300H           BUFFER START
LIMIT   RMB     1               BUFFER END

XOFFSET EQU     $48

        ORG     0

        FCC     'g GCE 1066',80H
        FDB     MUSIC
TITLE   FDB     0F850H,030E8H
        FCC     'DAISY',80H,0
        LBRA    START

MSG     FCB     $FC,25,$81,$90
        FCB     '1: SHORTEN',80H
        FCB     $FC,25,$81,$CC
        FCB     '2: INIT',80H
        FCB     $FC,25,$81,$04
        FCB     '< WIDTH > ',80H
        FCB     $FC,25,$81,$48
        FCB     '4: BLANK',80H
        FCB     0

STARTUP LDD     #190
        STD     WIDTH
        LDA     #1
        LDX     #FIRST
        STX     >ONEADDR
        STX     >FINI+ONEADDR   TERMINATOR LOCATION
        LDX     #LIMIT
        STX     >TWOADDR
        STX     >FINI+TWOADDR   TERMINATOR LOCATION
        STA     [ONEADDR]
        STA     [TWOADDR]       SET OTHER TERMINATORS
        LDX     #0
        STX     >SIZE+ONEADDR
        STX     >SIZE+TWOADDR   SET ACCUMULATED SIZES
        LDX     #ONEADDR
        STX     >ONE
        LDX     #TWOADDR
        STX     >TWO            SET BUFFER POINTERS
        CLR     >BLANK
        RTS

**      SHORTEN
*
*       DELETE THE LAST LINE SEGMENT FROM A BUFFER.
*
*       ENTRY   Y = ADDRESS OF 6-BYTE BUFFER DEFINITION BLOCK
*
*       EXIT    Z FLAG REFLECTS NUMBER OF SEGMENTS REMOVED (0 OR MORE)
*
*       USES    D, X.

SHORTEN LDX     FINI,Y
        CMPX    ADDR,Y
        BEQ     RATS            IT'S EMPTY
        LDB     -1,X
        SEX
        ADDD    SIZE,Y          KLUDGE, DURATION IS NEGATIVE
        STD     SIZE,Y          TAKE CARE OF ACCUMULATED DURATION
        LEAX    -6,X
        CMPY    #ONEADDR        SEE IF POSSIBLE SPACE RECOVERY
        BNE     SHRIFT          NOT FRONT BUFFER
        CMPX    ADDR,Y
        BEQ     EMPTY           IT'S GOING TO BE EMPTY, SO RECOVER SPACE
SHRIFT  STX     FINI,Y
        LDA     #1              NEW TERMINATOR
        STA     ,X
RATS    RTS

EMPTY   LDD     #0
        STD     SIZE,Y
        LDX     #FIRST
        STX     ADDR,Y
        BRA     SHRIFT          FINISH UP

START   LDD     >TUNE
        STD     >TONE
        CLR     JRES            ENSURE COLD BOOT NEXT TIME
        LDX     #DISPL          MAKE THE DISPLACEMENT VECTOR
        CLR     ,X+
        LDA     #$B0
        STA     ,X+
        LDA     #XOFFSET
        STA     ,X+
        LDA     #1
        STA     ,X              MADE
        LBSR    STARTUP         INITIALIZE LINE BUFFERS
        LDU     #TOON
        INC     >TSTAT          START TUNE PLAYER
LOOP    JSR     DPRAM
        JSR     REPLAY
        JSR     FRAM20          WAIT FOR END OF CYCLE
        JSR     REQOUT

*       CHECK JOYSTICK

        CLR     DPOT2
        CLR     DPOT3           IGNORE SECOND CONTROLLER
        CLR     DPOT1
        LDA     #1
        STA     DPOT0           I THINK...
        CLR     LIST            USE LEFT/CENTER/RIGHT
        JSR     PBANG4
        LDD     #0
        TST     POT0            BUT DON'T DO ANYTHING WITH IT YET
        BEQ     K0
        LDD     #1
        TST     POT0
        BMI     K0
        LDD     #-1
K0      LDX     WIDTH
        LEAX    D,X
        STX     WIDTH           ADJUST WIDTH

*       CHECK BUTTON PRESSED

        CLRA                    SELECT LEVEL MODE
        JSR     ENPUT
        TST     KEY0
        BEQ     K1              NOTHING PRESSED
        LDY     >TWO
        LBSR    SHORTEN
        BNE     K1              IF SOMETHING SHORTENED
        LDY     >ONE
        LBSR    SHORTEN
K1      TST     KEY1
        BEQ     K2
        LBSR    STARTUP         START OVER

K2      LDD     >TUNE           SEE IF NEW NOTE
        CMPD    >TONE
        BEQ     LIPP            NOPE, SAME OLD NOTE
        STD     >TONE
        LBSR    SHOWIT
        LBSR    TRIM
LIPP    LDX     [ONE]
        DEC     2,X             DRIFT LEFT
        TST     KEY3            SEE IF DISPLAY WANTED
        BEQ     SYNX            NO BLANK
        CLR     >BLANK          RESET AUTO-BLANKING
        BRA     NOTWO

SYNX    JSR     INTMID          ADJUST BEAM INTENSITY
        LDA     #UNZERO
        STA     >PPCR           GET OUT OF ZERO MODE
        LDX     #DISPL
        JSR     PAC1X           MOVE VECTOR TO PROPER PLACE
        LDA     #UNZERO
        STA     >PPCR           GET OUT OF ZERO MODE
        LDX     [ONE]
        LDA     #1
        CMPA    ,X
        BEQ     NOONE           IF EMPTY LIST
        JSR     PAC1X           DISPLAY FIRST VECTOR
        LDA     #UNZERO
        STA     >PPCR           GET OUT OF ZERO MODE
NOONE   LDX     [TWO]
        LDA     #1
        CMPA    ,X
        BEQ     NOTWO           IF LIST EMPTY
        JSR     PAC1X           DISPLAY SECOND VECTOR
NOTWO   JSR     ZEROIT
        JSR     INT3Q           ADJUST BEAM INTENSITY
        LDU     #TITLE
        JSR     TEXSIZ          DISPLAY TUNE TITLE
        TST     KEY3
        BNE     NOTIME          IF BLANKING
        TST     BLANK
        BNE     NOTIME          IF AUTO-BLANKING
        JSR     ZEROIT
        JSR     INTMID
        LEAU    MSG,PCR
        JSR     TEXSIZ
        LDA     #$20
        BITA    >IFR
        BEQ     NOTIME          IF THIS DIDN'T TAKE TOO LONG
        INC     >BLANK
NOTIME  TST     TSTAT
        LBNE    LOOP            QUIT WHEN TUNE ENDS
        JMP     POWER

*       TRIM    REMOVE THINGS FROM OFF SCREEN.
*
*       ENTRY   NONE
*
*       USES    D, U, X, Y.

TRIM    LDY     >TWO
        LDX     SIZE,Y
        LDU     >ONE
        LDD     SIZE,U
        LEAX    D,X             FOR WANT OF     ADDX    SIZE,U
        CMPX    WIDTH
        BLE     MICE            TOTAL SMALL ENOUGH
        LBSR    SHORTEN
        BNE     TRIM            IF SOMETHING REMOVED
TRI1    LDY     >ONE
        LDX     SIZE,Y
        CMPX    WIDTH
        BLE     MICE            TOTAL SMALL ENOUGH
        LBSR    SHORTEN
        BNE     TRI1            IF SOMETHING REMOVED
MICE    RTS

*       PLACE A LINE ON SCREEN. PARAMETERS ARE CURRENT NOTE.

*       1) CHECK TO SEE THAT WE'RE STILL PLAYING A TUNE
*       2) UNBIAS THE TUNE POINTER

*       INVARIANTS:
*       FIRST = LOWEST ALLOWABLE BUFFER ADDRESS
*       LIMIT = HIGHEST ALLOWABLE BUFFER ADDRESS
*       ONEADDR = ADDRESS OF FIRST BUFFER TO SHOW
*       TWOADDR = ADDRESS OF SECOND BUFFER TO SHOW
*       [ONE]+FINI, [TWO]+FINI = LOCATION OF TERMINATOR
*       [ONE]+SIZE, [TWO]+SIZE = ACCUMULATED DURATIONS
*       FIRST <= ONEADDR <= ONEFINI < TWOADDR <= TWOFINI <= LIMIT
*       ONE POINTS TO THE LEADING BUFFER BLOCK
*       TWO POINTS TO THE TRAILING BUFFER BLOCK

*       3) SELECT WHERE TO PUT THE NEW SEGMENT.  THIS IS THE TRICKY PART
*       4) PLACE THE NEW SEGMENT

SHOWIT  TST     TSTAT
        BEQ     MICE            IF NOTHING HAPPENING
        LDU     TUNE
        LEAU    -2,U            KLUDGE TO GET CURRENT NOTE

        LDX     >ONE            GET BLOCK ADDRESS
        LDY     ADDR,X          GET BUFFER START
        LEAY    -6,Y            LOOK FOR ROOM AT FRONT
        CMPX    #ONEADDR        SEE WHICH HALF THIS IS
        BNE     SHO2            IF NOT FRONT HALF
        CMPY    #FIRST
        BLO     SHO1            NO ROOM AT FRONT OF FIRST BUFFER
SHO0    STY     ADDR,X          NEW BUFFER START
        TFR     X,Y
        BRA     ADDHERE         DO IT

SHO1    LDX     >ONE
        LDY     >TWO
        STX     >TWO
        STY     >ONE
        BRA     SHOWIT          SWAP AND TRY AGAIN

SHO2    CMPY    >ONEADDR+FINI   BUMP INTO END OF FIRST BUFFER
        BHI     SHO0            IF ROOM AT FRONT OF SECOND BUFFER
        LDY     #ONEADDR
        LBSR    SHORTEN         WELL, THEN, TRY TO GET SOME
        BNE     SHOWIT          IF WE GOT SOME, TRY AGAIN
        LDY     #TWOADDR        IT WOULDN'T, SO IT'S EMPTY.  SWAP 'EM
        LBSR    SHORTEN         LOP OFF LAST SO THAT THERE'S SOME ROOM

*       MOVE SECOND BUFFER CONTENTS INTO FIRST

        LDY     >TWOADDR+ADDR   SWAP BUFFER POINTERS
        STY     >ONEADDR+ADDR
        LDY     >TWOADDR+FINI
        STY     >ONEADDR+FINI
        LDY     >TWOADDR+SIZE
        STY     >ONEADDR+SIZE
        LDX     #0
        STX     >TWOADDR+SIZE
        LDX     #LIMIT
        STX     >TWOADDR+ADDR
        STX     >TWOADDR+FINI   RE-EMPTY SECOND BUFFER
        LDA     #1
        STA     ,X              SET TERMINATOR
        BRA     SHO1

**      ADDHERE
*
*       ADD THE LINE SEGMENT TO THE FRONT OF THE PREPARED BUFFER.
*
*       ENTRY   Y = ADDRESS OF 6-BYTE BUFFER DEFINITION BLOCK
*               U = ADDRESS OF CURRENT NOTE/DURATION PAIR
*
*       EXIT    THING ADDED
*
*       USES    D, U, X.

ADDHERE LDX     ,Y              GET BUFFER ADDRESS
        CLR     ,X+             MOVE
        LDB     ,U
        STB     ,X+             "PITCH" (Y)
        LDB     1,U
        STB     ,X+             DURATION OFFSET
        CLRA
        LDB     ,U              PITCH AGAIN
        CMPB    #$3F            REST
        BEQ     WICKED          NO REST FOR THE ...
        COMA
WICKED  STA     ,X+             MOVE OR DRAW
        CLR     ,X+             NO PITCH OFFSET
        LDB     1,U
        NEGB
        STB     ,X+             "DURATION"
        CMPX    FINI,Y
        BEQ     STICKY          IF THERE IS ONLY THE ONE ENTRY HERE
        LDA     ,X+             OLD MOVE
        LDA     ,X              OLD PITCH
        SUBA    -6,X            NEW PITCH
        STA     ,X              ADJUSTED PITCH
        LDX     SIZE,Y          ONE OR TWO SIZE
        NEGB                    RECOVER DURATION
        ABX                     ACCUMULATE DURATION
        STX     SIZE,Y          STICK IT BACK
        RTS

*       SINCE THERE IS ONLY ONE ELEMENT IN THIS BUFFER, WE HAVE TO FIX THE
*       FRONT OF THE OTHER, IF PRESENT.

STICKY  NEGB                    SINCE ONLY ONE ENTRY, STUFF AWAY DURATION NOW
        CLRA
        STD     SIZE,Y
        LDX     #ONEADDR        Y IS EITHER ONEADDR OR TWOADDR.  WE WANT OTHER
        CMPY    #ONEADDR
        BNE     CROQUET         Y IS TWOADDR, THUS X REMAINS ONEADDR
        LDX     #TWOADDR
CROQUET LDD     ADDR,X
        CMPD    FINI,X          SEE IF OTHER ONE EMPTY
        BEQ     STAR            NOTHING TO DO
        LDX     ADDR,X          HOP INTO BUFFER
        LDA     ,X+             OLD MOVE
        LDA     ,X              OLD PITCH
        LDY     ADDR,Y          INDIRECT
        SUBA    1,Y             NEW PITCH
        STA     ,X
STAR    RTS

MUSIC   FDB     0ED8FH,0FEB6H
        FCB     0,080H          END OF MUSIC

TOON    FDB     0ED8FH,0FEB6H
        FCB     9,10            WE
        FCB     14,10           WISH
        FCB     14,5            YOU
        FCB     16,5            A
        FCB     14,5            MER-
        FCB     13,5            RY
        FCB     11,10           CHRIST-
        FCB     11,10           MAS
        FCB     11,10           WE
        FCB     16,10           WISH
        FCB     16,5            YOU
        FCB     18,5            A
        FCB     16,5            MER-
        FCB     14,5            RY
        FCB     13,10           CHRIST-
        FCB     9,10            MAS
        FCB     9,10            WE
        FCB     18,10           WISH
        FCB     18,5            YOU
        FCB     19,5            A
        FCB     18,5            MER-
        FCB     16,5            RY
        FCB     14,10           CHRIST-
        FCB     11,10           MAS
        FCB     9,5             AND
        FCB     9,5             A
        FCB     11,10           HAP-
        FCB     16,10           PY
        FCB     13,10           NEW
        FCB     14,20           YEAR
        FCB     $3F,60

        FCB     14,30,11,30,7,30,2,30
        FCB     4,10,6,10,7,10,4,20,7,10,2,60
        FCB     9,30,14,30,11,30,7,30
        FCB     4,10,6,10,7,10,9,20,11,10,9,50
        FCB     11,10,12,10,11,10,9,10,14,20,11,10,9,10,7,40
        FCB     9,10,11,20,7,10,4,20,7,10,4,10,2,40
        FCB     2,10,7,20,11,10,9,20
        FCB     2,10,7,20,11,10,9,10
        FCB     11,10,12,10,14,10,11,10,7,10,9,20,2,10,7,40
        FCB     $3F,60

        FCB     0,5, 1,5, 2,5, 3,5, 4,5, 5,5, 6,5, 7,5, 8,5
        FCB     7,5, 6,5, 5,5, 4,5, 3,5, 4,5, 5,5, 6,5, 7,5
        FCB     8,5, 9,7
        FCB     0, $80          ;END OF MUSIC BLOCK

        END
