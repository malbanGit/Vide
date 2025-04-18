; can be assembled correctly now
; compatibilty added by Malban
; (removed a small scoring display bug)
;
; assenmble with comand line:
; .\ass\as09.exe -w200 -h0 -l -mcti etch.asm >error
;
; used the 6809 assembler:
; as09 [1.11].
; Copyright 1990-1994, Frank A. Vorstenbosch, Kingswood Software.
; Available at:
; http://www.falstaff.demon.co.uk/cross.html

; FRED    EQU     $C900;$0300           ; 0C900H GOOD PLACE FOR VECTOR LIST
;
; didn't look further into it.
; there seem to be some difficulties, when it reaches some bounds, though
; this might be only the case with the emulator, or the vector locations
; being in RAM rather than ROM.



**      Etch-a-sketch program.
*
*       Rudimentary exercise in drawing arbitrary objects using the
*       joystick.  Requires that the memory it runs in be writable.

**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.


*       This assembler is so stupid that it cannot fit numbers
*       between -127 and -1 into 8 bits.  ARGH!
*
*       Not only that, but it cannot find source files whose names
*       are eight characters long
*
*       Not to mention the infuriating and difficult-to-describe
*       bug in label accuracy.
*

DPTOC8  EQU     $F1AF
DPTOD0  EQU     $F1AA
DRAWL1B EQU     $F40E
JOYSTCK EQU     $F1F8
PRINTU  EQU     $F385
RESET0  EQU     $F354
SWITCH  EQU     $F1B4
WAIRCAL EQU     $F192
XAXTO7F EQU     $F2A9
XAXTO5F EQU     $F2A5

SW1C1   EQU     $C812           ; SWITCH 1, CONSOLE 1
SW1C2   EQU     SW1C1+1
SW1C3   EQU     SW1C2+1
SW1C4   EQU     SW1C3+1
SCORE   EQU     $CBF0           ; BOOT DISPLAYED SCORE ADDRESS
ZFLAG   EQU     $C824           ; RESET TO 0 AFTER EACH LINE BLOCK
VTEMP   EQU     $C8F9           ; TEMPORARY VECTOR LOCATION
VOBJ    EQU     $C8FC           ; POINTER TO START OF CURRENT OBJECT
VLIMIT  EQU     $C8FE           ; SIZE OF VECTOR LIST, EXCLUDING CURSOR
FRED    EQU     $C900;$0300           ; 0C900H GOOD PLACE FOR VECTOR LIST
CURSIZ  EQU     20              ; BYTES OF CURSOR TO MOVE AROUND

        ORG     0
        direct -1

        DB      "g GCE 1986",$80
        FDB     MUSIC
        FCB     $F8,$50,$40,$E8
        DB      "ETCH",$80
        FCB     $F8,$50,$18,$F8
        DB      "A ",$80
        FCB     $F8,$50,$F0,$E0
        DB      "SKETCH",$80
        FCB     0

        BRA     START

**      ADDVEC - ADD A VECTOR TO THE LIST.
*
*       ENTRY   ((X)) = VECTOR TRIPLET
*
*       EXIT    TRIPLET ADDED
*               (VLIMIT) UPDATED
*               (X) AT END OF VECTOR
*
*       USES    A, D, X, Y

ADDVEC  LDB     #CURSIZ
        LDY     VLIMIT
        LEAY    B,Y             ; ADJUST CAREFULLY
ADV1    LDA     ,-Y
        STA     3,Y             ; MAKE SOME ROOM
        DECB
        BNE     ADV1            ; FINISH MOVING CURSOR UP
        LDA     ,X+
        STA     ,Y+
        LDA     ,X+
        STA     ,Y+
        LDA     ,X+
        STA     ,Y+
        STY     VLIMIT
        RTS

**      DSO - DISPLAY SET OF OBJECTS.
*
*       THIS ROUTINE ATTEMPTS TO PROVIDE A MORE STABLE DISPLAY
*       BY REINITIALIZING THE ZERO REFERENCE BETWEEN OBJECTS.
*       AN OBJECT IS ANY ONE THING THAT THE EXECUTIVE'S DRAW
*       ROUTINES WILL HANDLE.
*
*       ENTRY   ((X)) = FWA OF OBJECT LIST
*               (B) = MAGNIFICATION
*
*       EXIT    LIST OF OBJECTS DRAWN.  A DOUBLE TERMINATOR
*               (TWO CONSECUTIVE POSITIVE MODE BYTES) WAS ENCOUNTERED
*
*       ASSUMES THAT THE DRAW ROUTINES IN THE EXECUTIVE EXIT WITH
*               (X) POINTING AT THE TERMINATOR BYTE IT RAN INTO.

DSO     LDA     ,X
        BGT     DSOX            ; IF TERMINATOR
        PSHS    B
        JSR     XAXTO5F         ; ADJUST BEAM INTENSITY
        PULS    B
        LDA     #$CE
        STA     $D00C           ; GET OUT OF ZERO MODE!
        PSHS    B
        JSR     DRAWL1B         ; DRAW IT
        PULS    B
        LDA     ,X+
        BGT     DSO             ; TRY THE NEXT ONE
DSOX    RTS

***     MAIN PROGRAM.

START   LDD     #FRED
        STD     VLIMIT
        STD     VOBJ
        LDA     #1
        STA     ZFLAG
        STA     FRED            ; SET BLANK INITIAL VECTOR LIST
        STA     FRED+1
        LDX     #CURSOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        JSR     ADDVEC          ; CALL ONCE FOR EACH VECTOR
        LDD     #FRED
        STD     VLIMIT
        LDD     #$03075
        STD     $C83D           ; SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        direct  $D0
        STD     $D008           ; START T2
LOOP    JSR     WAIRCAL         ; WAIT FOR END OF CYCLE
        LDB     #$A0
        LDX     #FRED
        JSR     DSO
        JSR     RESET0
        LDU     #MSG
        JSR     PRINTU

*       CHECK JOYSTICK

        LDA     #0
        STA     $C821
        STA     $C822           ; IGNORE 2ND CONSOLE
        LDA     #1
        STA     $C81F
        LDA     #3
        STA     $C820           ; I THINK...
        LDA     #$FF            ; USE SUCCESSIVE APPROXIMATION
        STA     $C823
        LDA     #0
        STA     $C81A           ; SET ACCURACY
        JSR     JOYSTCK
        LDA     $C81B
        LDX     VLIMIT
        STA     2,X             ; STORE X
        LDA     $C81C
        STA     1,X             ; STORE Y

*       CHECK BUTTON PRESSED

        LDA     #$FF            ; SELECT EDGE TRIGGER
        JSR     SWITCH
        LDA     SW1C1
        BNE     UNDO
        LDA     SW1C2
        BNE     LP3             ; IF NEW OBJECT
        LDB     #0
        LDA     SW1C3
        BNE     LP0
        LDB     #$FF
        LDA     SW1C4
        BEQ     LOOP            ; IF NO SWITCH, DO NOTHING
LP0     LDA     $C81B
        STA     VTEMP+2         ; STORE X
        LDA     $C81C
        STA     VTEMP+1         ; STORE Y
        STB     VTEMP
        LDX     #VTEMP
        JSR     ADDVEC
        BRA     LOOP

LP3     LDB     #CURSIZ
        LDY     VLIMIT
        CMPY    VOBJ
        LBEQ    LOOP            ; DON'T DO ANYTHING
        LEAY    B,Y             ; ADJUST CAREFULLY
LP31    LDA     ,-Y
        STA     1,Y             ; MAKE SOME ROOM
        DECB
        BNE     LP31            ; FINISH MOVING CURSOR UP
        LDA     #1
        STA     ,Y+             ; ADD NEW TERMINATOR
        STY     VLIMIT
        STY     VOBJ            ; SET NEW MARKER
        JMP     LOOP

UNDO    LDB     #CURSIZ+2       ; ADD TWO TERMINATORS
        LDY     VLIMIT
        CMPY    VOBJ
        LBEQ    LOOP            ; DON'T BACK UP INTO PREVIOUS OBJECT
UND1    LDA     ,Y+
        STA     -4,Y            ; MOVE IT DOWN, BIASED FOR POSTINCREMENT
        DECB
        BNE     UND1
        LDY     VLIMIT
        LEAY    -3,Y            ; UNDO IT
        STY     VLIMIT
        JMP     LOOP

CURSOR  FCB     $FF,0,0         ; TO PLACE CURSOR
        FCB     0,10,0
        FCB     $FF,$EC,0
        FCB     0,10,$F6
        FCB     $FF,0,20
        FCB     0,0,$F6         ; RETURN TO ORIGIN
        FCB     1,1             ; TERMINATOR

MSG     FCB     $FC,25,$81,$90
        DB      "ERASE",$80
        FCB     $FC,25,$81,$CC
        DB      "NEW OBJECT",$80
        FCB     $FC,25,$81,$20
        DB      "MOVE",$80
        FCB     $FC,25,$81,$48
        DB      "LINE",$80
        FCB     0

ENVLOP  FCB     $FF,$FF,$EE,$EE,$DD,$DD,$CC,$CC
        FCB     $BB,$BB,$AA,$AA,$99,$99,$88,$88

MUSIC   FDB     ENVLOP,$FEB6    ; WE WISH YOU A MERRY CHRISTMAS   0ED8FH

        FCB     9,10            ; WE
        FCB     14,10           ; WISH
        FCB     14,5            ; YOU
        FCB     16,5            ; A
        FCB     14,5            ; MER-
        FCB     13,5            ; RY
        FCB     11,10           ; CHRIST-
        FCB     11,10           ; MAS
        FCB     11,10           ; WE
        FCB     16,10           ; WISH
        FCB     16,5            ; YOU
        FCB     18,5            ; A
        FCB     16,5            ; MER-
        FCB     14,5            ; RY
        FCB     13,10           ; CHRIST-
        FCB     9,10            ; MAS
        FCB     9,10            ; WE
        FCB     18,10           ; WISH
        FCB     18,5            ; YOU
        FCB     19,5            ; A
        FCB     18,5            ; MER-
        FCB     16,5            ; RY
        FCB     14,10           ; CHRIST-
        FCB     11,10           ; MAS
        FCB     9,5             ; AND
        FCB     9,5             ; A
        FCB     11,10           ; HAP-
        FCB     16,10           ; PY
        FCB     13,10           ; NEW
        FCB     14,20           ; YEAR

        FCB     0,$80           ; END OF MUSIC

        END
