;  ASMN8085.ASM - 8085 Debug monitor for use with NoICE85
;  This file may be assembled with the AS8085 assembler.
;
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;       14-Jun-00 ported from Z80
;       21-Jul-00 JLH change FN_MIN from F7 to F0
;       12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	27-May-01 ARB Ported to the ASxxxx 8085 assembler AS8085
;
;============================================================================
;
;  To customize for a given target, you must change code in the
;  hardware equates, the string TSTG, and the routines RESET and REWDT.
;  You may or may not need to change GETCHAR, PUTCHAR, depending on
;  how peculiar your UART is.
;
;  For more information, refer to the NoICE help file monitor.htm
;
;  To add banked or paged memory support:
;  1) Define page latch port PAGELATCH here
;  2) If PAGELATCH is write only, define or import the latch port's RAM
;     image PAGEIMAGE here (The application code must update PAGEIMAGE
;     before outputing to PAGELATCH)
;  3) Search for and modify PAGELATCH, PAGEIMAGE, and REG_PAGE usage below
;  4) In TSTG below edit "LOW AND HIGH LIMIT OF PAGED MEM"
;     to appropriate range (typically 4000H to 07FFFH for two-bit MMU)
;
;  For more information, refer to the NoICE help file 2bitmmu.htm
;
;============================================================================
;
; AS8085 Specifics
;
; Area Definitions
	.area	CODE	(ABS,OVR)
; Default Radix
	.radix	D
;
;============================================================================

;  Hardware definitions
ROM_START = 0x0000          ;START OF MONITOR CODE
RAM_START = 0xFC00          ;START OF MONITOR RAM
USER_CODE = 0x8000          ;START OF USER'S INTS/CODE
;
;  Equates for I/O mapped 8250 or 16450 serial port
S16450  =     0x80    ;base of 16450 UART
RXR     =     0       ;  Receiver buffer register
TXR     =     0       ;  Transmitter buffer register
IER     =     1       ;  Interrupt enable register
LCR     =     3       ;  Line control register
MCR     =     4       ;  Modem control register
LSR     =     5       ;  Line status register
;
;  Define monitor serial port
SERIAL_STATUS =   S16450+LSR
SERIAL_DATA =     S16450+RXR
RXRDY =           0         ; BIT NUMBER (NOT MASK) FOR RX BUFFER FULL
TXRDY =           5         ; BIT NUMBER (NOT MASK) FOR TX BUFFER EMPTY
;
;  op-code equates for IN and OUT
OP_IN   =     0xDB
OP_OUT  =     0xD3
OP_RET  =     0xC9

;============================================================================
;  RAM definitions:  top 1K (or less)
        .ORG    RAM_START               ; Monitor RAM
;
;  Initial user stack
;  (Size and location is user option)
        .DS     64
INITSTACK:
;
;  Monitor stack
;  (Calculated use is at most 6 bytes.  Leave plenty of spare)
        .DS     16
MONSTACK:
;
;  Target registers:  order must match that in TRG8085.C
TASK_REGS:
REG_STATE:     .DS     1
REG_PAGE:      .DS     1
REG_SP:        .DS     2
REG_HL:        .DS     2
REG_BC:        .DS     2
REG_DE:        .DS     2
REG_PSW:
REG_FLAGS:     .DS     1
REG_A:         .DS     1
REG_PC:        .DS     2
REG_IM:        .DS     1
T_REGS_SIZE = .-TASK_REGS
;
;  Communications buffer
;  (Must be at least as long as TASK_REG_SIZE.  Larger values may improve
;  speed of NoICE memory load and dump commands)
COMBUF_SIZE = 67              ;DATA SIZE FOR COMM BUFFER
COMBUF:     .DS  2+COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND CHECK
;
RAM_END         = .               ;ADDRESS OF TOP+1 OF RAM
;
;===========================================================================
;  8080 mode Interrupt vectors
;
;  Reset, RST 0,  or trap vector
        .ORG     0
R0:     DI
        JMP     RESET
        NOP
        NOP
        NOP
        NOP
;
;  Interrupt RST 1.  Used for breakpoint.  Any other RST
;  may be used instead by changing the code below and the value of the
;  breakpoint instruction in the status string TSTG.  If RST NN cannot
;  be used, then CALL may be used instead.  However, this will restrict
;  the placement of breakpoints, since CALL is a three byte instruciton.
        PUSH    PSW
        MVI     A,1                     ;state = 1 (breakpoint)
        JMP     INT_ENTRY
        NOP
        NOP
;
;  Interrupt RST 2
        JMP     USER_CODE + 0x10
        NOP
        NOP
        NOP
        NOP
        NOP
;
;  Interrupt RST 3
        JMP     USER_CODE + 0x18
        NOP
        NOP
        NOP
        NOP
        NOP
;
;  Interrupt RST 4
        JMP     USER_CODE + 0x20
        NOP
;
;  TRAP
;;      JMP     USER_CODE + 0x24         ;use this for your code
        JMP     TRAP_ENTRY              ;use this for trap to monitor
        NOP
;
;  Interrupt RST 5
        JMP     USER_CODE + 0x28
        NOP
;
;  Interrupt RST 5.5
        JMP     USER_CODE + 0x2C
        NOP
;
;  Interrupt RST 6
        JMP     USER_CODE + 0x30
        NOP
;
;  Interrupt RST 6.5
        JMP     USER_CODE + 0x34
        NOP
;
;  Interrupt RST 7
        JMP     USER_CODE + 0x38
        NOP
;
;  Interrupt RST 7.5
        JMP     USER_CODE + 0x3C
        NOP
;
;  TRAPV (undocumented instruction)
        JMP     USER_CODE + 0x40
;
;===========================================================================
;
;  Trap interrupt:  bash button
;  PC is stacked, interrupts disabled
;
;  At the user's option, this may vector thru user RAM at USER_CODE+24H,
;  or enter the monitor directly.  This will depend on whether or not
;  the user wishes to use TRAP in the application, or to use it with
;  a push button to break into running code.
TRAP_ENTRY:
        PUSH    PSW
        MVI     A,2
        JMP     INT_ENTRY

;===========================================================================
;
;  Dummy handlers for RST and TRAP.  This code is moved to the beginning
;  of USER_RAM, where the RST and TRAP interrupts jump to it.  The code
;  then enters the monitor, specifying a STATE value which identifies the
;  interrupt which occurred.  This facilitates identification of
;  unexpected interrupts.  If the user desires, s/he may overwrite the
;  beginning of USER_RAM with appropriate handler code.  Spacing of
;  this code is designed such that the user may re-ORG to 0 to run
;  the code from ROM.
;
DUMMY_INTS:
;
;  RST 0
        PUSH    PSW
        MVI     A,0             ;state = 0(interrupt 0)
        JMP     INT_ENTRY
        NOP
        NOP
;
;  RST 1
        PUSH    PSW
        MVI     A,2             ;state = 2 (interrupt 8)
        JMP     INT_ENTRY
        NOP
        NOP
;
;  RST 2
        PUSH    PSW
        MVI     A,3             ;state = 4 (interrupt 10)
        JMP     INT_ENTRY
        NOP
        NOP
;
;  RST 3
        PUSH    PSW
        MVI     A,4             ;state = 5 (interrupt 18)
        JMP     INT_ENTRY
        NOP
        NOP
;
;  RST 4 (20)
        PUSH    PSW
        MVI     A,5             ;state = 6 (interrupt 20)
        JMP     INT_ENTRY
        NOP
        NOP
;
;=========================
;  The rest of these have only four bytes each available.
;  Jump to the rest of the code.
;
;  RST 5 (28)
        PUSH    PSW
        JMP     R5JMP

;  RST 5.5
        PUSH    PSW
        JMP     R55JMP
;
;  RST 6
        PUSH    PSW
        JMP     R6JMP
;
;  RST 6.5
        PUSH    PSW
        JMP     R65JMP
;
;  RST 7
        PUSH    PSW
        JMP     R7JMP
;
;  RST 7.5
        PUSH    PSW
        JMP     R75JMP
;
;  TRAPV (undocumented instruction)
        PUSH    PSW
        MVI     A,8             ;state = 8 (interrupt 30)
        JMP     INT_ENTRY
;
DUMMY_SIZE      = .-DUMMY_INTS

; Rest of code than can't squeeze into available space
;
;  RST 5 (28)
R5JMP:  MVI     A,6             ;state = 7 (interrupt 28)
        JMP     INT_ENTRY

;  RST 5.5
R55JMP: MVI     A,7             ;state = 8 (interrupt 2C)
        JMP     INT_ENTRY
;
;  RST 6
R6JMP:  MVI     A,8             ;state = 8 (interrupt 30)
        JMP     INT_ENTRY
;
;  RST 6.5
R65JMP: MVI     A,9             ;state = 8 (interrupt 34)
        JMP     INT_ENTRY
;
;  RST 7
R7JMP:  MVI     a,10            ;state = 10 (interrupt 38)
        JMP     INT_ENTRY
;
;  RST 7.5
R75JMP: MVI     A,11            ;state = 11 (interrupt 3C)
        JMP     INT_ENTRY

;===========================================================================
;  Power on reset
RESET:
;
;  Initialize monitor
INIT:   LXI     SP,MONSTACK
;
;===========================================================================
;  Perform user hardware initialization here


;===========================================================================
;
;  Initialize S16450 UART
;
;  access baud generator, no parity, 1 stop bit, 8 data bits
        MVI     A,0x83                   ;B'10000011
        OUT     S16450+LCR
;
;  fixed baud rate of 19200:  crystal is 3.686400 Mhz.
;  Divisor is 3,686400/(16*baud)
        MVI     A,12                    ;fix at 19.2 kbaud
        OUT     S16450+RXR              ;lsb
        XRA     A
        OUT     S16450+RXR+1            ;msb=0
;
;  access data registers, no parity, 1 stop bits, 8 data bits
        MVI     A,0x03                   ;B'00000011
        OUT     S16450+LCR
;
;  no loopback, OUT2 on, OUT1 on, RTS on, DTR (LED) on
        MVI     A,0x0F                   ;B'00001111
        OUT     S16450+MCR
;
;  disable all interrupts: modem, receive error, transmit, and receive
        MVI     A,0x00                   ;B'00000000
        OUT     S16450+IER
;
;===========================================================================
;  Initialize user interrupt vectors to point to monitor
        LXI     H,DUMMY_INTS           ;dummy handler code
        LXI     D,USER_CODE            ;start of user codespace
        LXI     B,DUMMY_SIZE           ;number of bytes
I10:    MOV     A,M
        STAX    D
        INX     H
        INX     D
        DCR     B
        JNZ     I10

;===========================================================================
;
;  Initialize user registers
        LXI     H,INITSTACK
        SHLD    REG_SP                  ;INIT USER'S STACK POINTER
        XRA     A
        MOV     H,A
        MOV     L,A
        SHLD    REG_PC                  ;INIT ALL REGS TO 0
        SHLD    REG_HL
        SHLD    REG_BC
        SHLD    REG_DE
        SHLD    REG_PSW
        STA     REG_STATE               ;set state as "RESET"
;ARB    STA     REG_STATE,A             ;set state as "RESET"
;
;  Initialize memory paging variables and hardware (if any)
        STA     REG_PAGE                ;page 0
;;;     STA     PAGEIMAGE
;;;     OUT     PAGELATCH               ;set hardware page
;
        RIM
        STA     REG_IM                  ;read initial interrupt mask
;ARB    STA     REG_IM,A                ;read initial interrupt mask
;
;  Set function code for "GO".  Then if we reset after being told to
;  GO, we will come back with registers so user can see the crash
        MVI     A,FN_RUN_TARGET
        STA     COMBUF
        JMP     RETURN_REGS             ;DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;         CY=1 if timeout (0.5 seconds)
;
;  Uses 4 bytes of stack including return address
;
GETCHAR:
        PUSH    D
        LXI     D,0x8000                 ;long timeout
gc10:   DCX     D
        MOV     A,D
        ORA     E
        JZ      gc90                    ;exit if timeout
        IN      SERIAL_STATUS           ;read device status
        ANI     RXRDY
        JZ      gc10                    ;not ready yet.
;
;  Data received:  return CY=0. data in A
        XRA     A                       ;cy=0
        IN      SERIAL_DATA             ;read data

        POP     D
        RET
;
;  Timeout:  return CY=1
gc90:   STC                             ;cy=1
        POP     D
        RET
;
;===========================================================================
;  Output character in A
;
;  Uses 4 bytes of stack including return address
;
PUTCHAR:
        PUSH    PSW                     ;save byte to output
pc10:   IN      SERIAL_STATUS           ;read device status
        ANI     TXRDY                   ;rx ready ?
        JZ      pc10

        POP     PSW
        OUT     SERIAL_DATA             ;transmit char
        RET
;
;===========================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:   .DB      14                      ;2: PROCESSOR TYPE = 8085
        .DB      COMBUF_SIZE             ;3: SIZE OF COMMUNICATIONS BUFFER
        .DB      0                       ;4: NO OPTIONS
        .DW      0                       ;5,6: BOTTOM OF PAGED MEM (none)
        .DW      0                       ;7,8: TOP OF PAGED MEM (none)
        .DB      B1-B0                   ;9 BREAKPOINT INSTRUCTION LENGTH
B0:     RST     1                       ;10+ BREKAPOINT INSTRUCTION
B1:     .STR     "NoICE 8085 monitor V3.0" ;DESCRIPTION, ZERO
        .DB      0
TSTG_SIZE =   .-TSTG          ;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT .EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STATUS   = 0x0FF    ;reply with device info
FN_READ_MEM     = 0x0FE    ;reply with data
FN_WRITE_MEM    = 0x0FD    ;reply with status (+/-)
FN_READ_REGS    = 0x0FC    ;reply with registers
FN_WRITE_REGS   = 0x0FB    ;reply with status
FN_RUN_TARGET   = 0x0FA    ;reply (delayed) with registers
FN_SET_BYTES    = 0x0F9    ;reply with data (truncate if error)
FN_IN           = 0x0F8    ;input from port
FN_OUT          = 0x0F7    ;output to port
;
FN_MIN          = 0x0F0    ;MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR        = 0x0F0    ;error reply to unknown op-code
;
;===========================================================================
;  Enter here via RST nn for breakpoint:  PSW, PC are stacked.
;  Enter with A=interrupt code = processor state
;  Interrupt status is not changed from user program
INT_ENTRY:
;
;  Interrupts may be on: get IM as quickly as possible, so we can DI
        STA     REG_STATE       ;save entry state
        RIM
        DI                      ;NO INTERRUPTS ALLOWED
        STA     REG_IM          ;SAVE INT REG
;
;  Save registers in reg block for return to master
        SHLD    REG_HL          ;SAVE HL
        POP     H               ;GET FLAGS IN L, ACCUM IN H
        SHLD    REG_PSW         ;SAVE A AND FLAGS
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.  Else leave PC alone.
;  (If CALL is used for breakpoint, then back up by 3 bytes)
        POP     HL              ;GET PC OF BREAKPOINT/INTERRUPT
        LDA     REG_STATE
        DCR     A
        JNZ     NOTBP           ;JIF NOT A BREAKPOINT
        DCX     H               ;BACK UP PC TO POINT AT BREAKPOINT
NOTBP:  JMP     ENTER_MON       ;HL POINTS AT BREAKPOINT OPCODE
;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:   LXI     SP,MONSTACK     ;CLEAN STACK IS HAPPY STACK
        LXI     H,COMBUF        ;BUILD MESSAGE HERE
;
;  First byte is a function code
        CALL    GETCHAR         ;GET A FUNCTION (uses 6 bytes of stack)
        JC      MAIN            ;JIF TIMEOUT: RESYNC
        CPI     FN_MIN
        JC      MAIN            ;JIF BELOW MIN: ILLEGAL FUNCTION
        MOV     M,A             ;SAVE FUNCTION CODE
        INX     H
;
;  Second byte is data byte count (may be zero)
        CALL    GETCHAR         ;GET A LENGTH BYTE
        JC      MAIN            ;JIF TIMEOUT: RESYNC
        CPI     COMBUF_SIZE+1
        JNC     MAIN            ;JIF TOO LONG: ILLEGAL LENGTH
        MOV     M,A             ;SAVE LENGTH
        INX     H
        ORA     A
        JZ      MA80            ;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
        MOV     B,A             ;SAVE LENGTH FOR LOOP
MA10:   CALL    GETCHAR         ;GET A DATA BYTE
        JC      MAIN            ;JIF TIMEOUT: RESYNC
        MOV     M,A             ;SAVE DATA BYTE
        INX     H
        DCR     B
        JNZ     MA10
;
;  Get the checksum
MA80:   CALL    GETCHAR         ;GET THE CHECKSUM
        JC      MAIN            ;JIF TIMEOUT: RESYNC
        MOV     C,A             ;SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
        CALL    CHECKSUM
        ADD     C
;ARB    ADD     A,C
        JNZ     MAIN            ;JIF BAD CHECKSUM
;
;  Process the message.
        LDA     COMBUF+0        ;GET THE FUNCTION CODE
        CPI     FN_GET_STATUS
        JZ      TARGET_STATUS
        CPI     FN_READ_MEM
        JZ      READ_MEM
        CPI     FN_WRITE_MEM
        JZ      WRITE_MEM
        CPI     FN_READ_REGS
        JZ      READ_REGS
        CPI     FN_WRITE_REGS
        JZ      WRITE_REGS
        CPI     FN_RUN_TARGET
        JZ      RUN_TARGET
        CPI     FN_SET_BYTES
        JZ      SET_BYTES
        CPI     FN_IN
        JZ      IN_PORT
        CPI     FN_OUT
        JZ      OUT_PORT
;
;  Error: unknown function.  Complain
        MVI     A,FN_ERROR
        STA     COMBUF+0        ;SET FUNCTION AS "ERROR"
        MVI     A,1
        JMP     SEND_STATUS     ;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
TARGET_STATUS:
;
        LXI     H,TSTG          ;DATA FOR REPLY
        LXI     D,COMBUF+1      ;RETURN BUFFER
        MVI     B,TSTG_SIZE     ;LENGTH OF REPLY
        MOV     A,B
        STAX    D               ;SET SIZE IN REPLY BUFFER
        INX     D
TS10:   MOV     A,M             ;MOVE REPLY DATA TO BUFFER
        STAX    D
        INX     H
        INX     D
        DCR     B
        JNZ     TS10
;
;  Compute checksum on buffer, and send to master, then return
        JMP     SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
READ_MEM:
;
;  Set page
;;      LDA     COMBUF+2
;;      STA     PAGEIMAGE
;;      OUT     PAGELATCH
;
;  Get address
        LHLD    COMBUF+3
        LDA     COMBUF+5                ;NUMBER OF BYTES TO GET
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LXI     D,COMBUF+1              ;POINTER TO LEN, DATA
        STAX    D                       ;RETURN LENGTH = R.EQUESTED DATA
        INX     D
        ORA     A
        JZ      GLP90                   ;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
        MOV     B,A
GLP:    MOV     A,M             ;GET BYTE TO A
        STAX    D               ;STORE TO RETURN BUFFER
        INX     H
        INX     D
        DCR     B
        JNZ     GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:  JMP     SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Uses 2 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;      LDA     COMBUF+2
;;      STA     PAGEIMAGE
;;      OUT     PAGELATCH
;
;  Get address
        LXI     D,COMBUF+5      ;POINTER TO SOURCE DATA IN MESSAGE
        LHLD    COMBUF+3        ;POINTER TO DESTINATION
                XCHG
;
        LDA     COMBUF+1        ;NUMBER OF BYTES IN MESSAGE
        SBI     3               ;LESS PAGE, ADDRLO, ADDRHI
        JZ      WLP50           ;EXIT IF NONE REQUESTED
;
;  Write the specified bytes to local memory
        MOV     B,A
        PUSH    B               ;SAVE BYTE COUNTER
WLP10:  MOV     A,M             ;BYTE FROM HOST
        STAX    D               ;WRITE TO TARGET RAM
        INX     H
        INX     D
        DCR     B
        JNZ     WLP10
;
;  Compare to see if the write worked
        LXI     D,COMBUF+5      ;POINTER TO SOURCE DATA IN MESSAGE
        LHLD    COMBUF+3        ;POINTER TO DESTINATION
        XCHG
        POP     BC              ;SIZE AGAIN
;
;  Compare the specified bytes to local memory
WLP20:  LDAX    D               ;READ BACK WHAT WE WROTE
        CMP     M               ;COMPARE TO HOST DATA
        JNZ     WLP80           ;JIF WRITE FAILED
        INX     H
        INX     D
        DCR     B
        JNZ     WLP20
;
;  Write succeeded:  return status = 0
WLP50:  XRA     A               ;RETURN STATUS = 0
        JMP     WLP90
;
;  Write failed:  return status = 1
WLP80:  MVI      A,1
;
;  Return OK status
WLP90:  JMP     SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
        LXI     H,TASK_REGS     ;REGISTER LIVE HERE
        MVI     A,T_REGS_SIZE   ;NUMBER OF BYTES
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LXI     D,COMBUF+1      ;POINTER TO LEN, DATA
        STAX    D               ;SAVE DATA LENGTH
        INX     D
;
;  Copy the registers
        MOV     B,A
GRLP:   MOV     A,M             ;GET BYTE TO A
        STAX    D               ;STORE TO RETURN BUFFER
        INX     H
        INX     D
        DCR     B
        JNZ     GRLP
;
;  Compute checksum on buffer, and send to master, then return
        JMP     SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
WRITE_REGS:
;
        LXI     H,COMBUF+2      ;POINTER TO DATA
        LDA     COMBUF+1        ;NUMBER OF BYTES
        ORA     A
        JZ      WRR80           ;JIF NO REGISTERS
;
;  Copy the registers
        LXI     D,TASK_REGS     ;OUR REGISTERS LIVE HERE
        MOV     B,A
WRRLP:  MOV     A,M             ;GET BYTE TO A
        STAX    D               ;STORE TO REGISTER RAM
        INX     H
        INX     D
        DCR     B
        JNZ     WRRLP
;
;  Return OK status
WRR80:  XRA     A
        JMP     SEND_STATUS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Uses 4 bytes of stack
;
RUN_TARGET:
;
;  Restore user's page
;;      LDA     REG_PAGE
;;      STA     PAGEIMAGE
;;      OUT     PAGELATCH
;
;  Switch to user stack
        LHLD    REG_SP                  ;BACK TO USER STACK
        LXI     SP,0
        SPHL

        LHLD    REG_PC          ;USER PC
        PUSH    H               ;SAVE USER PC FOR RET
        LHLD    REG_PSW
        PUSH    HL              ;SAVE USER A AND FLAGS FOR POP
;
;  Restore registers
        LHLD    REG_BC
        MOV     B,H
        MOV     C,L
        LHLD    REG_DE
        MOV     D,H
        MOV     E,L
        LHLD    REG_HL
;ARB    LHLD    H,REG_HL
;
;  Restore user's interrupt state
;  Don't affect SOD, don't reset int 7.5
        LDA     REG_IM
        ANI     0x07             ;KEEP JUST THE MASK BITS
        ORI     0x08             ;MASK SET ENABLE
        SIM                     ;SET/CLEAR 7.5, 6.5, AND 5.5
;
        LDA     REG_IM
        ORI     0x08
        JZ      RUTT10          ;JIF USER INTERRUPTS OFF
;
;  Return to user with interrupts enabled
        POP     AF
        EI                      ;ELSE ENABLE THEM NOW
        RET
;
;  Return to user with interrupts disabled
RUTT10: POP     AF
        RET

;===========================================================================
;
;  Common continue point for all monitor entrances
;  HL = user PC, SP = user stack
;  REG_STATE has current state, REG_HL, REG_IM, REG_PSW set
;
;  Uses 2 bytes of stack
;
ENTER_MON:
        SHLD    REG_PC
        LXI     H,0
        DAD     SP
        SHLD    REG_SP          ;SAVE USER'S STACK POINTER
        LXI     SP,MONSTACK     ;AND USE OURS INSTEAD
;
        MOV     H,B
        MOV     L,C
        SHLD    REG_BC
        MOV     H,D
        MOV     L,E
        SHLD    REG_DE
;
;;      LDA     PAGEIMAGE       ;GET CURRENT USER PAGE
        XRA     A               ;...OR NONE IF UNPAGED TARGET
        STA     REG_PAGE        ;SAVE USER PAGE
;
;  Return registers to master
        JMP     RETURN_REGS

;===========================================================================
;
;  Set target byte(s):  FN, len { (page, alow, ahigh, data), (...)... }
;
;  Return has FN, len, (data from memory locations)
;
;  If error in insert (memory not writable), abort to return short data
;
;  This function is used primarily to set and clear breakpoints
;
;  Uses 2 bytes of stack
;
SET_BYTES:
;
        LXI     H,COMBUF+1
        MOV     B,M             ;LENGTH = 4*NBYTES
        INX     H
        INR     B
        DCR     B
        MVI     C,0             ;C GETS COUNT OF INSERTED BYTES
        JZ      SB90            ;JIF NO BYTES (C=0)
        PUSH    H               ;RETURN BUFFER
;
;  Loop on inserting bytes
SB10:   MOV     A,M             ;MEMORY PAGE
        INX     H
;;      STA     PAGEIMAGE
;;      OUT     PAGELATCH       ;SET PAGE
        MOV     E,M             ;ADDRESS TO DE
        INX     H
        MOV     D,M
        INX     H
;
;  Read current data at byte location
        LDAX    D               ;READ CURRENT DATA
        XTHL
        MOV     M,A             ;SAVE IN RETURN BUFFER
        INX     H
        XTHL
;
;  Insert new data at byte location
        MOV     A,M
        STAX    D               ;SET BYTE
        LDAX    D               ;READ IT BACK
        CMP     M               ;COMPARE TO DESIRED VALUE
        JNZ     SB90            ;BR IF INSERT FAILED: ABORT
        INX     H
        INR     C               ;ELSE COUNT ONE BYTE TO RETURN
;
        DCR     B
        DCR     B
        DCR     B
        DCR     B
        JNZ     SB10            ;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:   MOV     A,C
        STA     COMBUF+1        ;SET COUNT OF RETURN BYTES
        POP     H               ;CLEAN STACK
;
;  Compute checksum on buffer, and send to master, then return
        JMP     SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
IN_PORT:
;
;  Port address is at COMBUF+2 (and unused high address+3)
;  Build "IN PORT" and "RET" around it.
        MVI     A,OP_IN
        STA     COMBUF+1
        MVI     A,OP_RET
        STA     COMBUF+3
;
;  Read port value
        CALL    COMBUF+1
;
;  Return byte read as "status"
        JMP     SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
OUT_PORT:
;
;  Port address is at COMBUF+2, (unused high address+3)
;  Data to write is at COMBUF+4
;  Build "OUT PORT" and "RET" in combuffer
        MVI     A,OP_OUT
        STA     COMBUF+1
        MVI     A,OP_RET
        STA     COMBUF+3
;
;  Get data
        LDA     COMBUF+4
;
;  Write value to port
        CALL    COMBUF+1
;
;  Return status of OK
        XRA     A
        JMP     SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
        STA     COMBUF+2        ;SET STATUS
        MVI     A,1
        STA     COMBUF+1        ;SET LENGTH
;;;     JMP     SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:   CALL    CHECKSUM        ;GET A=CHECKSUM, HL->checksum location
        CMA
        INR     A
        MOV     M,A             ;STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
        LXI     H,COMBUF        ;POINTER TO DATA
        LDA     COMBUF+1        ;LENGTH OF DATA
        ADI     3               ;PLUS FUNCTION, LENGTH, CHECKSUM
        MOV     B,A             ;save count for loop
SND10:  MOV     A,M
        CALL    PUTCHAR         ;SEND A BYTE (uses 6 bytes of stack)
        INX     H
        DCR     B
        JNZ     SND10
        JMP     MAIN            ;BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.  COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;       A = checksum
;       HL = pointer to next byte in buffer (checksum location)
;       B is scratched
;
;  Uses 2 bytes of stack including return address
;
CHECKSUM:
        LXI     H,COMBUF        ;pointer to buffer
        LDA     COMBUF+1        ;length of message
        ADI     2               ;plus function, length
        MOV     B,A             ;save count for loop
        XRA     A               ;init checksum to 0
CHK10:  ADD     M
;ARB	ADD     A,M
        INX     H
        DCR     B
        JNZ     CHK10           ;loop for all
        RET                     ;return with checksum in A

        .END    RESET
