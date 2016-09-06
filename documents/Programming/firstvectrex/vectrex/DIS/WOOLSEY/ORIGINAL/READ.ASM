        TITLE   VECTREX LIVE CARTRIDGE READER

*       Bloody stupid assembler bugs.  Description follows code.

**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.

PRINTU  EQU     $F385
RESET0  EQU     $F354
SWITCH  EQU     $F1B4
WAIRCAL EQU     $F192

SCORE   EQU     0CBF0H          BOOT DISPLAYED SCORE ADDRESS
FRED    EQU     0C880H          GOOD PLACE FOR VECTOR LIST
EXEC    EQU     $F000           MOINTOR LOCATION

SW1C1   EQU     0C812H          SWITCH 1, CONSOLE 1
SW1C2   EQU     SW1C1+1
SW1C3   EQU     SW1C2+1
SW1C4   EQU     SW1C3+1

        ORG     0

        FCB     'g GCE 1986',80H
        FDB     $FD0D           VECTREX MUSIC
        FCB     0F8H,050H,000H,0B0H
        FCC     'CARTRIDGE READER',80H
        FCB     0

***     MAIN PROGRAM.

        SETDP   $FF

START   LDA     #$FF            SELECT EDGE TRIGGER
        JSR     SWITCH
        LDA     SW1C4
        BEQ     START           IF NO SWITCH
        LDB     #BOOTSZ
        LDX     #BOOT
        LDY     #FRED
THROW   LDA     ,X+
        STA     ,Y+
        DECB
        BNE     THROW           MOVE BOOTSTRAP LOADER
        JMP     FRED            JUMP TO IT

BOOT    LDY     #0              SET STARTING ADDRESS
        LDA     #$FF
SWEEP   STA     ,Y+
        CMPY    #$2000
        BNE     SWEEP           WRITE SOME MORE
        JSR     WAIRCAL         WAIT FOR END OF CYCLE
        JSR     RESET0
        BSR     KLUDGE
        BRA     BOOT

MSG     FCB     $F8,50,0,$F0
        FCB     'READING!',80H
        FCB     0

KLUDGE  LEAU    MSG,PCR
        JSR     PRINTU          USES U, X
        RTS

BOOTSZ  EQU     *-BOOT

*       This program, in cooperation with the interface loader, tries
*       to force a cartridge to get copied into the interface memory.
*       The cartridge is mounted in the socket on the interface cable.
*       It must not be mounted until this program is running, otherwise
*       this program cannot get off the ground.

*       This program operates by moving itself up into the internal RAM,
*       and then writing all over the interface with $FF, hoping that
*       open collector CPU data pins will be overridden by the data pins
*       of the cartridge.   There is a significant chance this scheme will
*       not work, as I have done no research into the details.

        END
