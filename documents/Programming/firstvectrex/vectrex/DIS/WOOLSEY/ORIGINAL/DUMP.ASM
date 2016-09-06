        TITLE   VECTREX LIVE DUMPER

*       Initially this program will simply copy high memory into
*       the interface.

*       This assembler is so stupid that it cannot fit numbers
*       between -127 and -1 into 8 bits. ARGH!
*
*       Not only that, but it cannot find source files whose names
*       are eight characters long
*
*       Not to mention the infuriating and difficult-to-describe
*       bug in label accuracy.

DPTOD0  EQU     $F1AA
PRINTU  EQU     $F385
RESET0  EQU     $F354
WAIRCAL EQU     $F192

SCORE   EQU     0CBF0H          BOOT DISPLAYED SCORE ADDRESS
FRED    EQU     00800H          GOOD PLACE FOR VECTOR LIST
BOOT    EQU     0C800H
BOOTSZ  EQU     8192
EXEC    EQU     $F000           MOINTOR LOCATION

        ORG     0

        SETDP   $FF

        FCC     'g GCE 1986',80H
        FDB     $FD0D           VECTREX MUSIC
        FCB     0F8H,050H,000H,000H
        FCC     'DUMP',80H
        FCB     0

        BRA     START

***     MAIN PROGRAM.

START   LDX     #BOOT
        LDY     #FRED
MOVE    LDA     ,X+
        STA     ,Y+
        CMPX    #BOOT+BOOTSZ
        BNE     MOVE            MOVE BOOTSTRAP LOADER

        LDD     #03075H
        STD     0C83DH          SET T2 TIMER FOR 20 MSEC
        JSR     DPTOD0
        SETDP   $D0
        STD     $D008           START T2
LOOP    JSR     WAIRCAL         WAIT FOR END OF CYCLE
        JSR     RESET0
        LDU     #MSG
        JSR     PRINTU
        BRA     LOOP

MSG     FCB     $F8,$50,$C0,0
        FCB     'DUMP FINISHED',80H
        FCB     0

        END
