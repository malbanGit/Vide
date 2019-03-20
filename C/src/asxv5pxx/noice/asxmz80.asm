;  ASXMZ80.ASM - Z80 Debug monitor for use with NoICEZ80
;  This file may be assembled with the ASxxxx Z80 assembler ASZ80.
;
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;    14-Jun-93 JLH release version
;    24-Aug-93 JLH bad constant for COMBUF length compare
;     8-Nov-93 JLH change to use RST 8 for breakpoint, not RST 38 (v1.3)
;    20-Dec-93 JLH bug in NMI dummy vectors: overwrote NMI and reset!
;    17-Oct-95 JLH eliminate two-arg for SUB, AND, OR, XOR, and CP
;    21-Jul-00 JLH change FN_MIN from F7 to F0
;    12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;    28-May-01 ARB Modified for the ASxxxx ASZ80 assembler
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
;  This file contains conditional assemblies for several options:
;  1) Z180 and peripherals.  (Z180 equ 1)
;     This will run unmodified on the Zilog Z8018000ZC0 Z180/SCC
;     evaluation board using SCC-B for host communications
;  2) Z84C15 and peripherals.  (Z84C15 equ 1)
;     This will run unmodified on the Zilog Z84C1500ZC0 Z84C15
;     evaluation board using SIO-B for host communications
;  3) an alternate memory-mapped 16450 UART (ROMEM equ 1)
;
;  This file has been assembled with the ASM800 assembler which Zilog
;  includes with the evaluation boards mentioned above.
;
;  I/O EQUATES for Z80, Z180, or Z84C15 (set at most one true)
Z80	=	0
Z180	=	1
Z84C15	=	0
;
;  I/O equates for Heng's ROM emulator (if used)
ROMEM	=	0
;
;  If your taget differs from these options, you may need to make other
;  modifications to this file to reflect your processor and hardware.
;
;============================================================================
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
ROM_START	=	0x0000		;START OF MONITOR CODE
RAM_START	=	0xFC00		;START OF MONITOR RAM
USER_CODE	=	0x8000		;START OF USER'S INTS/CODE
;
;==========================================================================
;  Equates for memory mapped 16450 serial port on Heng's ROM emulator board
  .if ROMEM

S16450	=	0x800		;base of 16450 UART
RXR	=	0		;  Receiver buffer register
TXR	=	0		;  Transmitter buffer register
IER	=	1		;  Interrupt enable register
LCR	=	3		;  Line control register
MCR	=	4		;  Modem control register
LSR	=	5		;  Line status register
;
;  Define monitor serial port
SERIAL_STATUS	=	S16450+LSR
SERIAL_DATA	=	S16450+RXR
RXRDY		=	0	; BIT NUMBER (NOT MASK) FOR RX BUFFER FULL
TXRDY		=	5	; BIT NUMBER (NOT MASK) FOR TX BUFFER EMPTY

  .endif
;
;==========================================================================
;  Equates for Z84C15 peripherals
;
  .if Z84C15
  .z180
;  SPCT STANDS FOR SERIAL, PARALLEL, COUNTER/TIMER
SPCT	=	0x00		;SPCT BASE ADDR.
CTC_0	=	SPCT+0x10	;ADDR. OF COUNTER TIMER CHAN. 0
CTC_1	=	SPCT+0x11	;ADDR. OF COUNTER TIMER CHAN. 1
CTC_2	=	SPCT+0x12	;ADDR. OF COUNTER TIMER CHAN. 2
CTC_3	=	SPCT+0x13	;ADDR. OF COUNTER TIMER CHAN. 3
SIO_AD	=	SPCT+0x18	;SERIAL I/O CHANNEL A  DATA ADDR.
SIO_AC	=	SPCT+0x19	;SERIAL I/0 CHANNEL A  COMMAND ADDR.
SIO_BD	=	SPCT+0x1A	;SERIAL I/O CHANNEL B  DATA ADDR.
SIO_BC	=	SPCT+0x1B	;SERIAL I/0 CHANNEL B  COMMAND ADDR.

; DEFINITIONS NECESSARY TO MANIPULATE THE FOUR INDIRECTLY ACCESSABLE SYSTEM
; CONFIGURATION REGISTERS IN THE Z84C15
SCRP_REG	=	0xEE	;SYSTEM CONTROL REG. POINTER
SCDP_REG	=	0xEF	;SYSTEM CONTROL DATA POINTER

; THE WATCH DOG TIMER IS NOT USED.  WTMR BITS 4 & 3 ARE USED TO
; SET IDLE, STOP OR RUN MODE.
WDTMR	=	0xF0	;WATCH DOG TIMER MASTER REG. ADDR.
WDTCR	=	0xF1	;WATCH DOG TIMER CONTROL REG. ADDR.
;
	.if ROMEM
	.else
;  Define monitor serial port using SIO
SERIAL_STATUS	=	SIO_BC
SERIAL_DATA	=	SIO_BD
RXRDY		=	0	; BIT NUMBER FOR RECEIVE BUFFER FULL
TXRDY		=	2	; BIT NUMBER FOR TRANSMIT BUFFER EMPTY
	.endif
  .endif

;==========================================================================
;  Equates for Z180 peripherals
;
  .if Z180
  .z180
;  SCC Registers
scc_com		=	1	;set true to use scc for comm
scc_ad		=	0xc3	;addr of scc ch a - data
scc_ac		=	0xc2	;addr of scc ch a - cont
scc_bd		=	0xc1	;addr of scc ch b - data
scc_bc		=	0xc0	;addr of scc ch b - cont
;
;  Other Control Registers
dcntl		=	0x32	;DMA/WAIT Control Register
itc		=	0x34	;INT/TRAP Control Register
rcr		=	0x35	;Refresh Control Register
omcr		=	0x00	;?

	.if ROMEM
	.else
;  Define monitor serial port using SCC
SERIAL_STATUS	=	scc_bc
SERIAL_DATA	=	scc_bd
RXRDY		=	0	; BIT NUMBER FOR RECEIVE BUFFER FULL
TXRDY		=	2	; BIT NUMBER FOR TRANSMIT BUFFER EMPTY
	.endif
  .endif
;
;============================================================================
;  RAM definitions:  top 1K
	.AREA	DATA
	.ORG	RAM_START		; Monitor RAM
;
;  Initial user stack
;  (Size and location is user option)
	.DS	64
INITSTACK:
;
;  Monitor stack
;  (Calculated use is at most 6 bytes.  Leave plenty of spare)
	.DS	16
MONSTACK:
;
;  Target registers:  order must match that in TRGZ80.C
TASK_REGS:
 REG_STATE:	.DS	1
 REG_PAGE:	.DS	1
 REG_SP:	.DS	2
 REG_IX:	.DS	2
 REG_IY:	.DS	2
 REG_HL:	.DS	2
 REG_BC:	.DS	2
 REG_DE:	.DS	2
 REG_AF:			;LABEL ON FLAGS, A AS A WORD
 REG_FLAGS:	.DS	1
 REG_A:		.DS	1
 REG_PC:	.DS	2
 REG_I:		.DS	1
 REG_IFF:	.DS	1
 ;
 REG_HLX:	.DS	2	;ALTERNATE REGISTER SET
 REG_BCX:	.DS	2
 REG_DEX:	.DS	2
 REG_AFX:			;LABEL ON FLAGS, A AS A WORD
 REG_FLAGSX:	.DS	1
 REG_AX:	.DS	1
TASK_REGS_SIZE	=	.-TASK_REGS
; !!! Caution:  don't put parenthesis around the above in ASM180:
; !!! The parenthesis in (.-TASK_REGS) are "remembered", such that
; !!! LD BC,TASK_REGS_SIZE is the same as LD BC,(TASK_REGS_SIZE)
; !!! It is OK to use parenthesis around the difference if the difference
; !!! is to be divided - just not around the entire expression!!!!!
;
;  Communications buffer
;  (Must be at least as long as TASK_REG_SIZE.  Larger values may improve
;  speed of NoICE memory load and dump commands)
COMBUF_SIZE	=	67		;DATA SIZE FOR COMM BUFFER
COMBUF:		.DS	2+COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND CHECK
;
RAM_END		=	.		;ADDRESS OF TOP+1 OF RAM
;
;===========================================================================
;  8080 mode Interrupt vectors
;
;  Reset, RST 0,  or trap vector
	.AREA	CODE
	.ORG	ROM_START
R0:	DI
	JP	RESET
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 08.  Used for breakpoint.  Any other RST
;  may be used instead by changing the code below and the value of the
;  breakpoint instruction in the status string TSTG.  If RST NN cannot
;  be used, then CALL may be used instead.  However, this will restrict
;  the placement of breakpoints, since CALL is a three byte instruciton.
	PUSH	AF
	LD	A,1			;STATE = 1 (BREAKPOINT)
	JP	INT_ENTRY
	NOP
	NOP
;
;  Interrupt RST 10
	JP	USER_CODE + 0x10
	NOP
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 18
	JP	USER_CODE + 0x18
	NOP
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 20
	JP	USER_CODE + 0x20
	NOP
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 28
	JP	USER_CODE + 0x28
	NOP
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 30
	JP	USER_CODE + 0x30
	NOP
	NOP
	NOP
	NOP
	NOP
;
;  Interrupt RST 38
	JP	USER_CODE + 0x38
	NOP
	NOP
	NOP
	NOP
	NOP
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
	.AREA	CODE
	.ORG	ROM_START+0x66
NMI_ENTRY:
	PUSH	AF
	LD	A,2
	JP	INT_ENTRY
;
;  Or, if user wants control of NMI:
;;	JP	USER_CODE + 0x66	;JUMP THRU VECTOR IN RAM
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
	PUSH	AF
	LD	A,0			;STATE = 0 (INTERRUPT 0)
	JP	INT_ENTRY
	NOP
	NOP
;
;  (vectored only if not used for breakpoint)
;  RST 8
	PUSH	AF
	LD	A,3			;STATE = 3 (INTERRUPT 8)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 10H
	PUSH	AF
	LD	A,4			;STATE = 4 (INTERRUPT 10)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 18H
	PUSH	AF
	LD	A,5			;STATE = 5 (INTERRUPT 18)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 20H
	PUSH	AF
	LD	A,6			;STATE = 6 (INTERRUPT 20)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 28H
	PUSH	AF
	LD	A,7			;STATE = 7 (INTERRUPT 28)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 30H
	PUSH	AF
	LD	A,8			;STATE = 8 (INTERRUPT 30)
	JP	INT_ENTRY
	NOP
	NOP
;
;  RST 38H
	PUSH	AF
	LD	A,9			;STATE = 9 (INTERRUPT 38)
	JP	INT_ENTRY
;
;  Use this if NMI is to be vectored through RAM.  Else comment it out
;  to have NMI pass directy to monitor to break into running programs.
;;;	.ORG	DUMMY_INTS+66H
;;;	PUSH	AF
;;;	LD	A,2
;;;	JP	INT_ENTRY
;
DUMMY_SIZE	=	.-DUMMY_INTS
;
;===========================================================================
;  Power on reset or trap
RESET:
;
;----------------------------------------------------------------------------
  .if Z180
;  See if this is an illegal op-code trap or a reset
	PUSH	AF		;SAVE A AND FLAGS (HOPE FOR A STACK...)
	in0	a,(itc)		;CHECK TRAP STATUS (FLAGS DESTROYED!!)
	BIT	7,A		;IF THIS BIT IS ONE, THERE WAS TRAP!
	JR	Z,INIT		;JIF RESET
;
;  Illegal instruction trap:
;  Back up the stacked PC by either 1 or 2 bytes, depending on the state
;  of the UFO bit in the itc
	LD	(REG_HL),HL
	POP	HL		;GET STACKED AF
	LD	(REG_AF),HL	;SAVE AF
	POP	HL		;GET STACKED PC
	DEC	HL		;BACK UP ONE BYTE
	BIT	6,A
	JR	Z,TR20		;JIF 1 BYTE OP-CODE
	DEC	HL		;ELSE BACK UP SECOND OP-CODE BYTE
;
;  Reset the trap bit
TR20:	AND	0x7F		;CLEAR THE TRAP BIT
	out0	(itc),a
;
;  Get IFF2
;  It is not clear that we can determine the pre-trap state of the
;  interrupt enable:  the databook says nothing about IFF2 vis a vis
;  trap.  We presume that interrupts are disabled by the trap.
;  However, we proceed as if IFF2 contained the pre-trap state
	LD	A,I		;GET P FLAG = IFF2 (SIDE EFFECT)
	DI			;BE SURE INTS ARE DISABLED
	LD	(REG_I),A	;SAVE INT REG
	LD	A,0
	JP	PO,TR30		;JIF PARITY ODD (FLAG=0)
	INC	A		;ELSE SET A = FLAG = 1 (ENABLED)
TR30:	LD	(REG_IFF),A	;SAVE INTERRUPT FLAG
;
;  save registers in reg block for return to master
	LD	A,10
	LD	(REG_STATE),A	;SET STATE TO "TRAP"
	JP	ENTER_MON	;HL = OFFENDING PC
  .endif
;----------------------------------------------------------------------------
  .if Z84C15
	;  We have 16 instructions after reset in which to set the wait state
	;  control register.  Do it here, rather than via table, in order to
	;  be sure it gets done in time
	;  With 19.6608 Mhz crystal, memory must be 100nsec for 0 wait.
	DI			;NO INTERRUPTS
	XOR	A		;ACCESS TO WAIT STATE CONTROL REG.
	LD	BC,SCRP_REG
	OUT	(C),A		;SET POINTER TO WAIT CONT (A15-A8 = 0)
	LD	A,0b00011100
	;	    00		;NO WAIT FOR INTERRUPT ACK
	;	      0		;NO WAIT FOR INTERRUPT VECTOR
	;	       1	;ONE EXTRA WAIT FOR OPCODE FETCH
	;		11	;THREE WAITS FOR MEMORY
	;		  00	;NO WAIT FOR I/O
	LD	BC,SCDP_REG
	OUT	(C),A		;SYSTEM CONTROL DATA PORT (A15-A8 = 0)
  .endif
;
;-------------------------------------------------------------------------
;  Initialize monitor
INIT:	LD	SP,MONSTACK
;
;  Initialize target hardware
	LD	HL,INIOUT	;PUT ADRESS OF INITIALIZATION DATA TABLE INTO HL
	LD	D,OUTCNT	;PUT NUMBER OF DATA AND ADDR. PAIRS INTO REG. B
;
;  Caution:  OUT and OUTI place the 8 bit address from C on A7-A0, but
;  the contents of the B register on A15-A7.  The Z180's on-chip peripherals
;  decode 16 bits of I/O address, for reasons known only to ZIlog.
;  Thus, either be sure B=0 or use the Z180 OTIM
;  We do the former, so as to operate the same code on Z84C15 or Z80
	LD	B,0		;so a15-a8 will be 0
RST10:  LD	C,(HL)		;load address from table
	INC	HL
	LD	A,(HL)		;load data from table
	INC	HL
	OUT	(C),A		;output a to i/o address (A15-A8 = 0)
	DEC	D
	JR	NZ,RST10	;loop for d (address, data) pairs
;
;===========================================================================
;  Perform user hardware initilaization here

;===========================================================================
  .if ROMEM
;
;  Initialize memory-mapped S16450 UART on ROM emulator
;  To use with an I/O mapped 8250 or 16450, replace LD (),A by OUT (),A
;
;  access baud generator, no parity, 1 stop bit, 8 data bits
	LD	A,10000011B
	LD	(S16450+LCR),A
;
;  fixed baud rate of 19200:  crystal is 3.686400 Mhz.
;  Divisor is 3,686400/(16*baud)
	LD	A,12			;fix at 19.2 kbaud
	LD	(S16450+RXR),A		;lsb
	XOR	A
	LD	(S16450+RXR+1),A	;msb=0
;
;  access data registers, no parity, 1 stop bits, 8 data bits
	LD	A,00000011B
	LD	(S16450+LCR),A
;
;  no loopback, OUT2 on, OUT1 on, RTS on, DTR (LED) on
	LD	A,00001111B
	LD	(S16450+MCR),A
;
;  disable all interrupts: modem, receive error, transmit, and receive
	LD	A,00000000B
	LD	(S16450+IER),A
  .endif
;===========================================================================
;  Initialize user interrupt vectors to point to monitor
	LD	HL,DUMMY_INTS		;dummy handler code
	LD	DE,USER_CODE		;start of user codespace
	LD	BC,DUMMY_SIZE		;number of bytes
	LDIR				;copy code

;===========================================================================
;
;  Initialize user registers
	LD	HL,INITSTACK
	LD	(REG_SP),HL		;INIT USER'S STACK POINTER
	LD	HL,0
	LD	A,L
	LD	(REG_PC),HL		;INIT ALL REGS TO 0
	LD	(REG_HL),HL
	LD	(REG_BC),HL
	LD	(REG_DE),HL
	LD	(REG_IX),HL
	LD	(REG_IY),HL
	LD	(REG_AF),HL
	LD	(REG_HLX),HL
	LD	(REG_BCX),HL
	LD	(REG_DEX),HL
	LD	(REG_AFX),HL
	LD	(REG_I),A
	LD	(REG_STATE),A		;set state as "RESET"
	LD	(REG_IFF),A		;NO INTERRUPTS
;
;  Initialize memory paging variables and hardware (if any)
	LD	(REG_PAGE),A		;page 0
;;;	LD	(PAGEIMAGE),A
;;;	OUT	(PAGELATCH),A		;set hardware page
;
;  Set function code for "GO".  Then if we reset after being told to
;  GO, we will come back with registers so user can see the crash
	LD	A,FN_RUN_TARGET
	LD	(COMBUF),A
	JP	RETURN_REGS		;DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;		CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
	PUSH	BC
	PUSH	DE

	.if ROMEM
	;make the LED flash
	LD	A,(S16450+MCR)		;read modem control reg
	XOR	0x01			;flip state of DTR (LED)
	LD	(S16450+MCR),A		;output to port
	.endif

	LD	DE,0x8000		;long timeout
	LD	BC,SERIAL_STATUS	;status reg. for loop
GC10:	DEC	DE
	LD	A,D
	OR	E
	JR	Z,GC90			;exit if timeout

	.if Z84C15
	;Reset the watchdog timer (if someone enables it)
	LD	A,0x4E			;code to clear watch dog timer
	LD	BC,WDTCR
	OUT	(C),A			;watch dog timer command reg.
	LD	BC,SERIAL_STATUS
	.endif

	.if ROMEM
	LD	A,(BC)			;read device status (memory mapped)
	.else
	IN	A,(C)			;read device status
	.endif

	BIT	RXRDY,A
	JR	Z,GC10			;not ready yet.
;
;  Data received:  return CY=0. data in A
	XOR	A			;CY=0
	LD	BC,SERIAL_DATA

	.if ROMEM
	LD	A,(BC)			;read data (memory mapped)
	.else
	IN	A,(C)			;read data
	.endif

	POP	DE
	POP	BC
	RET
;
;  Timeout:  return CY=1
GC90:	SCF				;cy=1
	POP	DE
	POP	BC
	RET
;
;===========================================================================
;  Output character in A
;
;  Uses 6 bytes of stack including return address
;
PUTCHAR:
	PUSH	BC			;save:  used for I/O address
	PUSH	AF			;save byte to output
	LD	BC,SERIAL_STATUS	;status reg. for loop
PC10:
	.if Z84C15
	;Reset the watchdog timer (if someone enables it)
	LD	A,0x4E			;code to clear watch dog timer
	LD	BC,WDTCR
	OUT	(C),A			;watch dog timer command reg.
	LD	BC,SERIAL_STATUS
	.endif

	.if ROMEM
	LD	A,(BC)			;read device status (memory mapped)
	.else
	IN	A,(C)			;read device status
	.endif

	BIT	TXRDY,A			;RX READY ?
	JR	Z,PC10

	POP	AF
	LD	BC,SERIAL_DATA

	.if ROMEM
	LD	(BC),A			;transmit char (memory mapped)
	.else
	OUT	(C),A			;transmit char
	.endif

	POP	BC
	RET
;
;===========================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:	.DB	0			;2: PROCESSOR TYPE = Z80
	.DB	COMBUF_SIZE		;3: SIZE OF COMMUNICATIONS BUFFER
	.DB	0			;4: NO OPTIONS
	.DW	0			;5,6: BOTTOM OF PAGED MEM (none)
	.DW	0			;7,8: TOP OF PAGED MEM (none)
	.DB	B1-B0			;9 BREAKPOINT INSTRUCTION LENGTH
B0:	RST	0x08			;10+ BREAKPOINT INSTRUCTION
B1:
  .if Z80
	.asciz	'NoICE Z80 monitor V3.0'		;DESCRIPTION, ZERO
  .endif

  .if Z180
	.asciz	'Z180 Evaluation board monitor V3.0'	;DESCRIPTION, ZERO
  .endif

  .if Z84C15
	.asciz	'Z84C15 Evaluation board monitor V3.0'	;DESCRIPTION, ZERO
  .endif
TSTG_SIZE	=	.-TSTG		;SIZE OF STRING
;
;===========================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STATUS	=	0xFF	;reply with device info
FN_READ_MEM	=	0xFE	;reply with data
FN_WRITE_MEM	=	0xFD	;reply with status (+/-)
FN_READ_REGS	=	0xFC	;reply with registers
FN_WRITE_REGS	=	0xFB	;reply with status
FN_RUN_TARGET	=	0xFA	;reply (delayed) with registers
FN_SET_BYTES	=	0xF9	;reply with data (truncate if error)
FN_IN		=	0xF8	;input from port
FN_OUT		=	0xF7	;output to port
;
FN_MIN		=	0xF0	;MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR	=	0xF0	;error reply to unknown op-code
;
;===========================================================================
;  Enter here via RST nn for breakpoint:  AF, PC are stacked.
;  Enter with A=interrupt code = processor state
;  Interrupt status is not changed from user program and IFF2==IFF1
INT_ENTRY:
;
;  Interrupts may be on:  get IFF as quickly as possible, so we can DI
	LD	(REG_STATE),A	;save entry state
	LD	(REG_HL),HL	;SAVE HL
	LD	A,I		;GET P FLAG = IFF2 (SIDE EFFECT)
	DI			;NO INTERRUPTS ALLOWED
;
	LD	(REG_I),A	;SAVE INT REG
	LD	A,0
	JP	PO,BREAK10	;JIF PARITY ODD (FLAG=0)
	INC	A		;ELSE SET A = FLAG = 1 (ENABLED)
BREAK10: LD	(REG_IFF),A	;SAVE INTERRUPT FLAG
;
;  Save registers in reg block for return to master
	POP	HL		;GET FLAGS IN L, ACCUM IN H
	LD	(REG_AF),HL	;SAVE A AND FLAGS
;
;  If entry here was by breakpoint (state=1), then back up the program
;  counter to point at the breakpoint/RST instruction.  Else leave PC alone.
;  (If CALL is used for breakpoint, then back up by 3 bytes)
	POP	HL		;GET PC OF BREAKPOINT/INTERRUPT
	LD	A,(REG_STATE)
	CP	1
	JR	NZ,NOTBP	;JIF NOT A BREAKPOINT
	DEC	HL		;BACK UP PC TO POINT AT BREAKPOINT
NOTBP:  JP	ENTER_MON	;HL POINTS AT BREAKPOINT OPCODE
;
;===========================================================================
;  Main loop:  wait for command frame from master
MAIN:	LD	SP,MONSTACK		;CLEAN STACK IS HAPPY STACK
	LD	HL,COMBUF		;BUILD MESSAGE HERE
;
;  First byte is a function code
	CALL	GETCHAR			;GET A FUNCTION (uses 6 bytes of stack)
	JR	C,MAIN			;JIF TIMEOUT: RESYNC
	CP	FN_MIN
	JR	C,MAIN			;JIF BELOW MIN: ILLEGAL FUNCTION
	LD	(HL),A			;SAVE FUNCTION CODE
	INC	HL
;
;  Second byte is data byte count (may be zero)
	CALL	GETCHAR			;GET A LENGTH BYTE
	JR	C,MAIN			;JIF TIMEOUT: RESYNC
	CP	COMBUF_SIZE+1
	JR	NC,MAIN			;JIF TOO LONG: ILLEGAL LENGTH
	LD	(HL),A			;SAVE LENGTH
	INC	HL
	OR	A
	JR	Z,MA80			;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
	LD	B,A			;SAVE LENGTH FOR LOOP
MA10:	CALL	GETCHAR			;GET A DATA BYTE
	JR	C,MAIN			;JIF TIMEOUT: RESYNC
	LD	(HL),A			;SAVE DATA BYTE
	INC	HL
	DJNZ	MA10
;
;  Get the checksum
MA80:	CALL	GETCHAR			;GET THE CHECKSUM
	JR	C,MAIN			;JIF TIMEOUT: RESYNC
	LD	C,A			;SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
	CALL	CHECKSUM
	ADD	A,C
	JR	NZ,MAIN			;JIF BAD CHECKSUM
;
;  Process the message.
	LD	A,(COMBUF+0)		;GET THE FUNCTION CODE
	CP	FN_GET_STATUS
	JP	Z,TARGET_STATUS
	CP	FN_READ_MEM
	JP	Z,READ_MEM
	CP	FN_WRITE_MEM
	JP	Z,WRITE_MEM
	CP	FN_READ_REGS
	JP	Z,READ_REGS
	CP	FN_WRITE_REGS
	JP	Z,WRITE_REGS
	CP	FN_RUN_TARGET
	JP	Z,RUN_TARGET
	CP	FN_SET_BYTES
	JP	Z,SET_BYTES
	CP	FN_IN
	JP	Z,IN_PORT
	CP	FN_OUT
	JP	Z,OUT_PORT
;
;  Error: unknown function.  Complain
	LD	A,FN_ERROR
	LD	(COMBUF+0),A	;SET FUNCTION AS "ERROR"
	LD	A,1
	JP	SEND_STATUS	;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
TARGET_STATUS:
;
	LD	HL,TSTG			;DATA FOR REPLY
	LD	DE,COMBUF+1		;RETURN BUFFER
	LD	BC,TSTG_SIZE		;LENGTH OF REPLY
	LD	A,C
	LD	(DE),A			;SET SIZE IN REPLY BUFFER
	INC	DE
	LDIR				;MOVE REPLY DATA TO BUFFER
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
READ_MEM:
;
;  Set page
;;	LD	A,(COMBUF+2)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
;  Get address
	LD	HL,(COMBUF+3)
	LD	A,(COMBUF+5)		;NUMBER OF BYTES TO GET
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LD	DE,COMBUF+1		;POINTER TO LEN, DATA
	LD	(DE),A			;RETURN LENGTH = REQUESTED DATA
	INC	DE
	OR	A
	JR	Z,GLP90			;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
	LD	B,A
GLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO RETURN BUFFER
	INC	HL
	INC	DE
	DJNZ	GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:	JP	SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Uses 2 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;	LD	A,(COMBUF+2)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
	LD	HL,COMBUF+5		;POINTER TO SOURCE DATA IN MESSAGE
	LD	DE,(COMBUF+3)		;POINTER TO DESTINATION
	LD	A,(COMBUF+1)		;NUMBER OF BYTES IN MESSAGE
	SUB	3			;LESS PAGE, ADDRLO, ADDRHI
	JR	Z,WLP50			;EXIT IF NONE REQUESTED
;
;  Write the specified bytes to local memory
	LD	B,A
	PUSH	BC			;SAVE BYTE COUNTER
WLP10:	LD	A,(HL)			;BYTE FROM HOST
	LD	(DE),A			;WRITE TO TARGET RAM
	INC	HL
	INC	DE
	DJNZ	WLP10
;
;  Compare to see if the write worked
	LD	HL,COMBUF+5		;POINTER TO SOURCE DATA IN MESSAGE
	LD	DE,(COMBUF+3)		;POINTER TO DESTINATION
	POP	BC			;SIZE AGAIN
;
;  Compare the specified bytes to local memory
WLP20:	LD	A,(DE)			;READ BACK WHAT WE WROTE
	CP	(HL)			;COMPARE TO HOST DATA
	JR	NZ,WLP80		;JIF WRITE FAILED
	INC	HL
	INC	DE
	DJNZ	WLP20
;
;  Write succeeded:  return status = 0
WLP50:	XOR	A			;RETURN STATUS = 0
	JR	WLP90
;
;  Write failed:  return status = 1
WLP80:	LD	A,1
;
;  Return OK status
WLP90:	JP	SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
READ_REGS:
;
;  Enter here from int after "RUN" and "STEP" to return task registers
RETURN_REGS:
	LD	HL,TASK_REGS		;REGISTER LIVE HERE
	LD	A,TASK_REGS_SIZE	;NUMBER OF BYTES
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LD	DE,COMBUF+1		;POINTER TO LEN, DATA
	LD	(DE),A			;SAVE DATA LENGTH
	INC	DE
;
;  Copy the registers
	LD	B,A
GRLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO RETURN BUFFER
	INC	HL
	INC	DE
	DJNZ	GRLP
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
WRITE_REGS:
;
	LD	HL,COMBUF+2		;POINTER TO DATA
	LD	A,(COMBUF+1)		;NUMBER OF BYTES
	OR	A
	JR	Z,WRR80			;JIF NO REGISTERS
;
;  Copy the registers
	LD	DE,TASK_REGS		;OUR REGISTERS LIVE HERE
	LD	B,A
WRRLP:	LD	A,(HL)			;GET BYTE TO A
	LD	(DE),A			;STORE TO REGISTER RAM
	INC	HL
	INC	DE
	DJNZ	WRRLP
;
;  Return OK status
WRR80:	XOR	A
	JP	SEND_STATUS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Uses 4 bytes of stack
;
RUN_TARGET:
;
;  Restore user's page
;;	LD	A,(REG_PAGE)
;;	LD	(PAGEIMAGE),A
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A
;
;  Restore alternate registers
	LD	HL,(REG_AFX)
	PUSH	HL
	POP	AF
	EX	AF,AF'			;LOAD ALTERNATE AF
	;
	LD	HL,(REG_HLX)
	LD	BC,(REG_BCX)
	LD	DE,(REG_DEX)
	EXX				;LOAD ALTERNATE REGS
;
;  Restore main registers
	LD	BC,(REG_BC)
	LD	DE,(REG_DE)
	LD	IX,(REG_IX)
	LD	IY,(REG_IY)
	LD	A,(REG_I)
	LD	I,A
;
;  Switch to user stack
	LD	HL,(REG_PC)		;USER PC
	LD	SP,(REG_SP)		;BACK TO USER STACK
	PUSH	HL			;SAVE USER PC FOR RET
	LD	HL,(REG_AF)
	PUSH	HL			;SAVE USER A AND FLAGS FOR POP
	LD	HL,(REG_HL)		;USER HL
;
;  Restore user's interrupt state
	LD	A,(REG_IFF)
	OR	A
	JR	Z,RUTT10		;JIF INTS OFF: LEAVE OFF
;
;  Return to user with interrupts enabled
	POP	AF
	EI				;ELSE ENABLE THEM NOW
	RET
;
;  Return to user with interrupts disabled
RUTT10:	POP	AF
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
	LD	(REG_SP),SP	;SAVE USER'S STACK POINTER
	LD	SP,MONSTACK	;AND USE OURS INSTEAD
;
	LD	(REG_PC),HL
	LD	(REG_BC),BC
	LD	(REG_DE),DE
	LD	(REG_IX),IX
	LD	(REG_IY),IY
;
;  Get alternate register set
	EXX
	LD	(REG_HLX),HL
	LD	(REG_BCX),BC
	LD	(REG_DEX),DE
	EX	AF,AF'
	PUSH	AF
	POP	HL
	LD	(REG_AFX),HL
;
;;	LD	A,(PAGEIMAGE)	;GET CURRENT USER PAGE
	XOR	A		;...OR NONE IF UNPAGED TARGET
	LD	(REG_PAGE),A	;SAVE USER PAGE
;
;  Return registers to master
	JP	RETURN_REGS

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
	LD	HL,COMBUF+1
	LD	B,(HL)			;LENGTH = 4*NBYTES
	INC	HL
	INC	B
	DEC	B
	LD	C,0			;C GETS COUNT OF INSERTED BYTES
	JR	Z,SB90			;JIF NO BYTES (C=0)
	PUSH	HL
	POP	IX			;IX POINTS TO RETURN BUFFER
;
;  Loop on inserting bytes
SB10:	LD	A,(HL)			;MEMORY PAGE
	INC	HL
;;	LD	(PAGEIMAGE),A
;;	PUSH	BC
;;	LD	BC,PAGELATCH
;;	OUT	(BC),A			;SET PAGE
;;	POP	BC
	LD	E,(HL)			;ADDRESS TO DE
	INC	HL
	LD	D,(HL)
	INC	HL
;
;  Read current data at byte location
	LD	A,(DE)			;READ CURRENT DATA
	LD	(IX),A			;SAVE IN RETURN BUFFER
	INC	IX
;
;  Insert new data at byte location
	LD	A,(HL)
	LD	(DE),A			;SET BYTE
	LD	A,(DE)			;READ IT BACK
	CP	(HL)			;COMPARE TO DESIRED VALUE
	JR	NZ,SB90			;BR IF INSERT FAILED: ABORT
	INC	HL
	INC	C			;ELSE COUNT ONE BYTE TO RETURN
;
	DEC	B
	DEC	B
	DEC	B
	DJNZ	SB10			;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:	LD	A,C
	LD	(COMBUF+1),A		;SET COUNT OF RETURN BYTES
;
;  Compute checksum on buffer, and send to master, then return
	JP	SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
IN_PORT:
;
;  Get port address
	LD	BC,(COMBUF+2)
;
;  Read port value
	IN	A,(C)		;IN WITH A15-A8 = B; A7-A0 = C
;
;  Return byte read as "status"
	JP	SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
OUT_PORT:
;
;  Get port address
	LD	BC,(COMBUF+2)
;
;  Get data
	LD	A,(COMBUF+4)
;
;  Write value to port
	OUT	(C),A		;OUT WITH A15-A8 = B; A7-A0 = C
;
;  Return status of OK
	XOR	A
	JP	SEND_STATUS
;
;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
	LD	(COMBUF+2),A		;SET STATUS
	LD	A,1
	LD	(COMBUF+1),A		;SET LENGTH
	JR	SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
;  Uses 6 bytes of stack (not including return address: jumped, not called)
;
SEND:	CALL	CHECKSUM		;GET A=CHECKSUM, HL->checksum location
	NEG
	LD	(HL),A			;STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
	LD	HL,COMBUF		;POINTER TO DATA
	LD	A,(COMBUF+1)		;LENGTH OF DATA
	ADD	3			;PLUS FUNCTION, LENGTH, CHECKSUM
	LD	B,A			;save count for loop
SND10:	LD	A,(HL)
	CALL	PUTCHAR			;SEND A BYTE (uses 6 bytes of stack)
	INC	HL
	DJNZ	SND10
	JP	MAIN			;BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.  COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;	A = checksum
;	HL = pointer to next byte in buffer (checksum location)
;	B is scratched
;
;  Uses 2 bytes of stack including return address
;
CHECKSUM:
	LD	HL,COMBUF		;pointer to buffer
	LD	A,(COMBUF+1)		;length of message
	ADD	2			;plus function, length
	LD	B,A			;save count for loop
	XOR	A			;init checksum to 0
CHK10:	ADD	(HL)
	INC	HL
	DJNZ	CHK10			;loop for all
	RET				;return with checksum in A
;
;===========================================================================
;  Hardware initialization table
INIOUT:
;
;-----------------------------------------------------------------------
;  Initialization table for Z80 is up to your hardware...
  .if Z80
	.DB	port_address, init_data
	.DB	port_address, init_data
	.error	1	; Z80 Initialization Table must be completed.
	.DB	port_address, init_data
  .endif
;
;-----------------------------------------------------------------------
;  Initialization table for Z84C15
  .if Z84C15
	;
	; SET UP WAIT STATE CONTOL REGISTER FIRST.  THE FOLLOWING WAIT STATES
	; WILL BE INSERTED: INTERRUPT =0, INTERRUPT VECTOR=0, OPCODE FETCH=1,
	; SRAM ACCESS=3 AND I/O=0.  EPROM AND SRAM MUST BE 100Nsec FOR 0 WAIT.
;;	.DB	SCRP_REG	;SYSTEM CONTROL REG. POINTER
;;	.DB	00		;ACCESS TO WAIT STATE CONTROL REG.
;;	.DB	SCDP_REG	;SYSTEM CONTROL DATA PORT
;;	.DB	0b00011100
	;	  00		;no wait for interrupt ACK
	;	    0		;no wait for interrupt vector
	;	     1		;one extra wait for opcode fetch
	;	      11	;three waits for memory
	;	        00	;no wait for I/O

	;THE WATCH DOG TIMER IS DISABLED AND THE Z84C15 PUT INTO "RUN" MODE.
	;THIS IS A TWO STEP PROCESS
	.DB	WDTMR		;WATCH DOG TIMER MASTER REGISTER ADDR.
	.DB	0b00000000	;RESET WT ENABLE BIT
	.DB	WDTCR		;WATCH DOG TIMER COMMAND REG.
	.DB	0xB1		;SECOND KEY TO DISABLE THE WDT.
	.DB	WDTCR		;WATCH DOG TIMER COMMAND REG.
	.DB	0x4E		;CLEAR WATCH DOG TIMER
	.DB	WDTCR		;WDT COMMAND REG.
	.DB	0xDB		;ALLOW CHANGE TO "HALTM" FIELD
	.DB	WDTMR		;WDT MASTER REG.
	.DB	0b00011011	;RUN MODE

	;  SET WAIT STATE GENERATOR TO INSERT WAIT STATES FOR ALL OF MEMORY
	.DB	SCRP_REG	;SYSTEM CONTROL REG. POINTER
	.DB	0x01		;ACCESS THE WAIT BOUNDARY REGISTER
	.DB	SCDP_REG	;SYSTEM CONTROL DATA PORT
	.DB	0b11110000
	;	  1111		;high wait boundary (top of mem)
	;	      0000	;low wait boundary (bottom of mem)

	; THE CHIP SELECT BOUNDRY REGISTER (CSBR) DETERMINES WHICH ADDRESS
	; RANGE GETS /CS0 AND WHICH RANGE GETS /CS1. THE EPROM is 32K ON CS0
	; AND THE SRAM IS 32K ON /CS1.
	.DB	SCRP_REG	;SYSTEM CONTROL REG. POINTER
	.DB	0x02		;ACCESS THE CHIP SELECT BOUNDRY REG.
	.DB	SCDP_REG	;SYSTEM CONTROL DATA PORT
	.DB	0b11110111
	;	  1111		;range for CS1: CS0+ to Fxxx
	;	      0111	;range for CS0: 0xxx to 7xxx

	; SYSTEM CONTROL REGISTER POINTER #3 IS THE MISC. CONTROL REGISTER
	; (MCR).  WE WILL SET THE CLOCK TO DIVIDE BY 2 MODE, DISABLE THE
	; RESET OUTPUT, NORMAL CRC (16 BIT), ENABLE /CS0 & /CS1.
	.DB	SCRP_REG	;SYSTEM CONTROL REG. POINTER
	.DB	0x03		;ACCESS MISC. CONTROL REG.
	.DB	SCDP_REG	;SYSTEM CONTROL DATA PORT
	.DB	0b00001011
	;	  000		;should be zeros
	;	     0		;divide by 2
	;	      1		;disable reset output
	;	       0	;16 bit CRC
	;	        1	;enable CS1
	;	         1	;enable CS0

	; SET UP COUNTER/TIMER ONE TO PRODUCE BAUD RATE FOR SERIAL I/O.
	; THE FIRST SETS UP THE TIMER SO THAT A CLK JUMPED TO THE CLK/TRG1
	; PIN IS NOT NEEDED.  THE OTHERS USE THE COUNTER AND MUST HAVE THE
	; JUMP FROM CLKOUT TO CLK/TRG1.  SEVERAL VALUES ARE PROVIDED.
	; COMMENT OUT THE ONES THAT ARE NOT NEEDED.
	.DB	CTC_1		;ADDR. OF CTC CHANNEL 1
	.DB	0b00000011
	;	  0		;no int
	;	   0		;select timer, not counter
	;	    0		;prescale by 16
	;	     0		;clock on falling edge (not used)
	;	      0		;auto trigger
	;	       0	;no TC follows
	;	        1	;software reset
	;	         1	;control word

	.DB	CTC_1		;ADDR. OF CTC CHANNEL 1
	.DB	0b00010101
	;	  0		;no int
	;	   0		;select timer, not counter
	;	    0		;prescale by 16
	;	     1		;clock on rising edge (not used)
	;	      0		;auto trigger
	;	       1	;TC follows
	;	        0	;operate
	;	         1	;control word

	; CPU crystal is 19.6608 Mhz, for a CPU speed of 9.8304 Mhz
	; prescale by 16 = timer input of 614400 Hz
	; divisor for baud rate N is 614400/(16*N)
	.DB	CTC_1		;ADDR.  OF CTC CHANNEL 1
;;;	.DB	1		;38400 baud: TC = 1
	.DB	2		;19200 baud: TC = 2
;;;	.DB	4		;9600  baud: TC = 4
;;;	.DB	16		;2400  baud: TC = 16

	; SIO CHANNEL B INITIALIZATION.  SIO_BC IS THE SIO CHANNEL B CONTROL
	; REGISTER AT 1BH.  THIS IS THE SAME THING AS WRITE REGISTER 0 IN A
	; STAND ALONE SIO.
	.DB	SIO_BC		;ADDR. OF SIO_BC
	.DB	4		;SELECT WR4 OF SIO_B
	.DB	SIO_BC		;ADDR. OF SIO_BC
	.DB	0b01000100
	;	  01		;16X
	;	    00		;8 bit sync (ignored)
	;	      01	;1 stop bit
	;	        0	;parity odd (ignored)
	;	         0	;no parity

	;SIO B RX
	.DB	SIO_BC		;ADDRESS OF SIO_BC CMD
	.DB	3		;SELECT WR3 OF SIO_B
	.DB	SIO_BC		;ADRESS OF SIO_BC CMD
	.DB	0b11000001
	;	  11		;8 bit receive
	;	    0		;no auto enable
	;	     0		;no hunt
	;	      0		;no RxCRC
	;	       0	;no SDLC address search
	;	        0	;no sync char load inhibit
	;	         1	;enable receiver

	;SIO B TX
	.DB	SIO_BC		;ADDR. OF SIO_BC CMD
	.DB	5		;SELECT WR5 OF SIO_B
	.DB	SIO_BC		;ADDR. OF SIO_BC CMD
	.DB	0b01101000
	;	  0		;DTR off (high)
	;	   11		;8 bit transmit
	;	     0		;no break
	;	      1		;enable transmitter
	;	       0	;CRC 16 (ignored)
	;	        0	;RTS off (high)
	;	         0	;disable TX CRC

	.DB	SIO_BC		;ADDR. OF SIO B CMD
	.DB	1		;SELECT WR1
	.DB	SIO_BC		;ADDR OF SIO B CMD
	.DB	0b00000100
	;	  0		;disable wait/ready
	;	   0		;wait function (ignored)
	;	    0		;wait on receive (ignored)
	;	     00		;disable all RX interrupts
	;	       1	;status affects vector (if ints enabled)
	;	        0	;disable transmit interrupt
	;	         0	;disable external/status int
  .endif
;
;-----------------------------------------------------------------------
;  Initialization table for Z180
  .if Z180
	.DB	dcntl		;set wait state
	.DB	0b01000000
	;	  01		mem - 1 wait
	;	    00		i/o - 0 wait
	;	      0000	dreq, i/o mem select = default

	.DB	rcr		;set refresh
	.DB	0b00111100	;refresh disabled - no DRAM!

	.DB	omcr		;set operation mode
	.DB	0b01011111
	;	  0		m1 disabled - z mode of operation
	;	   1		m1 pulse not needed
	;	    0		i/o timing = z80 compatible
	;	     11111	same as default

	.DB	itc		;itc - enable only int0
	.DB	0b00000001	;clear trap/ufo bit

	.if scc_com
		.DB	scc_bc
		.DB	0x09		;select WR9
		.DB	scc_bc
		.DB	0b11000000	;make sure its in reset

		.DB	scc_bc
		.DB	0x04		;select WR4
		.DB	scc_bc
		.DB	0b01001100	;
		;	  01		X16 clock
		;	    00		X care
		;	      11	2 stop
		;	        00	parity disable

		.DB	scc_bc
		.DB	0x03		;select WR3
		.DB	scc_bc
		.DB	0b11000000	;
		;	  11		8bits/char
		;	    0		auto enable off
		;	     0000	doesn't matter
		;	         0	Rx disable at this moment

		.DB	scc_bc
		.DB	0x05		;select WR5
		.DB	scc_bc
		.DB	0b11100010	;
		;	  1		set DTR=0
		;	   11		8bits/char
		;	     0		Not send break
		;	      0		Tx disable at this moment
		;	       0 0	Doesn't matter
		;	        1	RTS=0

		.DB	scc_bc
		.DB	0x0b		;select WR11
		.DB	scc_bc
		.DB	0b01010110	;
		;	  0		No xtal
		;	   1010		TxC,RxC from BRG
		;	       110	TRxC = BRG output

		; CPU crystal is 19.6608 Mhz, for a CPU speed of 9.8304 Mhz
		; divisor for baud rate N is 9830400/(32*N)
		; register value is divisor minus 2
		.DB	scc_bc
		.DB	0x0c		;select WR12
		.DB	scc_bc
;;;;		.DB	8-2		;BR TC Low (38400 baud)
		.DB	16-2		;BR TC Low (19200 baud)
;;;;		.DB	32-2		;BR TC Low (9600 baud)
;;;;		.DB	256-2		;BR TC Low (1200 baud)

		.DB	scc_bc
		.DB	0x0d		;select WR12
		.DB	scc_bc
		.DB	0x00		;BR TC high

		.DB	scc_bc
		.DB	0x0e		;select WR14
		.DB	scc_bc
		.DB	0b00000010	;
		;	  000		nothing about DPLL
		;	     00		No local echo/loopback
		;	       0	DTR/REQ is DTR
		;	        1	BRG source = PCLK
		;	         0	Not enabling BRG yet

		.DB	scc_bc
		.DB	0x03		;select WR3
		.DB	scc_bc
		.DB	0b11000001	;
		;	  11		8bits/char
		;	    0		auto enable off
		;	     0000	doesn't matter
		;	         1	Rx enable

		.DB	scc_bc
		.DB	0x05		;select WR5
		.DB	scc_bc
		.DB	0b11101011	;
		;	  1		set DTR=0
		;	   11		8bits/char
		;	     0		Not send break
		;	      1		Tx enable
		;	       0 0	Doesn't matter
		;	        1	RTS=0

		.DB	scc_bc
		.DB	0x0e		;select WR14
		.DB	scc_bc
		.DB	0b00000011	;
		;	  000		nothing about DPLL
		;	     00		No local echo/loopback
		;	       0	DTR/REQ is DTR
		;	        1	BRG source = PCLK
		;	         1	Enable BRG

	.else
		.DB	cntla0		;asci0
		.DB	0b01100100	;no-mp, tx/rx enable, /rts=0
					;ef reset, 8bit np 1stop

		.DB	cntlb0		;asci0
		.DB	0b00100001	;
		;	  00		not mp mode
		;	    1		ps=1 (/30 mode)
		;	     0		parity/ doesn't matter!
		;	      0		x16 sampling rate
		;	       001	divide ratio - /2

	.endif
;
  .endif
;-------------------------------------------------------------------------
OUTCNT	=	(.-INIOUT)/2	; NUMBER OF INITIALIZING PAIRS

	.END	RESET
