; can be assembled correctly now
; compatibilty added by Malban
;
; assemble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti moles.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html

*       MOLES.M69 - MOLECULES FOR THE VECTREX.
*       MIKE BLACKWELL  ..  MKB@CMU-CS-C
*       NO COLLUSION DETECTION YET...

*       SOME EXEC ROUTINES WE'LL USE

WAITRCL EQU     $F192           ;WAIT FOR T2 TIMEOUT, RECALIBRATE
DPTOD0  EQU     $F1AA           ;SET DP TO D0 (I/O)
DPTOC8  EQU     $F1AF           ;SET DP TO C8 (RAM)
SWITCHS EQU     $F1B4           ;READ SWITCHES
JOYSTK  EQU     $F1F8           ;READ JOYSTICK
ZAXTO7F EQU     $F2A9           ;SET Z AXIS INTENSITY TO 7F
ZAXTOA  EQU     $F2AB           ;SET Z AXIS INTENSITY TO A
MVD170  EQU     $F308           ;MOVE DOT WITH LONG INTEGRATION
MVD85   EQU     $F30C           ;MOVE DOT WITH MEDIUM INTEGRATION
MOVED   EQU     $F312           ;MOVE DOT WITH LAST INTEGRATION TIME
RES0RF  EQU     $F354           ;RESET ZERO REFERENCE
DRWL1   EQU     $F40C           ;DRAW LINE
DRWL1B  EQU     $F40E           ;DRAW LINE, MAG IN B
RANDOM  EQU     $F517           ;RETURN A RANDOM NUMBER IN A

*       VARIABLE LOCATIONS IN ONBOARD RAM

SW11    EQU     $C812           ;SWITCH 1, CONSOLE 1
SW12    EQU     $C813           ;   "   2,    "    1
SW13    EQU     $C814           ;   "   3,    "    1
SW14    EQU     $C815           ;   "   4,    "    1
JOYVLS  EQU     $C81B           ;JOYSTICK VALUES (4 BYTES)
JOYENS  EQU     $C81F           ;JOYSTICK ENABLES (4 BYTES)
JOYTYP  EQU     $C823           ;JOYSTICK CONVERSION TYPE

MOLMAG  EQU     $C900           ;MAGNIFICATION OF MOLECULES
MOLINT  EQU     $C901           ;INTENSITY OF MOLECULES
DRIFT   EQU     $C902           ;USED BY RANDIT
MOLPOS  EQU     $C903           ;X AND Y POSITIONS FOR 5 MOLECULES (10 BYTES)
MOLVEL  EQU     $C90D           ;X AND Y VELOCITIES FOR 5 MOLECULES (10 BYTES)

*       PROGRAM WILL START AT ZERO (CARTRIDGE START)

        ORG     0

*       CARTRIDGE HEADER BLOCK, INCLUDING STUPID GCE COPYRIGHT (SIGH)

        FCC     'g GCE 0000',$80
        FDB     MUSIC           ;POINTER TO INITIAL MUSIC BLOCK
        FCB     $F8,$50,$20,$D8
        FCC     'MIKE',$27,'S',$80
        FCB     $F8,$50,$00,$C8
        FCC     'MOLECULES',$80,0

START   LDD     #$3075
        STD     $C83D           ;SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        STD     $8              ;START T2

        JSR     >JOYSET         ;SET UP FOR JOYSTICK
        LDA     #20             ;INITIAL MOLECULE SIZE
        STA     MOLMAG
        LDA     #$7F            ;INITIAL MOLECULES AT HALF BRIGHTNESS
        STA     MOLINT

        LDX     #MOLPOS         ;CLEAR ALL POSITIONS AND VELOCITIES
        LDA     #20
STA1    CLR     ,X+
        DECA
        BNE     STA1

LOOP    JSR     WAITRCL         ;WAIT FOR END OF CYCLE
        JSR     >DOJOY          ;READ JOY STICK
        BSR     DOSWTS          ;UPDATE INFO FROM SWITCHES
        LDA     MOLINT
        LSRA                    ;INTENSITIES GO FROM 0 TO $7F
        JSR     ZAXTOA          ;SET NEW MAGNITUDE
        LDX     #MOLPOS         ;POINT TO START OF MOLECULE POSITIONS
        LDA     #5              ;DO FIVE MOLECULE PER ITERATION

NEXTM   PSHS    A               ;STASH MOLECULE COUNT
        TFR     X,Y             ;SAVE PTR TO POSITION PAIR
        LDA     JOYVLS+1        ;CHECK JOYSTICK FOR Y DRIFT
        BSR     RANDIT          ;RANDOMLY ADJUST Y VELOCITY, ADD TO POSITION
        LDA     JOYVLS          ;CHECK JOYSTICK FOR X DRIFT
        BSR     RANDIT          ;RANDOMLY ADJUST X VELOCITY, ADD TO POSITION
        PSHS    X
        TFR     Y,X             ;GET BACK POSITION PTR
        JSR     MVD85           ;MOVE TO NEW MOLECULE LOCATION
        LDX     #OCT            ;POINT TO MOLECULE SHAPE
        LDB     MOLMAG          ;GET MAGNIFICATION
        JSR     DRWL1B          ;DRAW THE MOLECULE
        JSR     RES0RF          ;BACK TO ORIGIN
        PULS    X
        PULS    A
        DECA
        BNE     NEXTM           ;DO NEXT MOLECULE, IF ANY LEFT

        BRA     LOOP


*       GET A RANDOM NUMBER. IF THE BOTTOM 2 BITS ARE BOTH ZERO, THEN RANDOMLY
*       EITHER INCRAMENT OR DECRAMENT THE VELOCITY, WITH AN INCLINATION FOR
*       MOVING IN THE DRIFT DIRECTION. WHAT A HACK!

RANDIT  STA     DRIFT
        JSR     RANDOM          ;GET A RANDOM NUMBER
        TFR     A,B             ;SAVE RANDOM NUMBER IN B
        LDA     10,X            ;GET CURRENT VELOCITY IN A
        LSRB                    ;IF BOTTOM 2 BITS NOT ZERO, JUST UPDATE POS
        BCS     UPPOS
        LSRB
        BCS     UPPOS
        LSRB                    ;SHIFT RANDOM BIT INTO C
        BCC     RAN2            ;IF C CLEAR, DEC, ELSE INC
        CMPA    #2              ;THRESHOLD VELOCITY
        BGE     RAN4            ;IF GREATER OR EQUAL, DON'T INC
        TST     DRIFT
        BGE     RAN1            ;IF DRIFTING IN THE RIGHT DIR, THEN INC
        TSTA
        BGE     RAN4            ;OTHERWISE DON'T GO AGAINST DRIFT
RAN1    INCA
        BRA     RAN4
RAN2    CMPA    #-2
        BLE     RAN4            ;DON'T EXCEED THRESHOLD
        TST     DRIFT
        BLE     RAN3            ;IF DRIFTING OK, THEN DEC OK
        TSTA
        BLE     RAN4            ;DON'T GO AGAINST DRIFT
RAN3    DECA
RAN4    STA     10,X            ;UPDATE VELOCITY
UPPOS   ADDA    ,X              ;ADD POSITION TO VELOCITY
        STA     ,X+             ;UPDATE POSITION, BUMP X
        RTS

*       UPDATE INFO FROM SWITCHES

DOSWTS  CLRA                    ;NORMAL SWITCH MODE
        JSR     SWITCHS         ;READ SWITCHES
        TST     SW11
        BEQ     DOS1
        INC     MOLMAG          ;SWITCH 1 MAKES MOLECULES BIGGER
        BRA     DOS2
DOS1    TST     SW12
        BEQ     DOS2
        DEC     MOLMAG          ;SWITCH 2 MAKES MOLECULES SMALLER
DOS2    LDA     MOLINT
        TST     SW13
        BEQ     DOS3
        INCA                    ;SWITCH 3 MAKES MOLECULES BRIGHTER
        BRA     DOS4
DOS3    TST     SW14
        BEQ     DOS4
        DECA                    ;SWITCH 4 MAKES MOLECULES DIMMER
DOS4    STA     MOLINT
        RTS

*       SET UP JOY STICK ENABLES FOR CONSOLE 1
*       READ THE JOYSTICK

DOJOY   LDA     #1              ;DO SIMPLE READING (+/0/-)
        STA     JOYTYP
        JSR     JOYSTK          ;READ THE STICK
        RTS


JOYSET  LDX     #JOYENS
        LDA     #1              ;CONSOLE 1, LEFT/RIGHT
        STA     ,X+
        LDA     #3              ;CONSOLE 1, UP/DOWN
        STA     ,X+
        CLRA                    ;IGNORE THE OTHER TWO
        STA     ,X+
        STA     ,X+
        RTS


*       LINE DEFINITION FOR A SIMPLE OCTAGON

OCT     FCB     0, 20, 40       ;OFFSET FROM CENTER
        FCB     $FF, 20, $EC
        FCB     $FF, 0, $D8
        FCB     $FF, $EC, $EC
        FCB     $FF, $D8, 0
        FCB     $FF, $EC, 20
        FCB     $FF, 0, 40
        FCB     $FF, 20, 20
        FCB     $FF, 40, 0
        FCB     1               ;END OF OCT


*       THE INITIAL MUSIC BLOCK

MUSIC   FDB     $FEE8           ;MAGIC NUMBERS TO MAKE A PSEUDO
        FDB     $FEB6           ;CHROMATIC PIANO NOISE WITH REVERB
        FCB     0,5, 1,5, 2,5, 3,5, 4,5, 5,5, 6,5, 7,5, 8,5
        FCB     7,5, 6,5, 5,5, 4,5, 3,5, 4,5, 5,5, 6,5, 7,5
        FCB     8,5, 9,7
        FCB     0, $80          ;END OF MUSIC BLOCK

        END
