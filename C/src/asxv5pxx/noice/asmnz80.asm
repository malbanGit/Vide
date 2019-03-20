;  ASMNZ80.ASM - Z80 Debug monitor for use with NoICEZ80
;  This file may be assembled with the ASxxxx Z80 assembler ASZ80.
;
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;       17-Oct-95 JLH port MONZ80.S to PseudoSam assembler, straight Z80 target
;       21-Jul-00 JLH change FN_MIN from F7 to F0
;       12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	28-May-01 ARB Modified for the ASxxxx ASZ80 assembler
;
;============================================================================
;
;  The original monitor used the Zilog ASM800 assembler, and used
;  conditional assembly to support various target processors.
;  PseudoSam also has no conditional assembly, so this version has been
;  stripped to just the basic Z80 code.
;
;  If you are using PseudoSam with a Z180 or Z84C15 processor, you should
;  look at the Z180 and Z84C15 specific code (initialization etc.) in
;  MONZ80.S, and port that which you require to this file.
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
;==========================================================================
;
; ASxxxx V4.0 ASZ80 Specifics
;
; Define the banks with the mapping (paging) parameters
	.bank	CSEG
	.bank	DSEG
; Area Definitions
	.area	CODE	(ABS,OVR,BANK=CSEG)
	.area	DATA	(ABS,OVR,BANK=DSEG)
; Default Radix
	.radix	D
;
;============================================================================
;
;  Hardware definitions
        .equ    ROM_START, 0x0000          ;START OF MONITOR CODE
        .equ    RAM_START, 0xFC00          ;START OF MONITOR RAM
        .equ    USER_CODE, 0x8000          ;START OF USER'S INTS/CODE
;
;  Equates for I/O mapped 8250 or 16450 serial port
        .equ    S16450,  0x80              ;base of 16450 UART
        .equ    RXR,     0                 ;  Receiver buffer register
        .equ    TXR,     0                 ;  Transmitter buffer register
        .equ    IER,     1                 ;  Interrupt enable register
        .equ    LCR,     3                 ;  Line control register
        .equ    MCR,     4                 ;  Modem control register
        .equ    LSR,     5                 ;  Line status register
;
;  Define monitor serial port
        .equ    SERIAL_STATUS,   S16450+LSR
        .equ    SERIAL_DATA,     S16450+RXR
        .equ    RXRDY,           0         ; BIT NUMBER (NOT MASK) FOR RX BUFFER FULL
        .equ    TXRDY,           5         ; BIT NUMBER (NOT MASK) FOR TX BUFFER EMPTY
;
;============================================================================
;  RAM definitions:  top 1K (or less)
	.AREA	DATA
        .ORG    RAM_START               ; Monitor RAM
;
;  Initial user stack
;  (Size and location is user option)
        .RS     64
INITSTACK:
;
;  Monitor stack
;  (Calculated use is at most 6 bytes.  Leave plenty of spare)
        .RS     16
MONSTACK:
;
;  Target registers:  order must match that in TRGZ80.C
TASK_REGS:
 REG_STATE:     .RS     1
 REG_PAGE:      .RS     1
 REG_SP:        .RS     2
 REG_IX:        .RS     2
 REG_IY:        .RS     2
 REG_HL:        .RS     2
 REG_BC:        .RS     2
 REG_DE:        .RS     2
 REG_AF:                        ;LABEL ON FLAGS, A AS A WORD
 REG_FLAGS:     .RS     1
 REG_A:         .RS     1
 REG_PC:        .RS     2
 REG_I:         .RS     1
 REG_IFF:       .RS     1
 ;
 REG_HLX:       .RS     2       ;ALTERNATE REGISTER SET
 REG_BCX:       .RS     2
 REG_DEX:       .RS     2
 REG_AFX:                       ;LABEL ON FLAGS, A AS A WORD
 REG_FLGX:      .RS     1
 REG_AX:        .RS     1
        .equ    T_REGS_SIZE, .-TASK_REGS
; !!! Caution:  don't put parenthesis around the above in ASM180:
; !!! The parenthesis in (.-TASK_REGS) are "remembered", such that
; !!! LD BC,T_REGS_SIZE is the same as LD BC,(T_REGS_SIZE)
; !!! It is OK to use parenthesis around the difference if the difference
; !!! is to be divided - just not around the entire expression!!!!!
;
;  Communications buffer
;  (Must be at least as long as TASK_REG_SIZE.  Larger values may improve
;  speed of NoICE memory load and dump commands)
        .equ    COMBUF_SIZE, 67              ;DATA SIZE FOR COMM BUFFER
COMBUF:         .RS      2+COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND CHECK
;
        .equ    RAM_END, .               ;ADDRESS OF TOP+1 OF RAM
;
;===========================================================================
;  8080 mode Interrupt vectors
;
;  Reset, RST 0,  or trap vector
	.AREA	CODE
        .ORG    0
R0:     di
        jp      RESET
        nop
        nop
        nop
        nop
;
;  Interrupt RST 08.  Used for breakpoint.  Any other RST
;  may be used instead by changing the code below and the value of the
;  breakpoint instruction in the status string TSTG.  If RST NN cannot
;  be used, then CALL may be used instead.  However, this will restrict
;  the placement of breakpoints, since CALL is a three byte instruciton.
        push    af
        ld      a,1                     ;state = 1 (breakpoint)
        jp      INT_ENTRY
        nop
        nop
;
;  Interrupt RST 10
        jp      USER_CODE + 0x10
        nop
        nop
        nop
        nop
        nop
;
;  Interrupt RST 18
        jp      USER_CODE + 0x18
        nop
        nop
        nop
        nop
        nop
;
;  Interrupt RST 20
        jp      USER_CODE + 0x20
        nop
        nop
        nop
        nop
        nop
;
;  Interrupt RST 28
        jp      USER_CODE + 0x28
        nop
        nop
        nop
        nop
        nop
;
;  Interrupt RST 30
        jp      USER_CODE + 0x30
        nop
        nop
        nop
        nop
        nop
;
;  Interrupt RST 38
        jp      USER_CODE + 0x38
        nop
        nop
        nop
        nop
        nop
;
;===========================================================================
;
;  Non-maskable interrupt:  bash button
;  PC is stacked, interrupts disabled, and IFF2 has pre-NMI interrupt state
;
;  At the user's option, this may vector thru user RAM at USER_CODE+66H,
;  or enter the monitor directly.  This will depend on whether or not
;  the user wishes to use NMI in the application, or to use it with
;  a push button to break into running code.
        .ORG    0x66
NMI_ENTRY:
        push    af
        ld      a,2
        jp      INT_ENTRY
;
;  Or, if user wants control of NMI:
;;;     jp      USER_CODE + 0x66                ;jump thru vector in RAM
;;  (and enable NMI handler in DUMMY_INTS below)
;
;===========================================================================
;
;  Dummy handlers for RST and NMI.  This code is moved to the beginning
;  of USER_RAM, where the RST and NMI interrupts jump to it.  The code
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
        push    af
        ld      a,0                    ;state = 3 (interrupt 0)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 8
        push    af
        ld      a,3                    ;state = 3 (interrupt 8)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 10h
        push    af
        ld      a,4                    ;state = 4 (interrupt 10)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 18h
        push    af
        ld      a,5                    ;state = 5 (interrupt 18)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 20h
        push    af
        ld      a,6                    ;state = 6 (interrupt 20)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 28h
        push    af
        ld      a,7                    ;state = 7 (interrupt 28)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 30h
        push    af
        ld      a,8                    ;state = 8 (interrupt 30)
        jp      INT_ENTRY
        nop
        nop
;
;  RST 38h
        push    af
        ld      a,1                    ;state = 1 (breakpoint)
        ld      a,9                    ;state = 9 (interrupt 38)
        jp      INT_ENTRY
;
;  Use this if NMI is to be vectored through RAM.  Else comment it out
;;;     .ORG    DUMMY_INTS+0x66
;;;     push    af
;;;     ld      a,2
;;;     jp      INT_ENTRY
;
        .equ    DUMMY_SIZE, .-DUMMY_INTS

;===========================================================================
;  Power on reset or trap
RESET:
;
;----------------------------------------------------------------------------
;;  if Z180, enable this code to tell illegal op-code from a reset
;;
;;;  See if this is an illegal op-code trap or a reset
;;        push    af              ;save a and flags (hope for a stack...)
;;        in0     a,(itc)         ;check trap status (flags destroyed!!)
;;        bit     7,a             ;if this bit is one, there was trap!
;;        jr      z,INIT          ;jif reset
;;;
;;;  Illegal instruction trap:
;;;  Back up the stacked PC by either 1 or 2 bytes, depending on the state
;;;  of the UFO bit in the itc
;;        ld      (REG_HL),hl
;;        pop     hl              ;get stacked af
;;        ld      (REG_AF),hl     ;save af
;;        pop     hl              ;get stacked pc
;;        dec     hl              ;back up one byte
;;        bit     6,a
;;        jr      z,TR20          ;jif 1 byte op-code
;;        dec     hl              ;else back up second op-code byte
;;;
;;;  Reset the trap bit
;;TR20:   AND     0x7F            ;CLEAR THE TRAP BIT
;;        out0    (itc),a
;;;
;;;  Get IFF2
;;;  It is not clear that we can determine the pre-trap state of the
;;;  interrupt enable:  the databook says nothing about IFF2 vis a vis
;;;  trap.  We presume that interrupts are disabled by the trap.
;;;  However, we proceed as if IFF2 contained the pre-trap state
;;        ld      a,i             ;get p flag = iff2 (side effect)
;;        di                      ;be sure ints are disabled
;;        ld      (REG_I),a       ;save int reg
;;        ld      a,0
;;        jp      po,tr30         ;jif parity odd (flag=0)
;;        inc     a               ;else set a = flag = 1 (enabled)
;;tr30:   ld      (REG_IFF),a     ;save interrupt flag
;;;
;;;  save registers in reg block for return to master
;;        ld      a,10
;;        ld      (REG_STATE),a   ;set state to "TRAP"
;;        jp      ENTER_MON       ;hl = offending pc
;;
;-------------------------------------------------------------------------
;  Initialize monitor
INIT:   ld      sp,MONSTACK
;
;; Enable the following code it you have an initialization table
;; at INIOUT.  See MONZ80.S
;;
;  Initialize target hardware
;;      ld      hl,INIOUT       ;put adress of initialization data table into hl
;;      ld      d,OUTCNT        ;put number of data and addr. pairs into reg. b
;
;  Caution:  OUT and OUTI place the 8 bit address from C on A7-A0, but
;  the contents of the B register on A15-A7.  The Z180's on-chip peripherals
;  decode 16 bits of I/O address, for reasons known only to Zilog.
;  Thus, either be sure B=0 or use the Z180 OTIM
;  We do the former, so as to operate the same code on Z80, Z84C15 or Z80
;;      ld      b,0             ;so a15-a8 will be 0
;;rst10: ld     c,(hl)          ;load address from table
;;      inc     hl
;;      ld      a,(hl)          ;load data from table
;;      inc     hl
;;      out     (c),a           ;output a to i/o address (A15-A8 = 0)
;;      dec     d
;;      jr      nz,rst10        ;loop for d (address, data) pairs
;
;===========================================================================
;  Perform user hardware initialization here

;===========================================================================
;
;  Initialize S16450 UART
;
;  access baud generator, no parity, 1 stop bit, 8 data bits
        ld      a,0b10000011
        out     (S16450+LCR),a
;
;  fixed baud rate of 19200:  crystal is 3.686400 Mhz.
;  Divisor is 3,686400/(16*baud)
        ld      a,12                    ;fix at 19.2 kbaud
        out     (S16450+RXR),a          ;lsb
        xor     a
        out     (S16450+RXR+1),a        ;msb=0
;
;  access data registers, no parity, 1 stop bits, 8 data bits
        ld      a,0b00000011
        out     (S16450+LCR),a
;
;  no loopback, OUT2 on, OUT1 on, RTS on, DTR (LED) on
        ld      a,0b00001111
        out     (S16450+MCR),a
;
;  disable all interrupts: modem, receive error, transmit, and receive
        ld      a,0b00000000
        out     (S16450+IER),a
;
;===========================================================================
;  Initialize user interrupt vectors to point to monitor
        LD      HL,DUMMY_INTS           ;dummy handler code
        LD      DE,USER_CODE            ;start of user codespace
        LD      BC,DUMMY_SIZE           ;number of bytes
        LDIR                            ;copy code

;===========================================================================
;
;  Initialize user registers
        LD      HL,INITSTACK
        LD      (REG_SP),HL             ;INIT USER'S STACK POINTER
        LD      HL,0
        LD      A,L
        LD      (REG_PC),HL             ;INIT ALL REGS TO 0
        LD      (REG_HL),HL
        LD      (REG_BC),HL
        LD      (REG_DE),HL
        LD      (REG_IX),HL
        LD      (REG_IY),HL
        LD      (REG_AF),HL
        LD      (REG_HLX),HL
        LD      (REG_BCX),HL
        LD      (REG_DEX),HL
        LD      (REG_AFX),HL
        LD      (REG_I),A
        LD      (REG_STATE),A           ;set state as "RESET"
        LD      (REG_IFF),A             ;NO INTERRUPTS
;
;  Initialize memory paging variables and hardware (if any)
        LD      (REG_PAGE),A            ;page 0
;;;     LD      (PAGEIMAGE),A
;;;     OUT     (PAGELATCH),A           ;set hardware page
;
;  Set function code for "GO".  Then if we reset after being told to
;  GO, we will come back with registers so user can see the crash
        LD      A,FN_RUN_TARGET
        LD      (COMBUF),A
        JP      RETURN_REGS             ;DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;         CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
        push    bc
        push    de

        ld      de,0x08000              ;long timeout
        ld      bc,SERIAL_STATUS        ;status reg. for loop
gc10:   dec     de
        ld      a,d
        or      e
        jr      z,gc90                  ;exit if timeout
        in      a,(c)                   ;read device status
        bit     RXRDY,A
        jr      z,gc10                  ;not ready yet.
;
;  Data received:  return CY=0. data in A
        xor     a                       ;cy=0
        ld      bc,SERIAL_DATA
        in      a,(c)                   ;read data

        pop     de
        pop     bc
        ret
;
;  Timeout:  return CY=1
gc90:   scf                             ;cy=1
        pop     de
        pop     bc
        ret
;
;===========================================================================
;  Output character in A
;
;  Uses 6 bytes of stack including return address
;
PUTCHAR:
        push    bc                      ;save:  used for I/O address
        push    af                      ;save byte to output
        ld      bc,SERIAL_STATUS        ;status reg. for loop
pc10:   in      a,(c)                   ;read device status
        bit     TXRDY,a                 ;rx ready ?
        jr      z,pc10

        pop     af
        ld      bc,SERIAL_DATA
        out     (c),a                   ;transmit char

        pop     bc
        ret
;
;===========================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:   .DB     0                       ;2: PROCESSOR TYPE = Z80
        .DB     COMBUF_SIZE             ;3: SIZE OF COMMUNICATIONS BUFFER
        .DB     0                       ;4: NO OPTIONS
        .DW     0                       ;5,6: BOTTOM OF PAGED MEM (none)
        .DW     0                       ;7,8: TOP OF PAGED MEM (none)
        .DB     B1-B0                   ;9 BREAKPOINT INSTRUCTION LENGTH
B0:     RST     0x08                    ;10+ BREKAPOINT INSTRUCTION
B1:     .ASCIZ	"NoICE Z80 monitor V3.0";DESCRIPTION, ZERO
        .equ    TSTG_SIZE, .-TSTG          ;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
        .equ    FN_GET_STATUS, 0x0FF    ;reply with device info
        .equ    FN_READ_MEM,   0x0FE    ;reply with data
        .equ    FN_WRITE_MEM,  0x0FD    ;reply with status (+/-)
        .equ    FN_READ_REGS,  0x0FC    ;reply with registers
        .equ    FN_WRITE_REGS, 0x0FB    ;reply with status
        .equ    FN_RUN_TARGET, 0x0FA    ;reply (delayed) with registers
        .equ    FN_SET_BYTES,  0x0F9    ;reply with data (truncate if error)
        .equ    FN_IN,         0x0F8    ;input from port
        .equ    FN_OUT,        0x0F7    ;output to port
;
        .equ    FN_MIN,        0x0F0    ;MINIMUM RECOGNIZED FUNCTION CODE
        .equ    FN_ERROR,      0x0F0    ;error reply to unknown op-code
;
;===========================================================================
;  Enter here via RST nn for breakpoint:  AF, PC are stacked.
;  Enter with A=interrupt code = processor state
;  Interrupt status is not changed from user program and IFF2==IFF1
INT_ENTRY:
;
;  Interrupts may be on:  get IFF as quickly as possible, so we can DI
        LD      (REG_STATE),A   ;save entry state
        LD      (REG_HL),HL     ;SAVE HL
        LD      A,I             ;GET P FLAG = IFF2 (SIDE EFFECT)
        DI                      ;NO INTERRUPTS ALLOWED
;
        LD      (REG_I),A       ;SAVE INT REG
        LD      A,0
        JP      PO,BREAK10      ;JIF PARITY ODD (FLAG=0)
        INC     A               ;ELSE SET A = FLAG = 1 (ENABLED)
BREAK10: LD     (REG_IFF),A     ;SAVE INTERRUPT FLAG
;
;  Save registers in reg block for return to master
        POP     HL              ;GET FLAGS IN L, ACCUM IN H
        LD      (REG_AF),HL     ;SAVE A AND FLAGS
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.  Else leave PC alone.
;  (If CALL is used for breakpoint, then back up by 3 bytes)
        POP     HL              ;GET PC OF BREAKPOINT/INTERRUPT
        LD      A,(REG_STATE)
        CP      1
        JR      NZ,NOTBP        ;JIF NOT A BREAKPOINT
        DEC     HL              ;BACK UP PC TO POINT AT BREAKPOINT
NOTBP:  JP      ENTER_MON       ;HL POINTS AT BREAKPOINT OPCODE
;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:   LD      SP,MONSTACK             ;CLEAN STACK IS HAPPY STACK
        LD      HL,COMBUF               ;BUILD MESSAGE HERE
;
;  First byte is a function code
        CALL    GETCHAR                 ;GET A FUNCTION (uses 6 bytes of stack)
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        CP      FN_MIN
        JR      C,MAIN                  ;JIF BELOW MIN: ILLEGAL FUNCTION
        LD      (HL),A                  ;SAVE FUNCTION CODE
        INC     HL
;
;  Second byte is data byte count (may be zero)
        CALL    GETCHAR                 ;GET A LENGTH BYTE
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        CP      COMBUF_SIZE+1
        JR      NC,MAIN                 ;JIF TOO LONG: ILLEGAL LENGTH
        LD      (HL),A                  ;SAVE LENGTH
        INC     HL
        OR      A
        JR      Z,MA80                  ;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
        LD      B,A                     ;SAVE LENGTH FOR LOOP
MA10:   CALL    GETCHAR                 ;GET A DATA BYTE
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        LD      (HL),A                  ;SAVE DATA BYTE
        INC     HL
        DJNZ    MA10
;
;  Get the checksum
MA80:   CALL    GETCHAR                 ;GET THE CHECKSUM
        JR      C,MAIN                  ;JIF TIMEOUT: RESYNC
        LD      C,A                     ;SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
        CALL    CHECKSUM
        ADD     A,C
        JR      NZ,MAIN                 ;JIF BAD CHECKSUM
;
;  Process the message.
        LD      A,(COMBUF+0)            ;GET THE FUNCTION CODE
        CP      FN_GET_STATUS
        JP      Z,TARGET_STATUS
        CP      FN_READ_MEM
        JP      Z,READ_MEM
        CP      FN_WRITE_MEM
        JP      Z,WRITE_MEM
        CP      FN_READ_REGS
        JP      Z,READ_REGS
        CP      FN_WRITE_REGS
        JP      Z,WRITE_REGS
        CP      FN_RUN_TARGET
        JP      Z,RUN_TARGET
        CP      FN_SET_BYTES
        JP      Z,SET_BYTES
        CP      FN_IN
        JP      Z,IN_PORT
        CP      FN_OUT
        JP      Z,OUT_PORT
;
;  Error: unknown function.  Complain
        LD      A,FN_ERROR
        LD      (COMBUF+0),A    ;SET FUNCTION AS "ERROR"
        LD      A,1
        JP      SEND_STATUS     ;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
TARGET_STATUS:
;
        LD      HL,TSTG                 ;DATA FOR REPLY
        LD      DE,COMBUF+1             ;RETURN BUFFER
        LD      BC,TSTG_SIZE            ;LENGTH OF REPLY
        LD      A,C
        LD      (DE),A                  ;SET SIZE IN REPLY BUFFER
        INC     DE
        LDIR                            ;MOVE REPLY DATA TO BUFFER
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
READ_MEM:
;
;  Set page
;;      LD      A,(COMBUF+2)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
;  Get address
        LD      HL,(COMBUF+3)
        LD      A,(COMBUF+5)            ;NUMBER OF BYTES TO GET
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LD      DE,COMBUF+1            ;POINTER TO LEN, DATA
        LD      (DE),A                  ;RETURN LENGTH = REQUESTED DATA
        INC     DE
        OR      A
        JR      Z,GLP90                 ;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
        LD      B,A
GLP:    LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO RETURN BUFFER
        INC     HL
        INC     DE
        DJNZ    GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:  JP      SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Uses 2 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;      LD      A,(COMBUF+2)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
        LD      HL,COMBUF+5             ;POINTER TO SOURCE DATA IN MESSAGE
        LD      DE,(COMBUF+3)           ;POINTER TO DESTINATION
        LD      A,(COMBUF+1)            ;NUMBER OF BYTES IN MESSAGE
        SUB     3                       ;LESS PAGE, ADDRLO, ADDRHI
        JR      Z,WLP50                 ;EXIT IF NONE REQUESTED
;
;  Write the specified bytes to local memory
        LD      B,A
        PUSH    BC                      ;SAVE BYTE COUNTER
WLP10:  LD      A,(HL)                  ;BYTE FROM HOST
        LD      (DE),A                  ;WRITE TO TARGET RAM
        INC     HL
        INC     DE
        DJNZ    WLP10
;
;  Compare to see if the write worked
        LD      HL,COMBUF+5             ;POINTER TO SOURCE DATA IN MESSAGE
        LD      DE,(COMBUF+3)           ;POINTER TO DESTINATION
        POP     BC                      ;SIZE AGAIN
;
;  Compare the specified bytes to local memory
WLP20:  LD      A,(DE)                  ;READ BACK WHAT WE WROTE
        CP      (HL)                    ;COMPARE TO HOST DATA
        JR      NZ,WLP80                ;JIF WRITE FAILED
        INC     HL
        INC     DE
        DJNZ    WLP20
;
;  Write succeeded:  return status = 0
WLP50:  XOR     A                       ;RETURN STATUS = 0
        JR      WLP90
;
;  Write failed:  return status = 1
WLP80:  LD      A,1
;
;  Return OK status
WLP90:  JP      SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
        LD      HL,TASK_REGS            ;REGISTER LIVE HERE
        LD      A,T_REGS_SIZE           ;NUMBER OF BYTES
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        LD      DE,COMBUF+1             ;POINTER TO LEN, DATA
        LD      (DE),A                  ;SAVE DATA LENGTH
        INC     DE
;
;  Copy the registers
        LD      B,A
GRLP:   LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO RETURN BUFFER
        INC     HL
        INC     DE
        DJNZ    GRLP
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
WRITE_REGS:
;
        LD      HL,COMBUF+2             ;POINTER TO DATA
        LD      A,(COMBUF+1)            ;NUMBER OF BYTES
        OR      A
        JR      Z,WRR80                 ;JIF NO REGISTERS
;
;  Copy the registers
        LD      DE,TASK_REGS            ;OUR REGISTERS LIVE HERE
        LD      B,A
WRRLP:  LD      A,(HL)                  ;GET BYTE TO A
        LD      (DE),A                  ;STORE TO REGISTER RAM
        INC     HL
        INC     DE
        DJNZ    WRRLP
;
;  Return OK status
WRR80:  XOR     A
        JP      SEND_STATUS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Uses 4 bytes of stack
;
RUN_TARGET:
;
;  Restore user's page
;;      LD      A,(REG_PAGE)
;;      LD      (PAGEIMAGE),A
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A
;
;  Restore alternate registers
        LD      HL,(REG_AFX)
        PUSH    HL
        POP     AF
        EX      AF,AF'                  ;LOAD ALTERNATE AF
        ;
        LD      HL,(REG_HLX)
        LD      BC,(REG_BCX)
        LD      DE,(REG_DEX)
        EXX                             ;LOAD ALTERNATE REGS
;
;  Restore main registers
        LD      BC,(REG_BC)
        LD      DE,(REG_DE)
        LD      IX,(REG_IX)
        LD      IY,(REG_IY)
        LD      A,(REG_I)
        LD      I,A
;
;  Switch to user stack
        LD      HL,(REG_PC)             ;USER PC
        LD      SP,(REG_SP)             ;BACK TO USER STACK
        PUSH    HL                      ;SAVE USER PC FOR RET
        LD      HL,(REG_AF)
        PUSH    HL                      ;SAVE USER A AND FLAGS FOR POP
        LD      HL,(REG_HL)             ;USER HL
;
;  Restore user's interrupt state
        LD      A,(REG_IFF)
        OR      A
        JR      Z,RUTT10                ;JIF INTS OFF: LEAVE OFF
;
;  Return to user with interrupts enabled
        POP     AF
        EI                              ;ELSE ENABLE THEM NOW
        RET
;
;  Return to user with interrupts disabled
RUTT10: POP     AF
        RET
;
;===========================================================================
;
;  Common continue point for all monitor entrances
;  HL = user PC, SP = user stack
;  REG_STATE has current state, REG_HL, REG_I, REG_IFF, REG_AF set
;
;  Uses 2 bytes of stack
;
ENTER_MON:
        LD      (REG_SP),SP     ;SAVE USER'S STACK POINTER
        LD      SP,MONSTACK     ;AND USE OURS INSTEAD
;
        LD      (REG_PC),HL
        LD      (REG_BC),BC
        LD      (REG_DE),DE
        LD      (REG_IX),IX
        LD      (REG_IY),IY
;
;  Get alternate register set
        EXX
        LD      (REG_HLX),HL
        LD      (REG_BCX),BC
        LD      (REG_DEX),DE
        EX      AF,AF'
        PUSH    AF
        POP     HL
        LD      (REG_AFX),HL
;
;;      LD      A,(PAGEIMAGE    ;GET CURRENT USER PAGE
        XOR     A               ;...OR NONE IF UNPAGED TARGET
        LD      (REG_PAGE),A    ;SAVE USER PAGE
;
;  Return registers to master
        JP      RETURN_REGS

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
        LD      HL,COMBUF+1
        LD      B,(HL)                  ;LENGTH = 4*NBYTES
        INC     HL
        INC     B
        DEC     B
        LD      C,0                     ;C GETS COUNT OF INSERTED BYTES
        JR      Z,SB90                  ;JIF NO BYTES (C=0)
        PUSH    HL
        POP     IX                      ;IX POINTS TO RETURN BUFFER
;
;  Loop on inserting bytes
SB10:   LD      A,(HL)                  ;MEMORY PAGE
        INC     HL
;;      LD      (PAGEIMAGE),A
;;      PUSH    BC
;;      LD      BC,PAGELATCH
;;      OUT     (BC),A                  ;SET PAGE
;;      POP     BC
        LD      E,(HL)                  ;ADDRESS TO DE
        INC     HL
        LD      D,(HL)
        INC     HL
;
;  Read current data at byte location
        LD      A,(DE)                  ;READ CURRENT DATA
        LD      (IX+0),A                ;SAVE IN RETURN BUFFER
        INC     IX
;
;  Insert new data at byte location
        LD      A,(HL)
        LD      (DE),A                  ;SET BYTE
        LD      A,(DE)                  ;READ IT BACK
        CP      (HL)                    ;COMPARE TO DESIRED VALUE
        JR      NZ,SB90                 ;BR IF INSERT FAILED: ABORT
        INC     HL
        INC     C                       ;ELSE COUNT ONE BYTE TO RETURN
;
        DEC     B
        DEC     B
        DEC     B
        DJNZ    SB10                    ;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:   LD      A,C
        LD      (COMBUF+1),A            ;SET COUNT OF RETURN BYTES
;
;  Compute checksum on buffer, and send to master, then return
        JP      SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
IN_PORT:
;
;  Get port address
        LD      BC,(COMBUF+2)
;
;  Read port value
        IN      A,(C)           ;IN WITH A15-A8 = B; A7-A0 = C
;
;  Return byte read as "status"
        JP      SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
OUT_PORT:
;
;  Get port address
        LD      BC,(COMBUF+2)
;
;  Get data
        LD      A,(COMBUF+4)
;
;  Write value to port
        OUT     (C),A           ;OUT WITH A15-A8 = B; A7-A0 = C
;
;  Return status of OK
        XOR     A
        JP      SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
        LD      (COMBUF+2),A            ;SET STATUS
        LD      A,1
        LD      (COMBUF+1),A            ;SET LENGTH
        JR      SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:   CALL    CHECKSUM                ;GET A=CHECKSUM, HL->checksum location
        NEG
        LD      (HL),A                  ;STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
        LD      HL,COMBUF               ;POINTER TO DATA
        LD      A,(COMBUF+1)            ;LENGTH OF DATA
        ADD     A,3                     ;PLUS FUNCTION, LENGTH, CHECKSUM
        LD      B,A                     ;save count for loop
SND10:  LD      A,(HL)
        CALL    PUTCHAR                 ;SEND A BYTE (uses 6 bytes of stack)
        INC     HL
        DJNZ    SND10
        JP      MAIN                    ;BACK TO MAIN LOOP

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
        LD      HL,COMBUF               ;pointer to buffer
        LD      A,(COMBUF+1)            ;length of message
        ADD     A,2                     ;plus function, length
        LD      B,A                     ;save count for loop
        XOR     A                       ;init checksum to 0
CHK10:  ADD     A,(HL)
        INC     HL
        DJNZ    CHK10                   ;loop for all
        RET                             ;return with checksum in A
;
;===========================================================================
;  Hardware initialization table
INIOUT:
        .equ    OUTCNT, (.-INIOUT)/2    ; NUMBER OF INITIALIZING PAIRS

        .END    RESET
