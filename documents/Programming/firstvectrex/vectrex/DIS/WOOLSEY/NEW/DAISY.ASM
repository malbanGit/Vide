; can be assembled correctly now
; compatibilty added by Malban
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti daisy.asm >error
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

**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.

        BSS
        ORG     $C800  ;RAM
REG0    DS     1       ;MIRROR SOUND CHIP REGS FINE TUNE -A- 8 BIT
REG1    DS     1       ;COARSE TUNE -A- 4 BIT
REG2    DS     1       ;FINE TUNE -B- 8 BIT
REG3    DS     1       ;COARSE TUNE -B- 4 BIT
REG4    DS     1       ;FINE TUNE -C-
REG5    DS     1       ;COARSE TUNE -C-
REG6    DS     1       ;NOISE PER, 5 BIT
REG7    DS     1       ;ENABLE BAR- IN BAR/OUT: IOA,IOB
*                       NOISE BAR: C,B,A TONE BAR: C,B,A
REG8    DS     1       ;AMPL -A-, 4 BIT , 5TH BIT OVERRIDE IF=1
REG9    DS     1       ;AMPLITUDE -B-  " "
REGA    DS     1       ;AMPL -C-
REGB    DS     1       ;FINE TUNE ENVELOPE PER, 8 BITS
REGC    DS     1       ;COARSE TUNE ENVELOPE PER, 8 BIT
REGD    DS     1       ;ENVELOPE TYPE, 4 BIT- CONT,ATT,ALT,HOLD
REGE    DS     1       ;PORT A I/O


TRIGGR  DS     2       ;BUTTONS INPUT TO PSG- NEW, LAST
HEDGES  DS     1       ;POS EDGE, 1 BIT PER BUTTON
KEY0    DS     1       ;POS EDGE, 1 BYTE PER BUTTON, POS LOG
KEY1    DS     1
KEY2    DS     1
KEY3    DS     1
KEY4    DS     1
KEY5    DS     1
KEY6    DS     1
KEY7    DS     1

POTRES  DS     1       ;ACCURACY REQ'D FOR POT READ, LESS IS FASTER
*                       $40=1 BIT,$20=2 BITS,$01=7 BITS,$00=8 BITS
POT0    DS     1       ;VALUE READ FROM POTS
POT1    DS     1
POT2    DS     1
POT3    DS     1
DPOT0   DS     1       ;DELTA FROM LAST TEST
DPOT1   DS     1
DPOT2   DS     1
DPOT3   DS     1

LIST_   DS     1       ;# OF VECTORS IN PRESENT CHART
ZGO     DS     1       ;IF NONZERO, CAUSES 'ZEROIT' CALL AFTER VECTOR ROUTINES
FRAME   DS     2       ;INCRS EVERY TIME FRAM20 OR FRAM30 CALLED
TENSTY  DS     1       ;WAST INSTENITY WEVEL

DWELL   DS     1       ;DOT DWELL TIME, SET IN INITMSC OR AFTER
DASH    DS     1       ;PATTERN FOR DASHED VECTORS


SIZRAS  DS     2       ;FOR RASTER - CONTROLS SLEW RATE
*                       SIZE,SIZE+1=Y RATE,X RATE
MESAGE  DS     2       ;START OF STRING


X0      DS     1
X1      DS     1       ;INTERVAL TIMERS
X2      DS     1       ;COUNT DOWN TO 0 PER FRAME IF 'DEKR' CALLED
X3      DS     1
X4      DS     1
X5      DS     1

ABSY    DS     1       ;FOR COMPAS ROUTINE
ABSX    DS     1       ;"
ANGLE   DS     1       ;"
SINE    DS     2       ;VALUE,OVERFLOW
COSINE  DS     2
LEG     DS     1
LAG     DS     1

XMSEC   DS     2       ;REFRESH VALUE, INITMSC SETS TO MSEC20

MSEC20  EQU     $3075  ; LO BYTE, HI
MSEC25  EQU     $7C92
MSEC30  EQU     $C8AF

* - - - - - REGS FOR TUNE PLAYING AND SOUND EFFECTS - - - - -

REQ0    DS     1       ;ENVELOPE TYPE - FOR REQOUT ROUTINE
REQ1    DS     1       ;TUNE ENVELOPE- MSB (INVERTED ORDER OF REG0-D)
REQ2    DS     1       ;"    "       LSB
REQ3    DS     1       ;LEVEL- C
REQ4    DS     1       ;LEVEL- B
REQ5    DS     1       ;LEVEL- A
REQ6    DS     1       ;ENABLES- TONES / NOISE / I-O
REQ7    DS     1       ;TUNE NOISE- 5 BIT
REQ8    DS     1       ;TUNE C- MSB
REQ9    DS     1       ;"   "  LSB
REQA    DS     1       ;TUNE B- MSB
REQB    DS     1       ;"   "  LSB
REQC    DS     1       ;TUNE A- MSB
REQD    DS     1       ;"  "  LSB

CHCF    EQU     REQ8   ; CHANNEL C FREQUENCY
CHBF    EQU     REQA
CHAF    EQU     REQC
NOISEF  EQU     REQ7   ; NOISE FREQ
ENVELF  EQU     REQ1   ; ENVELOPE FREQ

CHCV    EQU     REQ3   ; CHANNEL C VOLUME
CHBV    EQU     REQ4
CHAV    EQU     REQ5

SENABL  EQU     REQ6   ; SOUND ENABLE

DOREMI  DS     2       ;BASE TABLE 2OR NOTES USUALLY=NOTES
FADE    DS     2       ;FOR TUNE PLAYER USE
VIBE    DS     2
TUNE    DS     2
NEWGEN  DS     1
TSTAT   DS     1
RESTC   DS     1
RATEA   DS     1
VIBA    DS     1
RATEB   DS     1       ;VIBRATO
VIBB    DS     1
RATEC   DS     1
VIBC    DS     1
FADEA   DS     1
FADEB   DS     1
FADEC   DS     1
TONEA   DS     2       ;FREQ BEFORE VIBE
TONEB   DS     2
TONEC   DS     2

* - - - - - REGS FOR SOUND EFFECTS - - - - -

SATUS   DS     1       ;GAME-SOUNDS INTERFACE
LATUS   DS     1       ;LAST 'SATUS' VALUE
XATUS   DS     1       ;", EXPLOSION TYPE
GAP     DS     1       ;TIMES HOLD IN BACKGROUND SOUND
B1FREQ  DS     2
B2FREQ  DS     2
F1FREQ  DS     2
FEAST   DS     1       ;FIRING STATE COUNTER
PEDGE   DS     1       ;POSITIVE EDGE OF 'SATUS'
NEDGE   DS     1       ;NEGATIVE EDGE OF 'SATUS'
K1FREQ  DS     2       ;BACKGROUND FREQ 1
BACON   DS     1       ;" SEQUENCER
XACON   DS     1       ;EXPLO SEQ
SPEKT   DS     1       ;EXPL SPECTR

PLAYRZ  DS     1       ;# PLAYERS IN GAME
GAMZ    DS     1       ;GAME # OPTION

SEED    DS     2       ;POINTER TO 3 BYTE RANDOM #, USUALLY IS RANCID
RANCID  DS     3


LASRAM  EQU     *


RAMMES  EQU     $CA00

        ORG     $CBEA

STACK   DS     1
HEIGH   DS     7       ;TITLE PAGE HIGH SCORE
;INMI    DS     0
;ISWI3   DS     0
ISWI2   DS     3
IFIRQ   DS     3
IIRQ    DS     3
ISWI    DS     3
JRES    DS     2

        ORG     $D000  ; I/O

BPORT   DS     1
APORT   DS     1
BPORTD  DS     1
APORTD  DS     1
T1LOLC  DS     1
T1HOC   DS     1
T1LOL   DS     1
T1HOL   DS     1
T2LOLC  DS     1
T2HOC   DS     1
SR      DS     1
ACR     DS     1
PPCR    DS     1
IFR     DS     1
IER     DS     1
ORAIRA  DS     1


DAC     EQU     APORT  ; FOR HUMAN INTERFACE
PORT    EQU     BPORT  ; MAIN CONTROL PORT
ZERO    EQU     $CC    ; CODE TO PCR ZERO INTEGRATORS
UNZERO  EQU     $CE    ; CORE FOR RELEASE HOLD ZERO
SCAL1X  EQU     $7F    ; TIMING PARAMETERS FOR VECTOR WRITE
SCAL2X  EQU     $FF
CARTS   EQU     $0     ; ADDRESS OF EXTERNAL ROM PACK
ROMS    EQU     $F000  ; ADDRESS OF ON-BOARD ROM
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

BLANK   DS     1       ;        AUTO-BLANKING
TONE    DS     2       ;        LAST TUNE VALUE
WIDTH   DS     2       ;        HOW WIDE THE SCREEN IS
DISPL   DS     4       ;        DISPLACEMENT VECTOR
ONE     DS     2       ;        ADDRESS OF FIRST BUFFER BLOCK
TWO     DS     2       ;        ADDRESS OF SECOND BUFFER BLOCK

ADDR_   EQU     0      ;         BUFFER ADDRESS OFFSET
FINI    EQU     2      ;         TERMINATOR ADDRESS OFFSET
SIZE    EQU     4      ;         DURATION OFFSET

ONEADDR DS     6       ;        FIRST BUFFER BLOCK
TWOADDR DS     6       ;        SECOND BUFFER BLOCK

FIRST   DS     $300    ;        BUFFER START
LIMIT   DS     1       ;        BUFFER END

XOFFSET EQU     $48

        CODE
        ORG     0

        DB     'g GCE 1066',$80
        FDB     MUSIC
TITLE_  FDB     $F850,$30E8
        DB     'DAISY',$80,0
        LBRA    START

MSG     DB     $FC,25,$81,$90
        DB     '1: SHORTEN',$80
        DB     $FC,25,$81,$CC
        DB     '2: INIT',$80
        DB     $FC,25,$81,$04
        DB     '< WIDTH > ',$80
        DB     $FC,25,$81,$48
        DB     '4: BLANK',$80
        DB     0

STARTUP LDD     #190
        STD     WIDTH
        LDA     #1
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
        LBSR    STARTUP         ;INITIALIZE LINE BUFFERS
        LDU     #TOON
        INC     >TSTAT          ;START TUNE PLAYER
LOOP    JSR     DPRAM
        JSR     REPLAY
        JSR     FRAM20          ;WAIT FOR END OF CYCLE
        JSR     REQOUT

*       CHECK JOYSTICK

        CLR     DPOT2
        CLR     DPOT3           ;IGNORE SECOND CONTROLLER
        CLR     DPOT1
        LDA     #1
        STA     DPOT0           ;I THINK...
        CLR     LIST_           ;USE LEFT/CENTER/RIGHT
        JSR     PBANG4
        LDD     #0
        TST     POT0            ;BUT DON'T DO ANYTHING WITH IT YET
        BEQ     K0
        LDD     #1
        TST     POT0
        BMI     K0
        LDD     #-1
K0      LDX     WIDTH
        LEAX    D,X
        STX     WIDTH           ;ADJUST WIDTH

*       CHECK BUTTON PRESSED

        CLRA                    ;SELECT LEVEL MODE
        JSR     ENPUT
        TST     KEY0
        BEQ     K1              ;NOTHING PRESSED
        LDY     >TWO
        LBSR    SHORTEN
        BNE     K1              ;IF SOMETHING SHORTENED
        LDY     >ONE
        LBSR    SHORTEN
K1      TST     KEY1
        BEQ     K2
        LBSR    STARTUP         ;START OVER

K2      LDD     >TUNE           ;SEE IF NEW NOTE
        CMPD    >TONE
        BEQ     LIPP            ;NOPE, SAME OLD NOTE
        STD     >TONE
        LBSR    SHOWIT
        LBSR    TRIM
LIPP    LDX     [ONE]
        DEC     2,X             ;DRIFT LEFT
        TST     KEY3            ;SEE IF DISPLAY WANTED
        BEQ     SYNX            ;NO BLANK
        CLR     >BLANK          ;RESET AUTO-BLANKING
        BRA     NOTWO

SYNX    JSR     INTMID          ;ADJUST BEAM INTENSITY
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
        TST     KEY3
        BNE     NOTIME          ;IF BLANKING
        TST     BLANK
        BNE     NOTIME          ;IF AUTO-BLANKING
        JSR     ZEROIT
        JSR     INTMID
        LEAU    MSG,PC; PCR
        JSR     TEXSIZ
        LDA     #$20
        BITA    >IFR
        BEQ     NOTIME          ;IF THIS DIDN'T TAKE TOO LONG
        INC     >BLANK
NOTIME  TST     TSTAT
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
        CMPX    WIDTH
        BLE     MICE            ;TOTAL SMALL ENOUGH
        LBSR    SHORTEN
        BNE     TRIM            ;IF SOMETHING REMOVED
TRI1    LDY     >ONE
        LDX     SIZE,Y
        CMPX    WIDTH
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

SHOWIT  TST     TSTAT
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
        LBSR    SHORTEN         ;WELL, THEN, TRY TO GET SOME
        BNE     SHOWIT          ;IF WE GOT SOME, TRY AGAIN
        LDY     #TWOADDR        ;IT WOULDN'T, SO IT'S EMPTY.  SWAP 'EM
        LBSR    SHORTEN         ;LOP OFF LAST SO THAT THERE'S SOME ROOM

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
        BEQ     STAR            ;NOTHING TO DO
        LDX     ADDR_,X          ;HOP INTO BUFFER
        LDA     ,X+             ;OLD MOVE
        LDA     ,X              ;OLD PITCH
        LDY     ADDR_,Y          ;INDIRECT
        SUBA    1,Y             ;NEW PITCH
        STA     ,X
STAR    RTS

MUSIC   FDB    $ED8F,$FEB6
        DB     0,$80          ;END OF MUSIC

TOON    FDB    $ED8F,$FEB6
        DB     9,10            ;WE
        DB     14,10           ;WISH
        DB     14,5            ;YOU
        DB     16,5            ;A
        DB     14,5            ;MER-
        DB     13,5            ;RY
        DB     11,10           ;CHRIST-
        DB     11,10           ;MAS
        DB     11,10           ;WE
        DB     16,10           ;WISH
        DB     16,5            ;YOU
        DB     18,5            ;A
        DB     16,5            ;MER-
        DB     14,5            ;RY
        DB     13,10           ;CHRIST-
        DB     9,10            ;MAS
        DB     9,10            ;WE
        DB     18,10           ;WISH
        DB     18,5            ;YOU
        DB     19,5            ;A
        DB     18,5            ;MER-
        DB     16,5            ;RY
        DB     14,10           ;CHRIST-
        DB     11,10           ;MAS
        DB     9,5             ;AND
        DB     9,5             ;A
        DB     11,10           ;HAP-
        DB     16,10           ;PY
        DB     13,10           ;NEW
        DB     14,20           ;YEAR
        DB     $3F,60

        DB     14,30,11,30,7,30,2,30
        DB     4,10,6,10,7,10,4,20,7,10,2,60
        DB     9,30,14,30,11,30,7,30
        DB     4,10,6,10,7,10,9,20,11,10,9,50
        DB     11,10,12,10,11,10,9,10,14,20,11,10,9,10,7,40
        DB     9,10,11,20,7,10,4,20,7,10,4,10,2,40
        DB     2,10,7,20,11,10,9,20
        DB     2,10,7,20,11,10,9,10
        DB     11,10,12,10,14,10,11,10,7,10,9,20,2,10,7,40
        DB     $3F,60

        DB     0,5, 1,5, 2,5, 3,5, 4,5, 5,5, 6,5, 7,5, 8,5
        DB     7,5, 6,5, 5,5, 4,5, 3,5, 4,5, 5,5, 6,5, 7,5
        DB     8,5, 9,7
        DB     0, $80          ;END OF MUSIC BLOCK

        END
