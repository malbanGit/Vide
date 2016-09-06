
**      DRAW    SUPPORT THE VECTREX AS A GRAPHIC OUTPUT DEVICE FOR DRAWLINE
*
*       This is a device-resident device driver.  It will
*
*       1)      relocate relevant parts of itself into high memory
*       2)      repeatedly draw vectors from the interface memory
*
*       Hmmm.  If I want this solid enough to use, I need better control
*       over the interface.  Let's try flipping interrupts at it.  Note
*       that the interface provides LEVEL interrupts.


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

        ORG     0

        SETDP   $FF

        FCC     'g GCE 1986',80H
        FDB     0FD0DH          NORMAL MUSIC
        FCB     0F8H,050H,000H,0D0H
        FCC     'GRAPHICS',80H
        FCB     0

START   LDX     #MAIN
        LDY     #LASRAM
THROW   LDD     ,X++
        STD     ,Y++            DOUBLE GULP
        CMPX    #ENDMAIN
        BLE     THROW           MOVE RESIDENT CODE
        JMP     >LASRAM         JUMP TO IT?

*PAIN   FCB     0F8H,050H,000H,0D0H
*       FCC     'INTERRUPT',80H
*       FCB     0

VECTORS EQU     00100H

***     ALL CODE PAST THIS POINT MUST BE FULLY RELOCATABLE!

MAIN    LDX     #MSEC20
        STX     >XMSEC
*       LDX     #IIRQ
*       LDA     #$7E
*       STA     ,X+
*       LEAU    OUCH,PCR
*       STU     ,X              SET INTERUPT ADDRESS
*       ANDCC   #$F7            ENABLE INTERRUPTS

LOOP    JSR     >FRAM20         WAIT A WHILE
        LDA     >0              SEE IF MEMORY IS READABLE
        CMPA    #$67
        BNE     LOOP            MEMORY NOT YET OURS
        JSR     >INT3Q          ADJUST BEAM INTENSITY
        LDX     #VECTORS
        BSR     DSO             DISPLAY SOME OBJECTS
        BRA     LOOP

**      DSO - DISPLAY SET OF OBJECTS.
*
*       THIS ROUTINE ATTEMPTS TO PROVIDE A MORE STABLE DISPLAY
*       BY REINITIALIZING THE ZERO REFERENCE BETWEEN OBJECTS.
*       AN OBJECT IS ANY ONE THING THAT THE EXECUTIVE'S DRAW
*       ROUTINES WILL HANDLE.
*
*       ENTRY   ((X)) = FWA OF OBJECT LIST
*
*       EXIT    LIST OF OBJECTS DRAWN.  A DOUBLE TERMINATOR
*               (TWO CONSECUTIVE POSITIVE MODE BYTES) WAS ENCOUNTERED
*
*       ASSUMES THAT THE DRAW ROUTINES IN THE EXECUTIVE EXIT WITH
*               (X) POINTING AT THE TERMINATOR BYTE IT RAN INTO.

DSO     LDA     ,X
        BEQ     DSO1            IF MOVE (ROBUSTING)
        CMPA    #1
        BEQ     DSOX            IF TERMINATOR
        CMPA    #$FF
        BNE     DSOX            IF NOT DRAW
DSO1    JSR     >ZEROIT
        LDA     #UNZERO
        STA     >PPCR           GET OUT OF ZERO MODE!
        JSR     >PAC1X          DRAW IT
        LDA     ,X+
        BRA     DSO             IF MOVE

DSOX    RTS

*       NOP
*       NOP                     SLUSH AREA FOR BUGGY PC-RELATIVE ASSEMBLER
*OUCH   LDU     #PAIN
*       JSR     >TEXSIZ
*       RTI

ENDMAIN RMB     1

        ORG     VECTORS

        FCB     1,1             SET EMPTINESS

        END
