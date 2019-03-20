;  ASMN8051.ASM - 8051 Debug monitor for use with NoICE51
;
;  This file may be assembled with the ASxxxx 8051 assembler AS8051.
;
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;       17-Sep-93 JLH version 1.2: tested on Siemens 80535
;        1-Nov-93 JLH init PC to USER_CODE
;       27-Jan-94 JLH bug in OUT_PORT: forgot to bypass high address
;       19-Jan-96 JLH spelling error in comment near WRR80
;       03-Feb-98 JLH add vectors for 80515C et al
;       25-Jun-99 JLH add NOP to make dummy vectors all the same length
;       21-Jul-00 JLH change FN_MIN from F7 to F0
;       22-Sep-00 JLH add CALL address to TSTG
;       12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;	28-May-01 ARB Modified for the ASxxxx AS8051 assembler
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
;  For more information, refer to the NoICE help files 2bitmmu.htm
;  and targets.htm#8051
;
;==========================================================================
;
; AS8051 Specifics
;
; Area Definitions
	.area	CODE	(ABS,OVR)
; Default Radix
	.radix	D
;
;============================================================================
;  HARDWARE PLATFORM CUSTOMIZATIONS
;
;  This monitor uses no full-time storage in onchip RAM.
;  - It runs on the user's stack (SP initialized at reset to MONSTACK)
;    Uses at most 6 bytes of the stack to perform breakpoint.
;    This could be reduced by using on-chip RAM to store some
;    intermediate register values.
;  - It saves user registers in off-chip RAM upon entry
;  - It uses the user's register set during execution
;
;  Interrupts are re-routed from low memory (where this monitor resides) to
;  the beginning of USER_CODE.  Programs being tested should be ORG'ed
;  there.
;
;  Location of monitor code (0, except during debug under another monitor)
        .equ    NOICE_CODE, 0x0000      ;START OF NOICE INTERRUPTS/CODE
;
;  For debug, we run with user code in external RAM
        .equ    USER_CODE, 0x8000       ;START OF USER INTERRUPTS/CODE
;
;  Tuck the monitor RAM at the top of external memory, out of the way
        .equ    RAM_START, 0xFF00       ;START OF MONITOR RAM
;
;  Stack grows up.  This gives room for monitor plus a little below 7F
;  Some chips have RAM between 80 and FF which can be accessed by SP
        .equ    MONSTACK,  0x0070       ;INITIAL MONITOR SP
;
;  Hardware equates
        .equ    TMOD,	0x89            ;timer mode register
        .equ    TCON,	0x88            ;timer control register
        .equ    TH0,	0x8C            ;timer0 reload register
        .equ    TH1,	0x8D            ;timer1 reload register
        .equ    SCON,	0x98            ;serial control register
        .equ    SBUF,	0x99            ;serial data register
        .equ    RI,	0x98            ;RX ready bit in UART status register
        .equ    TI,	0x99            ;TX ready bit in UART status register
;
;===========================================================================
;  8051 Direct memory equates
        .equ    ACC,	0xE0
        .equ    B,	0xF0
        .equ    PSW,	0xD0
        .equ    DPTRL,	0x82
        .equ    DPTRH,	0x83

;===========================================================================
;
;  Off-chip RAM definitions
        .org    RAM_START
;
;  Target registers:  order must match that in TRG8051.C
TASK_REGS:
 REG_STATE:     .rs     1
 REG_PAGE:      .rs     1
 REG_PSW:       .rs     1
 REG_DPTR:      .rs     2
 REG_IE:        .rs     1
 REG_A:         .rs     1
 REG_B:         .rs     1
 REG_R:         .rs     8               ;8 USER REGISTERS
 REG_PC:        .rs     2
 REG_SP:        .rs     1
        .equ    T_REGS_SIZE, .-TASK_REGS
;
;  Communications buffer
;  (Must be at least as long as the longer of TASK_REG_SZ or TSTG_SIZE.
;  At least 19 bytes recommended.  Larger values may improve speed of NoICE
;  download and memory move commands.)
        .equ    COMBUF_SIZE, 64         ;DATA SIZE FOR COMM BUFFER
COMBUF:         .rs     2+COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND CHECK
;
        .equ    RAM_END, .              ;ADDRESS OF TOP+1 OF RAM
;
;===========================================================================
;  Interrupt vectors
;
;  Reset
        .ORG    NOICE_CODE + 0
        AJMP    RESET
;
;  IE0 interrupt
        .ORG    NOICE_CODE + 0x03
        LJMP    USER_CODE + 0x03
;
;  TF0 interrupt
        .ORG    NOICE_CODE + 0x0B
        LJMP    USER_CODE + 0x0B
;
;  IE1 interrupt
        .ORG    NOICE_CODE + 0x13
        LJMP    USER_CODE + 0x13
;
;  TF1 interrupt
        .ORG    NOICE_CODE + 0x1B
        LJMP    USER_CODE + 0x1B
;
;  RI & TI interrupt
        .ORG    NOICE_CODE + 0x23
        LJMP    USER_CODE + 0x23
;
;  TF2 & EXF2 interrupt
        .ORG    NOICE_CODE + 0x2B
        LJMP    USER_CODE + 0x2B
;
;  The following interrupts are present on the 80515C and some other
;  8051 variants.  If you need to save EPROM space, you can delete
;  any or all of these if your target does not use them
;
        .ORG    NOICE_CODE + 0x33
        LJMP    USER_CODE + 0x33
        .ORG    NOICE_CODE + 0x3B
        LJMP    USER_CODE + 0x3B
;
        .ORG    NOICE_CODE + 0x43
        LJMP    USER_CODE + 0x43
        .ORG    NOICE_CODE + 0x4B
        LJMP    USER_CODE + 0x4B
;
        .ORG    NOICE_CODE + 0x53
        LJMP    USER_CODE + 0x53
        .ORG    NOICE_CODE + 0x5B
        LJMP    USER_CODE + 0x5B
;
        .ORG    NOICE_CODE + 0x63
        LJMP    USER_CODE + 0x63
        .ORG    NOICE_CODE + 0x6B
        LJMP    USER_CODE + 0x6B
;
        .ORG    NOICE_CODE + 0x73
        LJMP    USER_CODE + 0x73
        .ORG    NOICE_CODE + 0x7B
        LJMP    USER_CODE + 0x7B
;
        .ORG    NOICE_CODE + 0x83
        LJMP    USER_CODE + 0x83
        .ORG    NOICE_CODE + 0x8B
        LJMP    USER_CODE + 0x8B
;
        .ORG    NOICE_CODE + 0x93
        LJMP    USER_CODE + 0x93
        .ORG    NOICE_CODE + 0x9B
        LJMP    USER_CODE + 0x9B
;
        .ORG    NOICE_CODE + 0xA3
        LJMP    USER_CODE + 0xA3
        .ORG    NOICE_CODE + 0xAB
        LJMP    USER_CODE + 0xAB
;
;
;  Default handlers for interrupts (This code is copied to USER_CODE during
;  RESET, so that uninitialized interrupt vectors will return to the monitor)
;
GETDUM: MOVC    A,@A+PC                 ;GET BYTE FROM DUMMY_INT TABLE
        RET                             ;RETURN (NEVER CALL WITH A=0!)
;
DUMMY_INTS:
        LJMP    BREAKPOINT_ENTRY        ;ENTER MONITOR WITH PC ON STACK
;
;  IE0 interrupt (03)
        PUSH    ACC
        MOV     A,#2                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  TF0 interrupt (0B)
        PUSH    ACC
        MOV     A,#3                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  IE1 interrupt (13)
        PUSH    ACC
        MOV     A,#4                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  TF1 interrupt (1B)
        PUSH    ACC
        MOV     A,#5                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  RI & TI interrupt (23)
        PUSH    ACC
        MOV     A,#6                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  TF2 & EXF2 interrupt (2B)
        PUSH    ACC
        MOV     A,#7                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
;  The following interrupts are present on the 80515C and some other
;  8051 variants.  If you need to save EPROM space, you can delete
;  any or all of these if your target does not use them.
;
;  Interrupt identifiers in the range 0 to 33 will be displayed
;  as text.  If the default values for the 80515C (shown) are not
;  appropriate, use the STATETEXT command to change the strings.
;
;  Interrupt 33
        PUSH    ACC
        MOV     A,#8                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 3B
        PUSH    ACC
        MOV     A,#9                    ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 43: ADC
        PUSH    ACC
        MOV     A,#10                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 4B: IEX2
        PUSH    ACC
        MOV     A,#11                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 53: IEX3
        PUSH    ACC
        MOV     A,#12                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 5B: IEX4
        PUSH    ACC
        MOV     A,#13                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 63: IEX5
        PUSH    ACC
        MOV     A,#14                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 6B: IEX6
        PUSH    ACC
        MOV     A,#15                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 73:
        PUSH    ACC
        MOV     A,#16                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 7B: Wake up from power down
        PUSH    ACC
        MOV     A,#17                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 83: Serial 1
        PUSH    ACC
        MOV     A,#18                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 8B: CAN
        PUSH    ACC
        MOV     A,19                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 93: SSC
        PUSH    ACC
        MOV     A,#20                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt 9B: CTF
        PUSH    ACC
        MOV     A,#21                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt A3: IEX7
        PUSH    ACC
        MOV     A,#22                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;  Interrupt AB: IEX8
        PUSH    ACC
        MOV     A,#23                   ;IDENTIFY THIS INTERRUPT
        LJMP    INT_ENTRY               ;ENTER MONITOR WITH PC, PSW ON STACK
        NOP                             ;USE A BYTE UNTIL NEXT VECTOR
;
        .equ    DUMMY_SIZE, .-DUMMY_INTS
;
;===========================================================================
;  Power on reset or trap
RESET:
        MOV     SP,#MONSTACK            ;initial stack pointer
        ANL     PSW,#0b11100111         ;register bank 0
;
;  Initialize target hardware
        MOV     IE,#0                   ;disable all interrupts
;
;  Initialize the on-chip serial port for mode 1
;  Set timer 1 for baud rate: auto reload timer
        MOV     PCON,#0x80              ;SET FOR DOUBLE BAUD RATE
        MOV     TMOD,#0b00100010        ;two 8-bit auto-reload counters
        MOV     TH1,#0xFD               ;19.2K FROM 11.059 MHZ
        MOV     SCON,#0b01010010        ;mode 1, TI set
        SETB    TR1                     ;start timer for serial port
;
;  Perform user hardware initialization here

;===========================================================================
;  Initialize user interrupt vectors to point to monitor
        MOV     R6,#DUMMY_SIZE          ;NUMBER OF BYTES
        MOV     R5,#1                   ;INDEX FOR GETDUM
        MOV     DPTR,#USER_CODE         ;START OF USER CODE SPACE
VINI:   MOV     A,R5                    ;A = INDEX
        ACALL   GETDUM                  ;GET BYTE FROM DUMMY_INT[A]
        MOVX    @DPTR,A                 ;INIT A BYTE OF VECTOR
        INC     DPTR
        INC     R5
        DJNZ    R6,VINI
;
;  Initialize user registers to zeros
        MOV     DPTR,#TASK_REGS
        MOV     A,#0
        MOV     R6,#T_REGS_SIZE         ;NUMBER OF REGISTERS
RINI:   MOVX    @DPTR,A                 ;INIT A BYTE OF REGISTERS
        INC     DPTR
        DJNZ    R6,RINI
;
;  Initialize non-zero user registers
        MOV     DPTR,#REG_PC
        MOV     A,#<USER_CODE           ;LSB
;ARB    MOV     A,#USER_CODE & 0xFF     ;LSB
        MOVX    @DPTR,A                 ;INIT PC AT USER CODE
        INC     DPTR
        MOV     A,#>USER_CODE           ;MSB
;ARB    MOV     A,#USER_CODE >> 8       ;MSB
        MOVX    @DPTR,A

        MOV     DPTR,#REG_SP
        MOV     A,#MONSTACK
        MOVX    @DPTR,A                 ;INIT USER STACK POINTER
;
;  Initialize memory paging variables and hardware (if any)
;;;     MOV     A,#??
;;;     MOV     PAGEIMAGE,A
;;;     MOV     PAGELATCH,A
;
;  Set function code for "GO".  Then if we are here because of a reset
;  (such as a Watchdog timeout) after being told to GO, we will come
;  back with registers so user can see the reset
        MOV     A,#FN_RUN_TARGET
        MOV     DPTR,#COMBUF
        MOVX    @DPTR,A
        AJMP    RETURN_REGS             ;DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;         CY=1 if timeout (0.5 seconds)
;
;  Uses 2 bytes of stack including return address
;
GETCHAR:
;
;  (Add timeout (return CY=1) if no byte recieved in 500 msec, if desired)
;  (Add Watchdog Timer service if required)
GC10:   JNB     RI,GC10         ;loop til ready
        CLR     RI              ;turn bit off
;
;  Data received:  return CY=0. data in A
        CLR     C
        MOV     A,SBUF
        RET
;
;===========================================================================
;  Output character in A
;
;  Uses 2 bytes of stack including return address
;
PUTCHAR:
PC10:   JNB     TI,PC10         ;loop til output complete
        CLR     TI              ;turn bit off
        MOV     SBUF,A          ;send data
        RET
;
;===========================================================================
;
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:   .db     4                       ;2: PROCESSOR TYPE = 8051
        .db     COMBUF_SIZE             ;3: SIZE OF COMMUNICATIONS BUFFER
        .db     0x80                    ;4: has CALL
        .dw     0                       ;5,6: BOTTOM OF PAGED MEM (none)
        .dw     0                       ;7,8: TOP OF PAGED MEM (none)
        .db     B1-B0                   ;9 BREAKPOINT INSTRUCTION LENGTH
B0:     LCALL   BREAKPOINT_ENTRY        ;10+ BREKAPOINT INSTRUCTION
B1:     .asciz  "8051 monitor V3.0"     ;DESCRIPTION, ZERO
        .equ    BRK_SIZE, B1-B0         ;DEFINE LENGTH OF A BREAKPOINT INSTR.
        .db     0                       ;page of CALL breakpoint
        .dw     B0                      ;address of CALL breakpoint in native order

        .equ    TSTG_SIZE, .-TSTG       ;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
        .equ    FN_GET_STATUS, 0xFF    ;reply with device info
        .equ    FN_READ_MEM,   0xFE    ;reply with data
        .equ    FN_WRITE_MEM,  0xFD    ;reply with status (+/-)
        .equ    FN_RD_REGS,    0xFC    ;reply with registers
        .equ    FN_WR_REGS,    0xFB    ;reply with status
        .equ    FN_RUN_TARGET, 0xFA    ;reply (delayed) with registers
        .equ    FN_SET_BYTES , 0xF9    ;reply with data (truncate if error)
        .equ    FN_IN        , 0xF8    ;input from port
        .equ    FN_OUT       , 0xF7    ;output to port
;
        .equ    FN_MIN       , 0xF0    ;MINIMUM RECOGNIZED FUNCTION CODE
        .equ    FN_ERROR     , 0xF0    ;error reply to unknown op-code
;
;===========================================================================
;  Enter here via CALL for breakpoint.  PC is stacked
BREAKPOINT_ENTRY:
        PUSH    ACC                     ;3 bytes on stack
        MOV     A,#1                    ;state is "breakpoint"
;
;  Enter here via JMP for unserviced interrupt.  PC and A are stacked
;  Enter with A=interrupt code = processor state
INT_ENTRY:
;
;  Interrupts may be on.  Save enable register and disable interrupts
        PUSH    IE                      ;save IE (4 bytes on stack)
        CLR     EA                      ;clear master interrupt enable bit
;
;  Save registers in reg block for return to master
        PUSH    DPTRH
        PUSH    DPTRL                   ;save DPTR (6 bytes on stack)
        MOV     DPTR,#TASK_REGS
        MOVX    @DPTR,A                 ;save state
        INC     DPTR
        MOV     A,#0
;;;     MOV     A,PAGEIMAGE
        MOVX    @DPTR,A                 ;REG_PAGE gets page, if any, else 0
        INC     DPTR
;
;  The 8051 has the most indestructable condition codes of any processor
;  I have every seen:  all bits should still be intact from the
;  entrypoint!
        MOV     A,PSW
        MOVX    @DPTR,A                 ;save PSW
        INC     DPTR
        POP     ACC
        MOVX    @DPTR,A                 ;save DPTR LO
        INC     DPTR
        POP     ACC                     ;DPTR HI (4 bytes on stack)
        MOVX    @DPTR,A                 ;save DPTR HI
        INC     DPTR
        POP     ACC                     ;IE (3 bytes on stack)
        MOVX    @DPTR,A                 ;save IE
        INC     DPTR
        POP     ACC                     ;A (2 bytes on stack)
        MOVX    @DPTR,A                 ;save A
        INC     DPTR
        MOV     A,B
        MOVX    @DPTR,A                 ;save B
        INC     DPTR
;
        ACALL   SAVEREG                 ;SAVE R0-R7 TO DPTR++
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.  Else leave PC alone.
        MOV     DPTR,#REG_STATE
        MOVX    A,@DPTR
        MOV     R0,A                    ;Get state to R0
        POP     ACC                     ;PCH (1 byte on stack)
        MOV     R1,A
        POP     ACC                     ;PCL (0 bytes on stack)
        CJNE    R0,#1,NOTBP             ;JIF NOT A BREAKPOINT
        ADD     A,#-BRK_SIZE            ;BACK UP PC TO POINT AT BREAKPOINT
        JC      NOTBP                   ;JIF NO BORROW REQUIRED
        DEC     R1                      ;ELSE DECREMENT MSB OF PC
NOTBP:  MOV     DPTR,#REG_PC
        MOVX    @DPTR,A                 ;save PCL
        INC     DPTR
        MOV     A,R1
        MOVX    @DPTR,A                 ;save PCH
        INC     DPTR
;
        MOV     A,SP
        MOVX    @DPTR,A                 ;save SP
;
;  Return registers to master
        AJMP    RETURN_REGS
;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:   MOV     DPTR,#COMBUF            ;BUILD MESSAGE HERE
;
;  First byte is a function code
        ACALL   GETCHAR                 ;GET A FUNCTION (uses 6 bytes of stack)
        JC      MAIN                    ;JIF TIMEOUT: RESYNC
        CJNE    A,#FN_MIN,M1            ;SUBTRACT (CY WAS 0)
M1:     JC      MAIN                    ;JIF BELOW MIN: ILLEGAL FUNCTION
        MOVX    @DPTR,A                 ;SAVE FUNCTION CODE
        INC     DPTR
;
;  Second byte is data byte count (may be zero)
        ACALL   GETCHAR                 ;GET A LENGTH BYTE
        JC      MAIN                    ;JIF TIMEOUT: RESYNC
        CJNE    A,#COMBUF_SIZE+1,M2
M2:     JNC     MAIN                    ;JIF TOO LONG: ILLEGAL LENGTH
        MOVX    @DPTR,A                 ;SAVE LENGTH
        INC     DPTR
        JZ      MA80                    ;SKIP DATA LOOP IF LENGTH IN A = 0
;
;  Loop for data
        MOV     R6,A                    ;SAVE LENGTH FOR LOOP
MA10:   ACALL   GETCHAR                 ;GET A DATA BYTE
        JC      MAIN                    ;JIF TIMEOUT: RESYNC
        MOVX    @DPTR,A                 ;SAVE DATA BYTE
        INC     DPTR
        DJNZ    R6,MA10
;
;  Get the checksum
MA80:   ACALL   GETCHAR                 ;GET THE CHECKSUM
        JC      MAIN                    ;JIF TIMEOUT: RESYNC
        MOV     R5,A                    ;SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
        ACALL   CHECKSUM
        ADD     A,R5
        JNZ     MAIN                    ;JIF BAD CHECKSUM (A != 0)
;
;  Process the message.
        MOV     DPTR,#COMBUF
        MOVX    A,@DPTR                 ;GET THE FUNCTION CODE
        MOV     R6,A
        INC     DPTR
        MOVX    A,@DPTR                 ;GET THE LENGTH
        XCH     A,R6                    ;A=FUNCTION, R6=LENGTH
        INC     DPTR                    ;DPTR POINTS AT FIRST DATA
;
        CJNE    A,#FN_GET_STATUS,M3
        AJMP    TARGET_STATUS
M3:     CJNE    A,#FN_READ_MEM,M4
        AJMP    READ_MEM
M4:     CJNE    A,#FN_WRITE_MEM,M5
        AJMP    WRITE_MEM
M5:     CJNE    A,#FN_RD_REGS,M6
        AJMP    READ_REGS
M6:     CJNE    A,#FN_WR_REGS,M7
        AJMP    WRITE_REGS
M7:     CJNE    A,#FN_RUN_TARGET,M8
        AJMP    RUN_TARGET
M8:     CJNE    A,#FN_SET_BYTES,M9
        AJMP    SET_BYTES
M9:     CJNE    A,#FN_IN,M10
        AJMP    IN_PORT
M10:    CJNE    A,#FN_OUT,M11
        AJMP    OUT_PORT
;
;  Error: unknown function.  Complain
M11:    MOV     A,#FN_ERROR
        MOV     DPTR,#COMBUF
        MOVX    @DPTR,A                 ;SET FUNCTION AS "ERROR"
        MOV     A,#1
        AJMP    SEND_STATUS             ;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
TARGET_STATUS:
;
        MOV     DPTR,#COMBUF+1
        MOV     A,#TSTG_SIZE            ;LENGTH OF REPLY
        MOVX    @DPTR,A                 ;SET SIZE IN REPLY BUFFER
        INC     DPTR
        MOV     R6,A                    ;BYTE COUNTER
;
;  Loop on data in string
        MOV     R7,#0                   ;INDEX REG FOR MOVC
TS10:   MOV     R0,DPTRL                ;SAVE DESTINATION (COMBUF) POINTER
        MOV     R1,DPTRH
;
        MOV     DPTR,#TSTG
        MOV     A,R7                    ;INDEX INTO STRING
        MOVC    A,@A+DPTR               ;GET BYTE FROM CODE SPACE
        INC     R7                      ;NEXT INDEX
;
        MOV     DPTRL,R0                ;DESTINATION (COMBUF) POINTER
        MOV     DPTRH,R1
        MOVX    @DPTR,A
        INC     DPTR
        DJNZ    R6,TS10                 ;LOOP ON BYTES
;
;  Compute checksum on buffer, and send to master, then return
;  (DPTR points at next free byte)
        AJMP    SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
;  Note:  this function mapps a 16 bit address as follows:
;       0000 to 007f reads from internal RAM
;       0080 to 00ff reads from internal RAM - NOT SFR SPACE
;       0100 to ffff reads from external data/code space
;
READ_MEM:
;
;  Set page
;;      MOVX    A,@DPTR
;;      MOV     PAGEIMAGE,A
;;      MOV     PAGELATCH,A
        INC     DPTR
;
;  Get address
        MOVX    A,@DPTR                 ;LOW ADDRESS
        MOV     R0,A
        INC     DPTR
        MOVX    A,@DPTR                 ;HIGH ADDRESS
        MOV     R1,A
        INC     DPTR
;
;  Get byte count
        MOVX    A,@DPTR                 ;BYTE COUNT
        MOV     R6,A
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        MOV     DPTR,#COMBUF+1          ;POINTER TO LEN, DATA
        MOVX    @DPTR,A                 ;RETURN LENGTH = REQUESTED DATA
        INC     DPTR
        JZ      GLP90                   ;JIF NO BYTES TO GET (A=0)
;
;  Read the requested bytes from local memory
GLP:    MOV     R2,DPTRL                ;SAVE DESTINATION (COMBUF) POINTER
        MOV     R3,DPTRH
;
;  Fork on memory type
        MOV     DPTRL,R0                ;SOURCE (MEMORY) POINTER
        MOV     DPTRH,R1
        CJNE    R1,#0,GLP10             ;JIF NOT PAGE ZERO
;
;  Read internal memory (NOT SFR!!!)
;  (If SFRs are desired, use the code shown below for FN_IN)
        MOV     A,@R0
        SJMP    GLP80
;
;  Read external memory
GLP10:  MOVX    A,@DPTR
;
;  Increment 16 bit source pointer
GLP80:  INC     DPTR
        MOV     R0,DPTRL                ;SAVE SOURCE (MEMORY) POINTER
        MOV     R1,DPTRH
;
;  Store byte in return buffer
        MOV     DPTRL,R2                ;DESTINATION (COMBUF) POINTER
        MOV     DPTRH,R3
        MOVX    @DPTR,A
        INC     DPTR
        DJNZ    R6,GLP                  ;LOOP ON READING BYTES
;
;  Compute checksum on buffer, and send to master, then return
GLP90:  AJMP    SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
;  Note:  this function mapps a 16 bit address as follows:
;       0000 to 007f writes to internal RAM
;       0080 to 00ff writes to internal RAM - NOT SFR SPACE
;       0100 to ffff writes to external data/code space
;
WRITE_MEM:
;
;  Set page
;;      MOVX    A,@DPTR
;;      MOV     PAGEIMAGE,A
;;      MOV     PAGELATCH,A
        INC     DPTR
;
;  Get address
        MOVX    A,@DPTR                 ;LOW ADDRESS
        MOV     R0,A
        INC     DPTR
        MOVX    A,@DPTR                 ;HIGH ADDRESS
        MOV     R1,A
        INC     DPTR                    ;DPTR POINTS AT DATA TO WRITE
;
;  Get length to write
        MOV     A,R6
        ADD     A,#-3                   ;LESS PAGE, ADDRESS
        JZ      WLP80                   ;EXIT OF NO BYTES REQUESTED (A=0)
        MOV     R6,A                    ;SAVE FOR WRITE LOOP
        MOV     R7,A                    ;AND SAVE COPY FOR COMPARE LOOP
;
;  Write the requested bytes to local memory
WLP:    MOVX    A,@DPTR                 ;GET BYTE TO WRITE
        MOV     R2,DPTRL                ;SAVE SOURCE (COMBUF) POINTER
        MOV     R3,DPTRH
;
;  Fork on memory type
        MOV     DPTRL,R0                ;DESTINATION (MEMORY) POINTER
        MOV     DPTRH,R1
        CJNE    R1,#0,WLP10             ;JIF NOT PAGE ZERO
;
;  Write internal memory (NOT SFR!!!)
;  (If SFRs are desired, use the code shown below for FN_OUT)
        MOV     @R0,A
        SJMP    WLP20
;
;  Write external memory
WLP10:  MOVX    @DPTR,A
;
;  Increment 16 bit destination pointer
WLP20:  INC     DPTR
        MOV     R0,DPTRL                ;SAVE DESTINATION (MEMORY) POINTER
        MOV     R1,DPTRH
;
;  Increment source pointer
        MOV     DPTRL,R2                ;SOURCE (COMBUF) POINTER
        MOV     DPTRH,R3
        INC     DPTR
        DJNZ    R6,WLP                  ;LOOP ON WRITING BYTES
;
;  Compare to see if the write worked
;
;  Get address
        MOV     DPTR,#COMBUF+3
        MOVX    A,@DPTR                 ;LOW ADDRESS
        MOV     R0,A
        INC     DPTR
        MOVX    A,@DPTR                 ;HIGH ADDRESS
        MOV     R1,A
        INC     DPTR                    ;DPTR POINTS AT DATA TO WRITE/COMPARE
;
;  Compare the requested bytes to local memory
WLP50:  MOVX    A,@DPTR                 ;GET BYTE TO WRITE
        MOV     R6,A                    ;SAVE FOR COMPARE BELOW
        MOV     R2,DPTRL                ;SAVE SOURCE (COMBUF) POINTER
        MOV     R3,DPTRH
;
;  Fork on memory type
        MOV     DPTRL,R0                ;DESTINATION (MEMORY) POINTER
        MOV     DPTRH,R1
        CJNE    R1,#0,WLP60             ;JIF NOT PAGE ZERO
;
;  Read internal memory (NOT SFR!!!)
;  (If SFRs are desired, use the code shown below for FN_IN)
        MOV     A,@R0
        SJMP    WLP70
;
;  Read external memory
WLP60:  MOVX    A,@DPTR
;
;  Compare bytes
WLP70:  XRL     A,R6
        JNZ     WLP90                   ;JIF NOT SAME AS WRITTEN VALUE (A != 0)
;
;  Increment 16 bit destination pointer
        INC     DPTR
        MOV     R0,DPTRL                ;SAVE DESTINATION (MEMORY) POINTER
        MOV     R1,DPTRH
;
;  Increment source pointer
        MOV     DPTRL,R2                ;SOURCE (COMBUF) POINTER
        MOV     DPTRH,R3
        INC     DPTR
        DJNZ    R7,WLP50                ;LOOP ON COMPARING BYTES
;
;  Write succeeded:  return status = 0
WLP80:  MOV     A,#0                    ;RETURN STATUS = 0
        SJMP    WLP100
;
;  Write failed:  return status = 1
WLP90:  MOV     A,#1
;
;  Return OK status
WLP100:  AJMP   SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
        MOV     DPTR,#TASK_REGS         ;REGISTER LIVE HERE
        MOV     A,#T_REGS_SIZE          ;NUMBER OF BYTES
        MOV     R6,A
        MOV     R0,DPTRL                ;SAVE SOURCE (REGISTER) POINTER
        MOV     R1,DPTRH
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
        MOV     DPTR,#COMBUF+1          ;POINTER TO LEN, DATA
        MOVX    @DPTR,A                 ;SAVE DATA LENGTH
        INC     DPTR
;
;  Copy the registers
GRLP:   MOV     R2,DPTRL                ;SAVE DESTINATION (COMBUF) POINTER
        MOV     R3,DPTRH
;
        MOV     DPTRL,R0                ;SOURCE (REGISTER) POINTER
        MOV     DPTRH,R1
        MOVX    A,@DPTR                 ;GET BYTE OF REGISTER
        INC     DPTR
        MOV     R0,DPTRL
        MOV     R1,DPTRH
;
        MOV     DPTRL,R2                ;DESTINATION (COMBUF) POINTER
        MOV     DPTRH,R3
        MOVX    @DPTR,A
        INC     DPTR
        DJNZ    R6,GRLP
;
;  Compute checksum on buffer, and send to master, then return
        AJMP    SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
WRITE_REGS:
;
        MOV     A,R6
        JZ      WRR80                   ;JIF NO REGISTERS (A=0)
;
;  A change to the register bank bits of the PSW means to switch banks.
;  To switch,
;  1) Copy R0 to R7 from the message to the "real" R0-R7 (current set)
;     This updates any current registers from the message.
;  2) Change register bank by setting the bank bits in PSW from the
;     message.
;  3) Copy the new registers R0-R7 over R0-R7 in the message.  This
;     allows us to simply fall through to copy the remaining registers.
;  4) Copy the message's registers to TASK_REGS
;  5) Jump to RETURN_REGS to return the new set
;     (NoICE host will accept either a status return or a new set of
;     registers as valid responses to FN_WRITE_REG)
;
;  Check for register bank change
        INC     DPTR                    ;SKIP REG_STATE
        INC     DPTR                    ;SKIP REG_PAGE
        MOVX    A,@DPTR                 ;GET NEW REG_PSW
        ANL     A,#0b00011000           ;ISOLATE REG BANK BITS
        MOV     B,A                     ;SAVE FOR BANK SWITCH LATER
        XRL     A,PSW                   ;SET BITS WHICH DIFFER
        ANL     A,#0b00011000           ;ISOLATE REG BANK BITS
        JZ      WRR50                   ;JIF SAME BANK: JUST COPY REGS
;
;  Save message's R0-R7 as current R0-R7
        MOV     DPTR,#COMBUF+2+(REG_R-TASK_REGS)
        ACALL   RESREG
;
;  Change register banks.  "B" has new bank specifier
;  (Don't use R0-R7 until we switch, as they have unsaved stuff in them)
        ANL     PSW,#0b11100111         ;CLEAR OUT BANK BITS IN PSW
        MOV     A,B                     ;SAVED NEW BITS FROM COMMAND BUFFER
        ORL     PSW,A                   ;CHANGE BANK!
;
;  Store new bank's R0-R7 INTO THE MESSAGE, ignoring supplied R0-7
;  (This allows us to fall through to move the remaining registers)
        MOV     DPTR,#COMBUF+2+(REG_R-TASK_REGS)
        ACALL   SAVEREG
;
;  Copy the registers (including our own R0-R7 if bank changed)
;  Safe to use all registers
WRR50:  MOV     R0,#<TASK_REGS          ;DESTINATION (REGISTER) POINTER
;ARB	MOV     R0,#TASK_REGS & 0xFF    ;DESTINATION (REGISTER) POINTER
        MOV     R1,#>TASK_REGS
;ARB    MOV     R1,#TASK_REGS >> 8
        MOV     DPTR,#COMBUF+1          ;SOURCE (MESSAGE) POINTER
        MOVX    A,@DPTR                 ;LENGTH
        MOV     R6,A
        INC     DPTR                    ;POINT AT REGISTERS TO WRITE
;
;  Copy the registers
WRLP:   MOVX    A,@DPTR                 ;GET BYTE OF REGISTER
        INC     DPTR
        MOV     R2,DPTRL                ;SAVE SOURCE (COMBUF) POINTER
        MOV     R3,DPTRH
;
        MOV     DPTRL,R0                ;DESTINATION (REGISTER) POINTER
        MOV     DPTRH,R1
        MOVX    @DPTR,A
        INC     DPTR
        MOV     R0,DPTRL
        MOV     R1,DPTRH
;
        MOV     DPTRL,R2                ;GET SOURCE (COMBUF) POINTER
        MOV     DPTRH,R3
        DJNZ    R6,WRLP
;
;  Reload stack pointer, in case it has changed
        MOV     DPTR,#REG_SP
        MOVX    A,@DPTR
        MOV     SP,A
;
;  Return the registers, as bank may have changed
WRR80:  AJMP    RETURN_REGS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Uses 5 bytes of user stack
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
RUN_TARGET:
;
;  Restore user's page
;;      MOV     DPTR,#REG_PAGE
;;      MOVX    A,@DPTR
;;      MOV     PAGEIMAGE,A
;;      MOV     PAGELATCH,A
;
;  Switch to user stack, if not already using it
        MOV     DPTR,#REG_SP
        MOVX    A,@DPTR                 ;restore SP
        MOV     SP,A
;
;  Restore registers R0-R7
        MOV     DPTR,#REG_R
        ACALL   RESREG
;
;  Can't use R0-R7 hereafter
;
;  Push user PC for RET (DPTR points at PC after R0-R7)
        MOVX    A,@DPTR                 ;PCL
        PUSH    ACC                     ; 1 byte on stack
        INC     DPTR
        MOVX    A,@DPTR                 ;PCH
        PUSH    ACC                     ; 2 bytes on stack
;
;  Push user's interrupt state to restore before RET
        MOV     DPTR,#REG_IE
        MOVX    A,@DPTR                 ;IE
        PUSH    ACC                     ; 3 bytes on stack
        INC     DPTR
;
;  Push A for restore before RET (A is after IE)
        MOVX    A,@DPTR                 ;A
        PUSH    ACC                     ; 4 bytes on stack
        INC     DPTR
;
;  Restore B (B is after A)
        MOVX    A,@DPTR                 ;B
        MOV     B,A
        INC     DPTR
;
;  Restore PSW
        MOV     DPTR,#REG_PSW
        MOVX    A,@DPTR                 ;PSW
        MOV     PSW,A
;
;  Restore DPTR (DPTR is after PSW)
        INC     DPTR
        MOVX    A,@DPTR                 ;DPTRL
        PUSH    ACC                     ; 5 bytes on stack
        INC     DPTR
        MOVX    A,@DPTR                 ;DPTRH
        MOV     DPTRH,A
        POP     DPTRL                   ; 4 bytes on stack
;
;  Return to user
        POP     ACC                     ; 3 bytes on stack
        POP     IE                      ; 2 bytes on stack
        RET                             ; 0 bytes on stack - back to user
;
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
;  Enter with A=function, R6=length, DPTR points at first data byte
;
;  Uses 2 bytes of stack
;
SET_BYTES:
        MOV     A,R6
        JZ      SB90                    ;JIF NO BYTES (A=0)
        MOV     R2,DPTRL                ;SAVE POINTER TO SOURCE BUFFER
        MOV     R3,DPTRH
;
;  Loop on inserting bytes
SB10:   MOV     R4,DPTRL                ;SAVE POINTER TO RETURN BYTES
        MOV     R5,DPTRH
;
;  Set page
        MOV     DPTRL,R2                ;SOURCE BUFFER POINTER
        MOV     DPTRH,R3
;;      MOVX    A,@DPTR
;;      MOV     PAGEIMAGE,A
;;      MOV     PAGELATCH,A
        INC     DPTR
;
;  Get address
        MOVX    A,@DPTR                 ;LOW ADDRESS
        MOV     R0,A
        INC     DPTR
        MOVX    A,@DPTR                 ;HIGH ADDRESS
        MOV     R1,A
        INC     DPTR
;
;  Get byte to store
        MOVX    A,@DPTR
        MOV     R7,A
        INC     DPTR
        MOV     R2,DPTRL                ;SAVE POINTER TO SOURCE BUFFER
        MOV     R3,DPTRH
;
;  Read current data at byte location
        MOV     DPTRL,R0
        MOV     DPTRH,R1
        MOVX    A,@DPTR                 ;READ CURRENT DATA
        MOV     R0,A                    ;SAVE RETURN DATA
;
;  Insert new data at byte location
        MOV     A,R7
        MOVX    @DPTR,A                 ;WRITE BYTE
        MOVX    A,@DPTR                 ;READ IT BACK
        MOV     DPTRL,R4                ;(POINTER TO RETURN BUFFER)
        MOV     DPTRH,R5
        XRL     A,R7
        JNZ     SB90                    ;JIF INSERT FAILED: ABORT (A != 0)
;
;  Save byte read in return buffer
        MOV     A,R0
        MOVX    @DPTR,A
        INC     DPTR
;
        DEC     R6
        DEC     R6
        DEC     R6
        DJNZ    R6,SB10                 ;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
;  DPTR points at next free byte in return buffer.  Compute length
;  (Since buffer is less than 256 bytes, modulo arithmetic means that
;  we need only subtract the LS bytes)
SB90:   MOV     A,DPTRL                 ;FIRST FREE...
	CLR	C
	SUBB	A,#<(COMBUF+2)
;ARB    ADD     A,#-(COMBUF+2) & 0xFF   ;MINUS FIRST USED (IF ANY)
        MOV     DPTR,#COMBUF+1
        MOVX    @DPTR,A                 ;SET COUNT OF RETURN BYTES
;
;  Compute checksum on buffer, and send to master, then return
        AJMP    SEND

;===========================================================================
;
;  8051 op-code equates for code building
;  (indirect addressing cannot be used on SFRs)
        .equ    MOVADIR, 0xE5
        .equ    MOVDIRA, 0xF5
        .equ    RETURN,  0x22
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
IN_PORT:
;
;  Get port address
        MOVX    A,@DPTR                 ;ADDRESS
        MOV     R0,A                    ;SAVE IT
        MOV     A,#MOVADIR              ;OP-CODE FOR "MOV A,DIRECT"
        MOVX    @DPTR,A                 ;USE COMBUF+2 AS SCRATCH BUFFER
        INC     DPTR
        MOV     A,R0
        MOVX    @DPTR,A                 ;DIRECT ADDRESS FOR MOV...
        INC     DPTR
        MOV     A,#RETURN               ;OP-CODE FOR "RET"
        MOVX    @DPTR,A
;
;  Read port value
;  CAUTION:  works only if external data space and external code space
;  are the same!
        LCALL   COMBUF+2                ;CALL THE ROUTINE WE MADE
;
;  Return byte read as "status"
        AJMP    SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
;  Enter with A=function, R6=length, DPTR points at first data byte
;
OUT_PORT:
;
;  Get port address:  8 bits only, ignoring high 8 bits sent by host
        MOVX    A,@DPTR                 ;ADDRESS
        MOV     R0,A                    ;SAVE IT
        INC     DPTR
        INC     DPTR                    ;SKIP HIGH BYTE OF ADDRESS
;
        MOVX    A,@DPTR                 ;BYTE TO WRITE
        MOV     R1,A                    ;SAVE IT
;
        MOV     A,#MOVDIRA              ;OP-CODE FOR "MOV DIRECT,A"
        MOVX    @DPTR,A                 ;USE COMBUF+4 AS SCRATCH BUFFER
        INC     DPTR
        MOV     A,R0
        MOVX    @DPTR,A                 ;DIRECT ADDRESS FOR MOV...
        INC     DPTR
        MOV     A,#RETURN               ;OP-CODE FOR "RET"
        MOVX    @DPTR,A
;
;  Write port value
;  CAUTION:  works only if external data space and external code space
;  are the same!
        MOV     A,R1
        LCALL   COMBUF+4                ;CALL THE ROUTINE WE MADE
;
;  Return status of OK
        MOV     A,#0
        AJMP    SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
        MOV     R0,A                    ;SAVE STATUS
        MOV     DPTR,#COMBUF+1
        MOV     A,#1
        MOVX    @DPTR,A                 ;SET LENGTH
        INC     DPTR
        MOV     A,R0
        MOVX    @DPTR,A                 ;SET STATUS
        SJMP    SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:   ACALL   CHECKSUM                ;GET A=CHECKSUM, DPTR->checksum location
        XRL     A,#0xFF
        INC     A
        MOVX    @DPTR,A                 ;STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
        MOV     DPTR,#COMBUF+1          ;POINTER TO LENGTH
        MOVX    A,@DPTR
        ADD     A,#3                    ;PLUS FUNCTION, LENGTH, CHECKSUM
        MOV     R6,A                    ;LOOP COUNTER
        MOV     DPTR,#COMBUF            ;POINTER TO OUTPUT BUFFER
SND10:  MOVX    A,@DPTR
        ACALL   PUTCHAR                 ;SEND A BYTE (uses 6 bytes of stack)
        INC     DPTR
        DJNZ    R6,SND10
        AJMP    MAIN                    ;BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.  COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;       A = checksum
;       DPTR = pointer to next byte in buffer (checksum location)
;       R6, R7 are scratched
;
;  Uses 2 bytes of stack including return address
;
CHECKSUM:
        MOV     DPTR,#COMBUF+1          ;POINTER TO LENGTH
        MOVX    A,@DPTR
        ADD     A,#2                    ;PLUS FUNCTION, LENGTH
        MOV     R6,A                    ;LOOP COUNTER
        MOV     DPTR,#COMBUF            ;POINTER TO OUTPUT BUFFER
        MOV     R7,#0                   ;INIT CHECKSUM TO ZERO
CHK10:  MOVX    A,@DPTR
        ADD     A,R7
        MOV     R7,A
        INC     DPTR
        DJNZ    R6,CHK10                ;loop for all
        RET                             ;return with checksum in A
;
;  Store registers R0 TO R7 to DPTR++
SAVEREG:
        MOV     A,R0
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R1
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R2
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R3
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R4
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R5
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R6
        MOVX    @DPTR,A
        INC     DPTR
        MOV     A,R7
        MOVX    @DPTR,A
        INC     DPTR
        RET
;
;  Load registerss R0 to R7 from @DPTR++
RESREG: MOVX    A,@DPTR                 ;restore R0
        MOV     R0,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R1
        MOV     R1,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R2
        MOV     R2,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R3
        MOV     R3,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R4
        MOV     R4,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R5
        MOV     R5,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R6
        MOV     R6,A
        INC     DPTR
        MOVX    A,@DPTR                 ;restore R7
        MOV     R7,A
        INC     DPTR
        RET

        .end    RESET
