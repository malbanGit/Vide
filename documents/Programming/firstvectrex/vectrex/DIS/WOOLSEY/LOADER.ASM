        TITLE   VECTREX LIVE BOOTSTRAP LOADER

*       Bloody stupid assembler bugs.  Description follows code.

**      Copyright 1985 by Jeff Woolsey.
*       All rights reserved.
*
*       Permission granted for any not-for-profit use.

PRINTU  EQU     $F385
RESET0  EQU     $F354
WAIRCAL EQU     $F192

NMI     EQU     0CBFBH          NMI VECTOR LOCATION
SCORE   EQU     0CBF0H          BOOT DISPLAYED SCORE ADDRESS
FRED    EQU     0C880H          GOOD PLACE FOR VECTOR LIST
EXEC    EQU     $F000           MOINTOR LOCATION

        ORG     0

        FCB     'g'
        BRA     START           $20,$47
        FCC     'CE 1789',80H
        FDB     $FD0D           VECTREX MUSIC
        FCB     0F8H,050H,000H,000H
        FCC     'i ',80H
        FCB     0

***     MAIN PROGRAM.

        SETDP   $FF

        BRA     SHOW

NEXT    EQU     *

        ORG     $48

        SETDP   $00

SHOW    NEG     $67             ADDRESSES ARE CRITICAL HERE
START   NEG     $67             WE DON'T CARE HOW WE GOT HERE

        SETDP   $FF

        LDB     #BOOTSZ
        LDX     #NEXT
        LDY     #FRED
THROW   LDA     ,X+
        STA     ,Y+
        DECB
        BNE     THROW           MOVE BOOTSTRAP LOADER
        LDD     #03075H
        STD     0C83DH          SET T2 TIMER FOR 20 MSEC
        STD     $D008           START TIMER
        LDY     #0              CLEAR Y FOR USE IN LOADER
        LDA     #$76            PRESET A FOR LOADER
        JMP     FRED            JUMP TO IT

        SUBA    #$80            FILL OUT THE SHORT SECTOR
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80
        SUBA    #$80

        ORG     NEXT

BOOT    STA     ,Y              SET LOADER ACKNOWLEDGE...
        CMPA    ,Y
        BNE     BOOT            ...UNTIL INTERFACE WRITABLE
LOOP    JSR     WAIRCAL         WAIT FOR END OF CYCLE
        JSR     RESET0
        BSR     KLUDGE
        LDA     #$67
        CMPA    ,Y
        BNE     LOOP            IF INTERFACE LOADED
        JMP     EXEC

MSG     FCB     $F8,50,0,$F8
        FCB     'j ',80H
        FCB     0

KLUDGE  LEAU    MSG,PCR
        JSR     PRINTU          USES U, X
        RTS

BOOTSZ  EQU     *-NEXT

*       This program, in cooperation with the interface loader, tries
*       real hard to keep control of the Vectrex while loading the
*       interface.  This is a fairly intricate operation, detailed below.

*       This program consists of the cartridge header, the boostrap
*       loader, and the bootstrap loader loader.  It is the responsibility
*       of the interface loader to get the Vectrex to execute the loader
*       loader.  This is accomplished by the interface loader in these
*       steps.

*       a) HALT the Vectrex in its tracks.  It will stop at the end of
*       the current instruction, which could entail as many as six
*       additional memory references.  This delay must be accounted for.
*       b) Change interface memory access to host.
*       c) Fill the interface memory with a pattern designed to reduce
*       the number of possible states the Vectrex may be in.  This pattern
*       consists of $80 from $0000 to $1FFD, $12 at $1FFE, and $7E at $1FFF.
*       This is SUBA #$80, NOP, JMP.  (An optional step involves setting
*       $1FFD to $12, $1FFE to $20, and $1FFF to $FE. This is NOP, BRA *.
*       It is of dubious value.)  This loader program is then loaded at the
*       start of the interface memory. What happens from here is detailed
*       later.

*       The Vectrex may be in any of several states, each of which
*       represents a different path to the loader loader.

*       1) The most well-defined condition is that of executing MINE STORM,
*       the internal game.  Undisturbed, MINE STORM jumps to the Vectrex
*       restart address every few minutes.  Here, the monitor checks for
*       a valid cartridge and executes it if it feels like it.

*       2) The Vectrex may be executing a program from the cartridge. Since
*       the cartridge must have a valid header, we can assume that the header
*       is not being executed.  We then make our header as small as possible.
*       For certain applications, however, they may wish to rewrite the header
*       area and use it as code space, hence the optional attempt by the
*       interface loader to get the program counter out of the way.

*       3) The Vectrex may be executing in the monitor somewhere, probably
*       servicing a request from the cartridge program.  It may RTS shortly.
*       There is, however, a significant possibility that this service is
*       processing a list, be it text, vectors, or music, and that if
*       the interface is rewritten, the list terminator will vanish.  Hence
*       we fill the void with $80.

*       4) The Vectrex could be completely lost and out of control.  The only
*       requirement for this condition is that control never returns to either
*       the executive or the cartridge program.  There is little we can do
*       at this point, since there is no RESET line (necessitating this
*       mechanism), and the monitor does not have any use for NMI or IRQ, thus
*       not setting them up.

*       The most contrived case, then, is case 3.  When the interface has been
*       preset by the interface loader, it releases control of the memory, and
*       releases the HALT on the Vectrex, possibly simultaneously.  The monitor
*       routine reads up $80s as data until its state expects a terminator,
*       which it then gets, and does a RTS, returning control to the interface.
*       We have now degenerated into case 2 above.  The Vectrex executes
*       SUBA #$80 instructions until it nears the end of the interface.  Here
*       it encounters the $12, which it may interpret as the immediate argument
*       of the last SUBA, or it can be a NOP.  The last byte it hits is the
*       JMP.  The destination address is read from the next two bytes of
*       unimplemented memory, which returns $FFFF.  Control is then transferred
*       to the last byte of the ROM, which has the RESET address, the low-order
*       byte of which is $00.  $00 is a two-byte NEGA instruction, using direct
*       addressing.  The second byte of this instruction is obtained when the
*       program counter wraps around to $0000, where, given a valid cartridge,
*       a $67 is stored.  This negates byte $67 in whatever page of memory the
*       DP register happens to point at.  Continuing through a valid cartridge
*       header, the next instruction is a branch forward some $47 (+2) bytes.
*       Here we place another NEG $67 instruction to undo the effects of the
*       previous instruction.

*       The route from MINE STORM is essentially the same as the route from
*       RESET, just slower and less traumatic.  The monitor examines the
*       cartridge for validity, processes the header, and jumps to the
*       instruction immediately following it.  Here we place a BRA to a NEG $67
*       which immediately precedes the one that case 2 eventually arrives at.
*       This falls through to the final NEG $67, and the bootstrap loader
*       loader follows.  In any case we have executed two identical negations,
*       which should be a slow NOP.

*       The bootstrap loader loader simply copies the position-independent
*       bootstrap loader into a suitable location in internal RAM, sets up
*       a few registers and flags, and jumps to the relocated bootstrap loader.
*       The bootstrap loader is small enough to fit in the space jumped over by
*       the intial BRA instructions in either case.

*       The bootstrap loader writes a $76 into location $0000, and continues
*       to do so until the interface is writeable.  It then puts up its message
*       and monitors $0000 for a valid cartridge header ($67). When it gets
*       this, it jumps off to the executive, which proceeds as usual to execute
*       the cartridge.

*       The interface loader, having put the pattern and this loader into the
*       interface, waits for an acknowledge ($76) from the bootstrap loader.
*       If this times out, it reloads the interface and waits again.  When
*       the acknowledge comes, the interface loader takes over the memory,
*       this time without HALTing the Vectrex, and writes the desired program
*       into the interface memory.  During this time, the bootstrap loader is
*       reading $FF from $0000.  The interface loader then releases the memory,
*       and we're off and running.  Simple, no?

        END
