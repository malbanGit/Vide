; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti daisynew.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html
;

**      Play a tune, an display a graphic representation thereof.
*
*       The first version of this added line segments to the beginning
*       of the list, and moved the whole list up.  This got to be time-
*       consuming if the list was large (many short segments).  This version
*       implements an improvement guided by the edict that data motion is
*       wasteful, and now slogs pointers around instead.  This version is
*       then necessarily somewhat more intricate.

*       The next order of business, if possible, is to clear PB6 while a tune
*       is playing, in preparation for some other handshaking tasks.


**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.

        BSS
        ORG     $C800   ;RAM
REG0    ds      1       ;MIRROR SOUND CHIP REGS FINE TUNE -A- 8 BIT
REG1    ds      1       ;COARSE TUNE -A- 4 BIT
REG2    ds      1       ;FINE TUNE -B- 8 BIT
REG3    ds      1       ;COARSE TUNE -B- 4 BIT
REG4    ds      1       ;FINE TUNE -C-
REG5    ds      1       ;COARSE TUNE -C-
REG6    ds      1       ;NOISE PER, 5 BIT
REG7    ds      1       ;ENABLE BAR- IN BAR/OUT: IOA,IOB
*                       ;NOISE BAR: C,B,A TONE BAR: C,B,A
REG8    ds      1       ;AMPL -A-, 4 BIT , 5TH BIT OVERRIDE IF=1
REG9    ds      1       ;AMPLITUDE -B-  " "
REGA    ds      1       ;AMPL -C-
REGB    ds      1       ;FINE TUNE ENVELOPE PER, 8 BITS
REGC    ds      1       ;COARSE TUNE ENVELOPE PER, 8 BIT
REGD    ds      1       ;ENVELOPE TYPE, 4 BIT- CONT,ATT,ALT,HOLD
REGE    ds      1       ;PORT A I/O


TRIGGR  ds      2       ;BUTTONS INPUT TO PSG- NEW, LAST
HEDGES  ds      1       ;POS EDGE, 1 BIT PER BUTTON
KEY0    ds      1       ;POS EDGE, 1 BYTE PER BUTTON, POS LOG
KEY1    ds      1
KEY2    ds      1
KEY3    ds      1
KEY4    ds      1
KEY5    ds      1
KEY6    ds      1
KEY7    ds      1

POTRES  ds      1       ;ACCURACY REQ'D FOR POT READ, LESS IS FASTER
*                       ;$40=1 BIT,$20=2 BITS,$01=7 BITS,$00=8 BITS
POT0    ds      1       ;VALUE READ FROM POTS
POT1    ds      1
POT2    ds      1
POT3    ds      1
DPOT0   ds      1       ;DELTA FROM LAST TEST
DPOT1   ds      1
DPOT2   ds      1
DPOT3   ds      1

LIST_   ds      1       ;# OF VECTORS IN PRESENT CHART
ZGO     ds      1       ;IF NONZERO, CAUSES 'ZEROIT' CALL AFTER VECTOR ROUTINES
FRAME   ds      2       ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED
TENSTY  ds      1       ;WAST INSTENITY WEVEL

DWELL   ds      1       ;DOT DWELL TIME, SET IN INITMSC OR AFTER
DASH    ds      1       ;PATTERN FOR DASHED VECTORS


SIZRAS  ds      2       ;FOR RASTER - CONTROLS SLEW RATE
*                       ;SIZE,SIZE+1=Y RATE,X RATE
MESAGE  ds      2       ;START OF STRING


X0      ds      1
X1      ds      1       ;INTERVAL TIMERS
X2      ds      1       ;COUNT DOWN TO 0 PER FRAME IF 'DEKR' CALLED
X3      ds      1
X4      ds      1
X5      ds      1

ABSY    ds      1       ;FOR COMPAS ROUTINE
ABSX    ds      1       ;"
ANGLE   ds      1       ;"
SINE    ds      2       ;VALUE,OVERFLOW
COSINE  ds      2
LEG     ds      1
LAG     ds      1

XMSEC   ds      2       ;REFRESH VALUE, INITMSC SETS TO MSEC20

MSEC20  EQU     $3075   ;LO BYTE, HI
MSEC25  EQU     $7C92
MSEC30  EQU     $C8AF

* - - - - - REGS FOR TUNE PLAYING AND SOUND EFFECTS - - - - -

REQ0    ds      1       ;ENVELOPE TYPE - FOR REQOUT ROUTINE
REQ1    ds      1       ;TUNE ENVELOPE- MSB (INVERTED ORDER OF REG0-D)
REQ2    ds      1       ;"    "       LSB
REQ3    ds      1       ;LEVEL- C
REQ4    ds      1       ;LEVEL- B
REQ5    ds      1       ;LEVEL- A
REQ6    ds      1       ;ENABLES- TONES / NOISE / I-O
REQ7    ds      1       ;TUNE NOISE- 5 BIT
REQ8    ds      1       ;TUNE C- MSB
REQ9    ds      1       ;"   "  LSB
REQA    ds      1       ;TUNE B- MSB
REQB    ds      1       ;"   "  LSB
REQC    ds      1       ;TUNE A- MSB
REQD    ds      1       ;"  "  LSB

CHCF    EQU     REQ8    ;CHANNEL C FREQUENCY
CHBF    EQU     REQA
CHAF    EQU     REQC
NOISEF  EQU     REQ7    ;NOISE FREQ
ENVELF  EQU     REQ1    ;ENVELOPE FREQ

CHCV    EQU     REQ3    ;CHANNEL C VOLUME
CHBV    EQU     REQ4
CHAV    EQU     REQ5

SENABL  EQU     REQ6    ;SOUND ENABLE

DOREMI  ds      2       ;BASE TABLE 2OR NOTES USUALLY=NOTES
FADE    ds      2       ;FOR TUNE PLAYER USE
VIBE    ds      2
TUNE    ds      2
NEWGEN  ds      1
TSTAT   ds      1
RESTC   ds      1
RATEA   ds      1
VIBA    ds      1
RATEB   ds      1       ;VIBRATO
VIBB    ds      1
RATEC   ds      1
VIBC    ds      1
FADEA   ds      1
FADEB   ds      1
FADEC   ds      1
TONEA   ds      2       ;FREQ BEFORE VIBE
TONEB   ds      2
TONEC   ds      2

* - - - - - REGS FOR SOUND EFFECTS - - - - -

SATUS   ds      1       ;GAME-SOUNDS INTERFACE
LATUS   ds      1       ;LAST 'SATUS' VALUE
XATUS   ds      1       ;", EXPLOSION TYPE
GAP     ds      1       ;TIMES HOLD IN BACKGROUND SOUND
B1FREQ  ds      2
B2FREQ  ds      2
F1FREQ  ds      2
FEAST   ds      1       ;FIRING STATE COUNTER
PEDGE   ds      1       ;POSITIVE EDGE OF 'SATUS'
NEDGE   ds      1       ;NEGATIVE EDGE OF 'SATUS'
K1FREQ  ds      2       ;BACKGROUND FREQ 1
BACON   ds      1       ;" SEQUENCER
XACON   ds      1       ;EXPLO SEQ
SPEKT   ds      1       ;EXPL SPECTR

PLAYRZ  ds      1       ;# PLAYERS IN GAME
GAMZ    ds      1       ;GAME # OPTION

SEED    ds      2       ;POINTER TO 3 BYTE RANDOM #, USUALLY IS RANCID
RANCID  ds      3


LASRAM  EQU     *

RAMMES  EQU     $CA00

        ORG     $CBEA
STACK   ds      1
HEIGH   ds      7       ;TITLE PAGE HIGH SCORE
;INMI    ds      0
;ISWI3   ds      0
ISWI2   ds      3
IFIRQ   ds      3
IIRQ    ds      3
ISWI    ds      3
JRES    ds      2

        ORG     $D000   ;I/O
BPORT   ds      1
APORT   ds      1
BPORTD  ds      1
APORTD  ds      1
T1LOLC  ds      1
T1HOC   ds      1
T1LOL   ds      1
T1HOL   ds      1
T2LOLC  ds      1
T2HOC   ds      1
SR      ds      1
ACR     ds      1
PPCR    ds      1
IFR     ds      1
IER     ds      1
ORAIRA  ds      1


DAC     EQU     APORT   ;FOR HUMAN INTERFACE
PORT    EQU     BPORT   ;MAIN CONTROL PORT
ZERO    EQU     $CC     ;CODE TO PCR ZERO INTEGRATORS
UNZERO  EQU     $CE     ;CORE FOR RELEASE HOLD ZERO
SCAL1X  EQU     $7F     ;TIMING PARAMETERS FOR VECTOR WRITE
SCAL2X  EQU     $FF
CARTS   EQU     $0      ;ADDRESS OF EXTERNAL ROM PACK
ROMS    EQU     $F000   ;ADDRESS OF ON-BOARD ROM
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

        CODE
        ORG     0

        DB      'g GCE 1066',$80
        FDB     MUSIC
TITLE_  FDB     $F850,$30E8
        DB      'DAISY',$80,0
        JMP     >START

*       ORG     LASRAM

JUNK    ds      300
        FCC     'DATA HERE -->'

TONE    ds      2               ;LAST TUNE VALUE
DISPL   ds      4               ;DISPLACEMENT VECTOR
ONE     ds      2               ;ADDRESS OF FIRST BUFFER BLOCK
TWO     ds      2               ;ADDRESS OF SECOND BUFFER BLOCK

ADDR_   EQU     0               ;BUFFER ADDRESS OFFSET
FINI    EQU     2               ;TERMINATOR ADDRESS OFFSET
SIZE    EQU     4               ;DURATION OFFSET

ONEADDR ds      6               ;FIRST BUFFER BLOCK
TWOADDR ds      6               ;SECOND BUFFER BLOCK

FIRST   ds      $34             ;BUFFER START SHORTENED FOR DEBUGGING
LIMIT   ds      1               ;BUFFER END

XOFFSET EQU     $48

START   LDD     >TUNE
        STD     >TONE
        CLR     JRES            ;ENSURE COLD BOOT NEXT TIME
        LDX     #DISPL          ;MAKE THE DISPLACEMENT VECTOR
        CLR     ,X+
        LDA     #$B0
        STA     ,X+
        LDA     #XOFFSET
        STA     ,X+
        LDA     #1
        STA     ,X              ;MADE
        LDX     #FIRST
        STX     >ONEADDR
        STX     >FINI+ONEADDR   ;TERMINATOR LOCATION
        LDX     #LIMIT
        STX     >TWOADDR
        STX     >FINI+TWOADDR   ;TERMINATOR LOCATION
        STA     [ONEADDR]
        STA     [TWOADDR]       ;SET OTHER TERMINATORS
        LDX     #0
        STX     >SIZE+ONEADDR
        STX     >SIZE+TWOADDR   ;SET ACCUMULATED SIZES
        LDX     #ONEADDR
        STX     >ONE
        LDX     #TWOADDR
        STX     >TWO            ;SET BUFFER POINTERS
        LDU     #TOON
        INC     >TSTAT          ;START TUNE PLAYER
LOOP    LDA     PORT            ;TRY TO SET PB6
        ORA     #$40
        STA     PORT            ;THIS SEEMS TO HAVE NO EFFECT
        JSR     DPRAM
        JSR     REPLAY
        JSR     FRAM20          ;WAIT FOR END OF CYCLE
        JSR     REQOUT
        LDA     PORT            ;TRY TO CLEAR PB6
        ANDA    #$BF
        STA     PORT            ;THIS SEEMS TO HAVE NO EFFECT
        LDD     >TUNE           ;SEE IF NEW NOTE
        CMPD    >TONE
        BEQ     LIPP            ;NOPE, SAME OLD NOTE
        STD     >TONE
        LBSR    SHOWIT
        BSR     TRIM
LIPP    LDX     [ONE]
        DEC     2,X             ;DRIFT LEFT
        JSR     INTMID          ;ADJUST BEAM INTENSITY
        LDA     #UNZERO
        STA     >PPCR           ;GET OUT OF ZERO MODE
        LDX     #DISPL
        JSR     PAC1X           ;MOVE VECTOR TO PROPER PLACE
        LDA     #UNZERO
        STA     >PPCR           ;GET OUT OF ZERO MODE
        LDX     [ONE]
        LDA     #1
        CMPA    ,X
        BEQ     NOONE           ;IF EMPTY LIST
        JSR     PAC1X           ;DISPLAY FIRST VECTOR
        LDA     #UNZERO
        STA     >PPCR           ;GET OUT OF ZERO MODE
NOONE   LDX     [TWO]
        LDA     #1
        CMPA    ,X
        BEQ     NOTWO           ;IF LIST EMPTY
        JSR     PAC1X           ;DISPLAY SECOND VECTOR
NOTWO   JSR     ZEROIT
        JSR     INT3Q           ;ADJUST BEAM INTENSITY
        LDU     #TITLE_
        JSR     TEXSIZ          ;DISPLAY TUNE TITLE
        LDA     TSTAT
        LBNE    LOOP            ;QUIT WHEN TUNE ENDS
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
        LEAX    D,X             ;FOR WANT OF     ADDX    SIZE,U
        CMPX    #190
        BLE     MICE            ;TOTAL SMALL ENOUGH
        LBSR    SHORTEN
        BNE     TRIM            ;IF SOMETHING REMOVED
TRI1    LDY     >ONE
        LDX     SIZE,Y
        CMPX    #190
        BLE     MICE            ;TOTAL SMALL ENOUGH
        LBSR    SHORTEN
        BNE     TRI1            ;IF SOMETHING REMOVED
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

SHOWIT  LDA     TSTAT
        BEQ     MICE            ;IF NOTHING HAPPENING
        LDU     TUNE
        LEAU    -2,U            ;KLUDGE TO GET CURRENT NOTE

        LDX     >ONE            ;GET BLOCK ADDRESS
        LDY     ADDR_,X          ;GET BUFFER START
        LEAY    -6,Y            ;LOOK FOR ROOM AT FRONT
        CMPX    #ONEADDR        ;SEE WHICH HALF THIS IS
        BNE     SHO2            ;IF NOT FRONT HALF
        CMPY    #FIRST
        BLO     SHO1            ;NO ROOM AT FRONT OF FIRST BUFFER
SHO0    STY     ADDR_,X          ;NEW BUFFER START
        TFR     X,Y
        BRA     ADDHERE         ;DO IT

SHO1    LDX     >ONE
        LDY     >TWO
        STX     >TWO
        STY     >ONE
        BRA     SHOWIT          ;SWAP AND TRY AGAIN

SHO2    CMPY    >ONEADDR+FINI   ;BUMP INTO END OF FIRST BUFFER
        BHI     SHO0            ;IF ROOM AT FRONT OF SECOND BUFFER
        LDY     #ONEADDR
        BSR     SHORTEN         ;WELL, THEN, TRY TO GET SOME
        BNE     SHOWIT          ;IF WE GOT SOME, TRY AGAIN
        LDY     #TWOADDR        ;IT WOULDN'T, SO IT'S EMPTY.  SWAP 'EM
        BSR     SHORTEN         ;LOP OFF LAST SO THAT THERE'S SOME ROOM

*       MOVE SECOND BUFFER CONTENTS INTO FIRST

        LDY     >TWOADDR+ADDR_   ;SWAP BUFFER POINTERS
        STY     >ONEADDR+ADDR_
        LDY     >TWOADDR+FINI
        STY     >ONEADDR+FINI
        LDY     >TWOADDR+SIZE
        STY     >ONEADDR+SIZE
        LDX     #0
        STX     >TWOADDR+SIZE
        LDX     #LIMIT
        STX     >TWOADDR+ADDR_
        STX     >TWOADDR+FINI   ;RE-EMPTY SECOND BUFFER
        LDA     #1
        STA     ,X              ;SET TERMINATOR
        BRA     SHO1

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
        CMPX    ADDR_,Y
        BEQ     RATS            ;IT'S EMPTY
        LDB     -1,X
        SEX
        ADDD    SIZE,Y          ;KLUDGE, DURATION IS NEGATIVE
        STD     SIZE,Y          ;TAKE CARE OF ACCUMULATED DURATION
        LEAX    -6,X
        CMPY    #ONEADDR        ;SEE IF POSSIBLE SPACE RECOVERY
        BNE     SHRIFT          ;NOT FRONT BUFFER
        CMPX    ADDR_,Y
        BEQ     EMPTY           ;IT'S GOING TO BE EMPTY, SO RECOVER SPACE
SHRIFT  STX     FINI,Y
        LDA     #1              ;NEW TERMINATOR
        STA     ,X
RATS    RTS

EMPTY   LDD     #0
        STD     SIZE,Y
        LDX     #FIRST
        STX     ADDR_,Y
        BRA     SHRIFT          ;FINISH UP

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

ADDHERE LDX     ,Y              ;GET BUFFER ADDRESS
        CLR     ,X+             ;MOVE
        LDB     ,U
        STB     ,X+             ;"PITCH" (Y)
        LDB     1,U
        STB     ,X+             ;DURATION OFFSET
        CLRA
        LDB     ,U              ;PITCH AGAIN
        CMPB    #$3F            ;REST
        BEQ     WICKED          ;NO REST FOR THE ...
        COMA
WICKED  STA     ,X+             ;MOVE OR DRAW
        CLR     ,X+             ;NO PITCH OFFSET
        LDB     1,U
        NEGB
        STB     ,X+             ;"DURATION"
        CMPX    FINI,Y
        BEQ     STICKY          ;IF THERE IS ONLY THE ONE ENTRY HERE
        LDA     ,X+             ;OLD MOVE
        LDA     ,X              ;OLD PITCH
        SUBA    -6,X            ;NEW PITCH
        STA     ,X              ;ADJUSTED PITCH
        LDX     SIZE,Y          ;ONE OR TWO SIZE
        NEGB                    ;RECOVER DURATION
        ABX                     ;ACCUMULATE DURATION
        STX     SIZE,Y          ;STICK IT BACK
        RTS

*       SINCE THERE IS ONLY ONE ELEMENT IN THIS BUFFER, WE HAVE TO FIX THE
*       FRONT OF THE OTHER, IF PRESENT.

STICKY  NEGB                    ;SINCE ONLY ONE ENTRY, STUFF AWAY DURATION NOW
        CLRA
        STD     SIZE,Y
        LDX     #ONEADDR        ;Y IS EITHER ONEADDR OR TWOADDR.  WE WANT OTHER
        CMPY    #ONEADDR
        BNE     CROQUET         ;Y IS TWOADDR, THUS X REMAINS ONEADDR
        LDX     #TWOADDR
CROQUET LDD     ADDR_,X
        CMPD    FINI,X          ;SEE IF OTHER ONE EMPTY
        BEQ     RATS            ;NOTHING TO DO
        LDX     ADDR_,X          ;HOP INTO BUFFER
        LDA     ,X+             ;OLD MOVE
        LDA     ,X              ;OLD PITCH
        LDY     ADDR_,Y          ;INDIRECT
        SUBA    1,Y             ;NEW PITCH
        STA     ,X
        RTS

MUSIC   FDB     $ED8F,$FEB6
        FCB     0,$80           ;END OF MUSIC

TOON    FDB     $ED8F,$FEB6   ;
        FCB     9,10            ;WE
        FCB     14,10           ;WISH
        FCB     14,5            ;YOU
        FCB     16,5            ;A
        FCB     14,5            ;MER-
        FCB     13,5            ;RY
        FCB     11,10           ;CHRIST-
        FCB     11,10           ;MAS
        FCB     11,10           ;WE
        FCB     16,10           ;WISH
        FCB     16,5            ;YOU
        FCB     18,5            ;A
        FCB     16,5            ;MER-
        FCB     14,5            ;RY
        FCB     13,10           ;CHRIST-
        FCB     9,10            ;MAS
        FCB     9,10            ;WE
        FCB     18,10           ;WISH
        FCB     18,5            ;YOU
        FCB     19,5            ;A
        FCB     18,5            ;MER-
        FCB     16,5            ;RY
        FCB     14,10           ;CHRIST-
        FCB     11,10           ;MAS
        FCB     9,5             ;AND
        FCB     9,5             ;A
        FCB     11,10           ;HAP-
        FCB     16,10           ;PY
        FCB     13,10           ;NEW
        FCB     14,20           ;YEAR
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
