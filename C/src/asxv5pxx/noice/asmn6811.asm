;  ASMNHC11.ASM - 68HC11 Debug monitor for use with NOICE11
;
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;   14-Jun-93 JLH release version
;    3-Aug-93 JLH improve I/O init documentation
;   24-Aug-93 JLH correct error in IN and OUT, stack init (v1.2)
;   12-May-94 JLH clarify TSTG paging info
;    7-Nov-94 JLH correct typos in comments
;    1-May-95 JLH correct error in RAMVEC usage (v1.3)
;   19-Aug-97 JLH correct bug in COP and Clock Monitor handling
;   25-Feb-98 JLH assemble with either Motorola or Dunfield
;   21-Jul-00 JLH change FN_MIN from F7 to F0
;   13-Oct-00 JLH V2.0: add CALL address to TSTG
;   12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;   28-May-01 ARB Ported to the ASxxxx 68HC11 assembler AS6811
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
;  This file has been assembled with the Motorola Freeware assembler
;  available from the Motorola Freeware BBS and elsewhere.
;
;  This file may also be assembled with the Dunfield assembler
;
;  To add banked or paged memory support:
;    1) Define page latch port PAGELATCH here
;    2) If PAGELATCH is write only, define or import the latch port's RAM
;	image PAGEIMAGE here (The application code must update PAGEIMAGE
;	before outputing to PAGELATCH)
;    3) Search for and modify PAGELATCH, PAGEIMAGE, and REG_PAGE usage below
;    4) In TSTG below edit "LOW AND HIGH LIMIT OF PAGED MEM"
;	to appropriate range (typically 8000H to BFFFH for two-bit MMU)
;
;  For more information, refer to the NoICE help file 2bitmmu.htm
;
;==========================================================================
;
; ASxxxx V4.0 AS6811 Specifics
;
; Define the banks with the mapping (paging) parameters
	.bank	CSEG
	.bank	DSEG
	.bank	IOSEG
; Area Definitions
	.area	CODE	(ABS,OVR,BANK=CSEG)
	.area	DATA	(ABS,OVR,BANK=DSEG)
	.area	IO	(ABS,OVR,BANK=IOSEG)
; Default Radix
	.radix	D
;
;============================================================================
;
;  Hardware definitions
CHIP_RAM	=	0x0000		; START OF HC11 ON-CHIP RAM
IO_START	=	0x1000		; START OF HC11 ON-CHIP I/O
RAM_START	=	0x4000		; START OF MONITOR RAM
ROM_START	=	0xBC00		; START OF MONITOR CODE
HARD_VECT	=	0xBFD6		; START OF HARDWARE VECTORS
;
	.PAGE
;============================================================================
;  Define HC11 I/O register locations (68HC11A8)
	.area	IO
	.ORG	IO_START
H11PORTA:	.RMB		1	; X000 i/o port A
		.RMB		1	; X001 reserved
H11PIOC:	.RMB		1	; X002 i/o port C control
H11PORTC:	.RMB		1	; X003 i/o port C

H11PORTB:	.RMB		1	; X004 i/o port B
H11PORTCL:	.RMB		1	; X005 i/o port CL
		.RMB		1	; X006 reserved
H11DDRC:	.RMB		1	; X007 data direction for port C

H11PORTD:	.RMB		1	; X008 i/o port D
H11DDRD:	.RMB		1	; X009 data direction for port D
H11PORTE:	.RMB		1	; X00A input port E
H11CFORC:	.RMB		1	; X00B compare force register

H11OC1M:	.RMB		1	; X00C OC1 action mask register
H11OC1D:	.RMB		1	; X00D OC1 action data register
H11TCNT:	.RMB		2	; X00E timer counter register

H11TIC1:	.RMB		2	; X010 input capture register 1
H11TIC2:	.RMB		2	; X012 input capture register 2

H11TIC3:	.RMB		2	; X014 input capture register 3
H11TOC1:	.RMB		2	; X016 output compare register 1

H11TOC2:	.RMB		2	; X018 output compare register 2
H11TOC3:	.RMB		2	; X01A output compare register 3

H11TOC4:	.RMB		2	; X01C output compare register 4
H11TOC5:	.RMB		2	; X01E output compare register 5

H11TCTL1:	.RMB		1	; X020 timer control register 1
H11TCTL2:	.RMB		1	; X021 timer control register 2
H11TMSK1:	.RMB		1	; X022 main timer interrupt mask 1
H11TFLG1:	.RMB		1	; X023 main timer interrupt flag 1

H11TMSK2:	.RMB		1	; X024 misc timer interrupt mask 2
H11TFLG2:	.RMB		1	; X025 misc timer interrupt flag 2
H11PACTL:	.RMB		1	; X026 pulse accumulator control register
H11PACNT:	.RMB		1	; X027 pulse accumulator count register

H11SPCR:	.RMB		1	; X028 SPI control register
H11SPSR:	.RMB		1	; X029 SPI status register
H11SPDR:	.RMB		1	; X02A SPI data in/out
H11BAUD:	.RMB		1	; X02B SCI baud rate control

H11SCCR1:	.RMB		1	; X02C SCI control register 1
H11SCCR2:	.RMB		1	; X02D SCI control register 2
H11SCSR:	.RMB		1	; X02E SCI status register
H11SCDR:	.RMB		1	; X02F SCI data

H11ADCTL:	.RMB		1	; X030 A to D control register
H11ADR1:	.RMB		1	; X031 A to D result 1
H11ADR2:	.RMB		1	; X032 A to D result 2
H11ADR3:	.RMB		1	; X033 A to D result 3

H11ADR4:	.RMB		1	; X034 A to D result 4
H11BPROT:	.RMB		1	; X035 EEPROM block protect
		.RMB		2	; X036 reserved

H11OPT2:	.RMB		1	; X038 system configuration options 2
H11OPTION:	.RMB		1	; X039 system configuration options
H11COPRST:	.RMB		1	; X03A arm/reset COP timer circutry
H11PPROG:	.RMB		1	; X03B EEPROM programming control

H11HPRIO:	.RMB		1	; X03C highest priority I-bit and misc.
H11INIT:	.RMB		1	; X03D ram/io mapping register
H11TEST1:	.RMB		1	; X03E factory test control register
H11CONFIG:	.RMB		1	; X03F COP, ROM, & EEPROM enables

		.RMB		16	; X040 reserved
		.RMB		12	; X050 reserved

H11CSSTRH:	.RMB		1	; X05C Chip select clock stretch
H11CSCTL:	.RMB		1	; X05D Chip select control
H11CSGADR:	.RMB		1	; X05E General purpose CS address
H11CSGSIZ:	.RMB		1	; X05F General purpose CS size
;
;
;============================================================================
;  HARDWARE PLATFORM CUSTOMIZATIONS
;============================================================================
;
;  Put you UART equates here
SER_STATUS	=	H11SCSR	 	; STATUS FROM SCI
SER_RXDATA	=	H11SCDR	 	; DATA FROM SCI
SER_TXDATA	=	H11SCDR	 	; DAT TO SCI
RXRDY		=	0x20
TXRDY		=	0x40		; TRANSMIT COMPLETE (FOR TURNOFF)
;
;============================================================================
;  RAM definitions:
	.area	DATA
	.ORG	RAM_START
;
;  RAM interrupt vectors (first in SEG for easy addressing, else move to
;  their own SEG)
RAMVEC:		.RMB	2*21
;
;  Initial user stack
;  (Size and location is user option - at least 9 bytes to accept an SWI!)
;  68HC11 SP points at NEXT BYTE TO USE, rather than at last used byte
;  like most processors.  Thus, init SP to TOP-1 of stack space
		.RMB	63
INITSTACK:	.RMB	1
;
;  Monitor stack
;  (Calculated use is at most 7 bytes.  Leave plenty of spare)
;  68HC11 SP points at NEXT BYTE TO USE, rather than at last used byte
;  like most processors.  Thus, init SP to TOP-1 of stack space
		.RMB	15
MONSTACK:	.RMB	1
;
;  Target registers:  order must match that in TRGHC11.C
TASK_REGS:
REG_STATE:	.RMB	1
REG_PAGE:	.RMB	1
REG_SP:		.RMB	2
REG_Y:		.RMB	2
REG_X:		.RMB	2
REG_B:		.RMB	1		; B BEFORE A, SO D IS LEAST SIG. FIRST
REG_A:		.RMB	1
REG_CC:		.RMB	1
REG_PC:		.RMB	2
TASK_REG_SZ	=	.-TASK_REGS
;
;  Communications buffer
;  (Must be at least as long as the longer of TASK_REG_SZ or TSTG_SIZE.
;  At least 19 bytes recommended.  Larger values may improve speed of NoICE
;  download and memory move commands.)
;
COMBUF_SIZE	=	128		; DATA SIZE FOR COMM BUFFER
COMBUF:		.RMB	2+COMBUF_SIZE+1 ; BUFFER ALSO HAS FN, LEN, AND CHECK
;
RAM_END	 =	.			; ADDRESS OF TOP+1 OF RAM
;
;===========================================================================
	.area	CODE
	.ORG	ROM_START
;
;  Power on reset
RESET:
;
;  Set CPU mode to safe state
	SEI				; INTERRUPTS OFF (WE MAY JUMP HERE)
	CLRB				; STATE 0 = "RESET"
	BRA	RES10
;
;------------------------------------------------
;  COP reset
COP_ENT:
	LDAB	#4			; STATE 4 = "COP"
	BRA	RES10
;
;------------------------------------------------
;  Clock Fail reset
CLOCK_ENT:
	LDAB	#3			; STATE 3 = "Clock fail"
;
;  Initialize HC11 hardware
;
;  BE SURE THAT "B" REMAINS INTACT UNTIL IT IS STORED TO REG_STATE BELOW!
RES10:
;
;  Monitor assumes operation in either Normal Expanded or Special Test mode
;  The exact initialization required here will depend on which variant of
;  the 68HC11 you have, and on your hardware layout.  The following is
;  basic, and may not be sufficient for your case.
;
;----------------------------------------------------------------------------
;  The following writes must occur within first 64 cycles after end of reset
;
;  CAUTION: DON'T USE I/O ADDRESS EQUATES UNTIL H11INIT IS WRITTEN
;  TO SET THE I/O BASE TO MATCH OUR EQUATES!

;  (Freeware assembler does not support parenthesis.  Thus, compute
;  each nibble separately)
CRAMLOC =	CHIP_RAM/256		; ON-CHIP RAM AT CHIP_RAM (HIGH NIBBLE)
IOLOC	=	IO_START/4096		; I/O REGS AT IO_START (LOW NIBBLE)
	LDAA	#CRAMLOC+IOLOC		; LOCATION OF RAM, I/O
;;;	STAA	H11INIT
	STAA	0x103D			; USE THE POST-RESET ADDRESS!
;
;  Save reset type (RESET, COP, or Clock Fail)
	STAB	REG_STATE		; SAVE STATE
;
;  NOW OK TO USE I/O ADDRESS EQUATES
	LDAA	#0x00			; PRESCALE TO DIVIDE BY 1
	STAA	H11TMSK2
;
	LDAA	#0x13			; IRQ LEVEL, OSC DELAY, LONG COP
	STAA	H11OPTION
;----------------------------------------------------------------------------
;
;  Possible additional special initialization
;
;	H11CONFIG	;COP, ROM, & EEPROM enables
;			;(read only except in special test mode.  May need to
;			;delay vefore programming in order to allow EEPROM
;			;charge pump to come up to voltage)
;	H11HPRIO	;highest priority I-bit and misc - set mode
;			;(writable only in special test mode)
;
;	H11CSCTL	;Chip select control
;	H11CSGSIZ	;General purpose CS size
;	H11CSGADR	;General purpose CS address
;	H11CSSTRH	;Chip select clock stretch
;
;	H11BPROT	;EEPROM block protect
;	H11PPROG	;EEPROM programming control
;		;enable programming voltage to program CONFIG register
;		;wait for voltage to stabilize before programming
;
;----------------------------------------------------------------------------
	LDS	#MONSTACK		; CLEAN STACK IS HAPPY STACK
;
;  Initialize your UART here
;  (SCI at 19200 baud from 7.3728 Mhz crystal)
	LDAA	#0x11			 ; PRE-DIV BY 3; DIV BY2
	STAA	H11BAUD
	LDAA	#0x00		 	; 8 BIT DATA
	STAA	H11SCCR1
	LDAA	#0x0C			 ; TX AND RX ENABLED, NO INTS, NO WAKE
	STAA	H11SCCR2
;
;----------------------------------------------------------------------------
;
;  Initialize RAM interrupt vectors
	LDY	#INT_ENTRY		; ADDRESS OF DEFAULT HANDLER
	LDX	#RAMVEC			; POINTER TO RAM VECTORS
	LDAB	#NVEC/2			; NUMBER OF VECTORS
RST10:	STY	0,X			; SET VECTOR
	INX
	INX
	DECB
	BNE	RST10
;
;  Initialize user registers
	LDD	#INITSTACK
	STAA	REG_SP+1		; INIT USER'S STACK POINTER MSB
	STAB	REG_SP			; LSB
	LDD	#0
	STD	REG_PC
	STAA	REG_A
	STAA	REG_B
	STD	REG_X
	STD	REG_Y
;
;  Initialize memory paging variables and hardware (if any)
	STAA	REG_PAGE		; NO PAGE YET
;;;	STAA	PAGEIMAGE
;;;	STAA	PAGELATCH		; set hardware page
;
;  Initialize non-zero registers
	LDAA	#0x50		 ; disable interrupts in user program
	STAA	REG_CC
;
;  Set function code for "GO".  Then if we are here because of a reset
;  (such as a COP timeout) after being told to GO, we will come
;  back with registers so user can see the reset
	LDAA	#FN_RUN_TARG
	STAA	COMBUF
	JMP	RETURN_REGS		; DUMP REGS, ENTER MONITOR
;
;===========================================================================
;  Get a character to A
;
;  Return A=char, CY=0 if data received
;	 CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
	PSHX
	LDX	#0			; LONG TIMEOUT
GC10:	JSR	REWDT			; PREVENT WATCHDOG TIMEOUT
	DEX
;;;	BEQ	GC90			; EXIT IF TIMEOUT
;(Disable timeout in most cases...)
	LDAA	SER_STATUS		; READ DEVICE STATUS
	ANDA	#RXRDY
	BEQ	GC10			; NOT READY YET.
;
;  Data received:  return CY=0. data in A
	CLC				; CY=0
	LDAA	SER_RXDATA		; READ DATA
	PULX
	RTS
;
;  Timeout:  return CY=1
GC90:	SEC				; CY=1
	PULX
	RTS
;
;===========================================================================
;  Output character in A
;
;  Uses 5 bytes of stack including return address
;
PUTCHAR:
	PSHA
PC10:	JSR	REWDT			; PREVENT WATCHDOG TIMEOUT
	LDAA	SER_STATUS		; CHECK TX STATUS
	ANDA	#TXRDY			; TX READY ?
	BEQ	PC10
	PULA
	STAA	SER_TXDATA		; TRANSMIT CHAR.
	RTS
;
;======================================================================
;  Reset watchdog timer.  Must be called at least once every little while
;  or COP interrupt will occur
;
;  Uses 2 bytes of stack including return address
;
REWDT:	LDAA	#0x55
	STAA	H11COPRST
	LDAA	#0xAA
	STAA	H11COPRST
	RTS
;
;======================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:	.FCB	3			; 2: PROCESSOR TYPE = 68HC11
	.FCB	COMBUF_SIZE		; 3: SIZE OF COMMUNICATIONS BUFFER
	.FCB	0x80			; 4: has CALL
	.FDB	0			; 5,6: BOTTOM OF PAGED MEM
	.FDB	0			; 7,8: TOP OF PAGED MEM
	.FCB	B1-B0			; 9 BREAKPOINT INSTR LENGTH
B0:	SWI				; 10+ BREKAPOINT INSTRUCTION
B1:	.FCC	'68HC11 monitor V3.0'	; DESCRIPTION, ZERO
	.FCB	0
	.FCB	0			; page of CALL breakpoint
	.FDB	B0			; address of CALL breakpoint in native order
TSTG_SIZE	=	.-TSTG		; SIZE OF STRING
;
;======================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STAT	=	0xFF		; reply with device info
FN_READ_MEM	=	0xFE		; reply with data
FN_WRITE_M	=	0xFD		; reply with status (+/-)
FN_READ_RG	=	0xFC		; reply with registers
FN_WRITE_RG	=	0xFB		; reply with status
FN_RUN_TARG	=	0xFA		; reply (delayed) with registers
FN_SET_BYTE	=	0xF9		; reply with data (truncate if error)
FN_IN		=	0xF8		; input from port
FN_OUT		=	0xF7		; output to port
;
FN_MIN		=	0xF0		; MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR	=	0xF0		; error reply to unknown op-code
;
;===========================================================================
;  Common handler for default interrupt handlers
;  Enter with A=interrupt code = processor state
;  All registers stacked, PC=next instruction
INT_ENTRY:
	STAA	REG_STATE		; SAVE STATE
;
;  Save registers from stack to reg block for return to master
;  Host wants least significant bytes first, so flip as necessary
	PULA
	STAA	REG_CC			; CONDITION CODES
	PULA
	STAA	REG_B
	PULA
	STAA	REG_A
	PULA
	STAA	REG_X+1			; MSB
	PULA
	STAA	REG_X			; LSB
	PULA
	STAA	REG_Y+1			; MSB
	PULA
	STAA	REG_Y			; LSB
;
;  If this is a breakpoint (state = 1), then back up PC to point at SWI
;  (If SWI2, SWI3, or another instruction is used for breakpoint,
;  then DEX multiple times to match B1-B0 in TSTG
	PULX				; PC AFTER INTERRUPT
	LDAA	REG_STATE
	CMPA	#1
	BNE	NOTBP	 		; BR IF NOT A BREAKPOINT
	DEX				; ELSE POINT AT SWI LOCATION
NOTBP:	XGDX				; TRANSFER PC TO D
	STAA	REG_PC+1		; MSB
	STAB	REG_PC	; LSB
	TSX				; USER STACK POINTER PLUS 1
	DEX				; MAKE IT JUST LIKE THE REAL SP
	XGDX
	STAB	REG_SP	; SAVE USER'S STACK POINTER (LSB)
	STAA	REG_SP+1		; MSB
;
;  Change to our own stack
	LDS	#MONSTACK		; AND USE OURS INSTEAD
;
;  Save memory page
;;;	LDAA	PAGEIMAGE		; GET CURRENT USER PAGE
	LDAA	#0			; ... OR ZERO IF UNPAGED TARGET
	STAA	REG_PAGE		; SAVE USER'S PAGE
;
;  Return registers to master
	JMP	RETURN_REGS
;
;===========================================================================
;  Main loop:  wait for command frame from master
;
;  Uses 7 bytes of stack before jump to handlers
;
MAIN:	LDS	#MONSTACK		; CLEAN STACK IS HAPPY STACK
	LDX	#COMBUF			; BUILD MESSAGE HERE
;
;  First byte is a function code
	JSR	GETCHAR			; GET A FUNCTION
	BCS	MAIN			; JIF TIMEOUT: RESYNC
	CMPA	#FN_MIN
	BLO	MAIN			; JIF BELOW MIN: ILLEGAL FUNCTION
	STAA	0,X			; SAVE FUNCTION CODE
	INX
;
;  Second byte is data byte count (may be zero)
	JSR	GETCHAR			; GET A LENGTH BYTE
	BCS	MAIN			; JIF TIMEOUT: RESYNC
	CMPA	#COMBUF_SIZE
	BHI	MAIN			; JIF TOO LONG: ILLEGAL LENGTH
	STAA	0,X			; SAVE LENGTH
	INX
	CMPA	#0
	BEQ	MA80			; SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
	TAB				; SAVE LENGTH FOR LOOP
MA10:	JSR	GETCHAR			; GET A DATA BYTE
	BCS	MAIN			; JIF TIMEOUT: RESYNC
	STAA	0,X			; SAVE DATA BYTE
	INX
	DECB
	BNE	MA10
;
;  Get the checksum
MA80:	JSR	GETCHAR			; GET THE CHECKSUM
	BCS	MAIN			; JIF TIMEOUT: RESYNC
	PSHA				; SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
	JSR	CHECKSUM
	PULB
	ABA
	BNE	MAIN			; JIF BAD CHECKSUM
;
;  Process the message.
	LDX	#COMBUF
	LDAA	0,X			; GET THE FUNCTION CODE
	LDAB	1,X			; GET THE LENGTH
	INX
	INX				; X POINTS AT DATA
	CMPA	#FN_GET_STAT
	BEQ	TARGET_STAT
	CMPA	#FN_READ_MEM
	BEQ	JREAD_MEM
	CMPA	#FN_WRITE_M
	BEQ	JWRITE_MEM
	CMPA	#FN_READ_RG
	BEQ	JREAD_REGS
	CMPA	#FN_WRITE_RG
	BEQ	JWRITE_REGS
	CMPA	#FN_RUN_TARG
	BEQ	JRUN_TARGET
	CMPA	#FN_SET_BYTE
	BEQ	JSET_BYTES
	CMPA	#FN_IN
	BEQ	JIN_PORT
	CMPA	#FN_OUT
	BEQ	JOUT_PORT
;
;  Error: unknown function.  Complain
	LDAA	#FN_ERROR
	STAA	COMBUF			; SET FUNCTION AS "ERROR"
	LDAA	#1
	JMP	SEND_STATUS		; VALUE IS "ERROR"
;
;  long jumps to handlers
JREAD_MEM:	JMP	READ_MEM
JWRITE_MEM:	JMP	WRITE_MEM
JREAD_REGS:	JMP	READ_REGS
JWRITE_REGS:	JMP	WRITE_REGS
JRUN_TARGET:	JMP	RUN_TARGET
JSET_BYTES:	JMP	SET_BYTES
JIN_PORT:	JMP	IN_PORT
JOUT_PORT:	JMP	OUT_PORT

;===========================================================================
;
;  Target Status:  FN, len
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
TARGET_STAT:
	LDX	#TSTG			; DATA FOR REPLY
	LDY	#COMBUF			; POINTER TO RETURN BUFFER
	LDAB	#TSTG_SIZE		; LENGTH OF REPLY
	STAB	1,Y			; SET SIZE IN REPLY BUFFER
TS10:	LDAA	0,X			; MOVE REPLY DATA TO BUFFER
	STAA	2,Y
	INX
	INY
	DECB
	BNE	TS10
;
;  Compute checksum on buffer, and send to master, then return
	JMP	SEND

;===========================================================================
;
;  Read Memory:  FN, len, page, Alo, Ahi, Nbytes
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
READ_MEM:
;
;  Set page
;;	LDAA	0,X
;;	STAA	PAGEIMAGE
;;	STAA	PAGELATCH
;
;  Get address
	LDAA	2,X			; MSB OF ADDRESS IN A
	LDAB	1,X			; LSB OF ADDRESS IN B
	XGDY				; ADDRESS IN Y
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LDAB	3,X			; NUMBER OF BYTES TO RETURN
	STAB	COMBUF+1		; RETURN LENGTH = REQUESTED DATA
	BEQ	GLP90			; JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
GLP:	LDAA	0,Y			; GET BYTE
	STAA	0,X			; STORE TO RETURN BUFFER
	INX
	INY
	DECB
	BNE	GLP
;
;  Compute checksum on buffer, and send to master, then return
GLP90:	JMP	SEND

;===========================================================================
;
;  Write Memory:  FN, len, page, Alo, Ahi, (len-3 bytes of Data)
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
;  Uses 6 bytes of stack
;
WRITE_MEM:
;
;  Set page
;;	LDAA	0,X
;;	STAA	PAGEIMAGE
;;	STAA	PAGELATCH
;
;  Get address
	LDAA	2,X			; MSB OF ADDRESS IN A
	LDAB	1,X			; LSB OF ADDRESS IN B
	XGDY				; ADDRESS IN Y
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LDAB	COMBUF+1		; NUMBER OF BYTES TO RETURN
	SUBB	#3			; MINUS PAGE AND ADDRESS
	BEQ	WLP50			; JIF NO BYTES TO PUT
;
;  Write the specified bytes to local memory
	PSHB
	PSHX
	PSHY
WLP:	LDAA	3,X			; GET BYTE TO WRITE
	STAA	0,Y			; STORE THE BYTE AT AAAA,Y
	INX
	INY
	DECB
	BNE	WLP
;
;  Compare to see if the write worked
	PULY
	PULX
	PULB
WLP20:	LDAA	3,X			; GET BYTE JUST WRITTEN
	CMPA	0,Y
	BNE	WLP80			; BR IF WRITE FAILED
	INX
	INY
	DECB
	BNE	WLP20
;
;  Write succeeded:  return status = 0
WLP50:	LDAA	#0			; RETURN STATUS = 0
	BRA	WLP90
;
;  Write failed:  return status = 1
WLP80:	LDAA	#1
;
;  Return OK status
WLP90:	JMP	SEND_STATUS

;===========================================================================
;
;  Read registers:  FN, len=0
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
READ_REGS:
;
;  Enter here from SWI after "RUN" and "STEP" to return task registers
;  CAUTION:  in this case, assume no registers!
RETURN_REGS:
	LDY	#TASK_REGS		; POINTER TO REGISTERS
	LDAB	#TASK_REG_SZ		; NUMBER OF BYTES
	STAB	COMBUF+1		; SAVE RETURN DATA LENGTH
;
;  Copy the registers
	LDX	#COMBUF+2		; POINTER TO RETURN BUFFER
GRLP:	LDAA	0,Y			; GET BYTE TO A
	STAA	0,X			; STORE TO RETURN BUFFER
	INX
	INY
	DECB
	BNE	GRLP
;
;  Compute checksum on buffer, and send to master, then return
	JMP	SEND

;===========================================================================
;
;  Write registers:  FN, len, (register image)
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
WRITE_REGS:
;
	LDAB	COMBUF+1		; NUMBER OF BYTES
	BEQ	WRR80			; JIF NO REGISTERS
;
;  Copy the registers
	LDY	#TASK_REGS		; POINTER TO REGISTERS
WRRLP:	LDAA	0,X			; GET BYTE TO A
	STAA	0,Y			; STORE TO REGISTER RAM
	INX
	INY
	DECB
	BNE	WRRLP
;
;  Return OK status
WRR80:	LDAA	#0
	JMP	SEND_STATUS

;===========================================================================
;
;  Run Target:  FN, len
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
RUN_TARGET:
;
;  Restore user's page
;;	LDAA	REG_PAGE		; USER'S PAGE
;;	STAA	PAGEIMAGE		; SET IMAGE
;;	STAA	PAGELATCH		; SET PAGING REGISTER
;
;  Switch to user stack
	LDAB	REG_SP			; BACK TO USER STACK
	LDAA	REG_SP+1
	XGDX				; TO X
	INX				; PRE-CORRECT FOR TXS
	TXS				; SP = X-1
;
;  Restore registers
	LDAA	REG_PC			; SAVE LS USER PC FOR RTI
	PSHA
	LDAA	REG_PC+1		; SAVE MS USER PC FOR RTI
	PSHA
;
	LDAA	REG_Y
	PSHA
	LDAA	REG_Y+1
	PSHA
;
	LDAA	REG_X
	PSHA
	LDAA	REG_X+1
	PSHA
;
	LDAA	REG_A
	PSHA
	LDAA	REG_B
	PSHA
;
	LDAA	REG_CC			; SAVE USER CONDITION CODES FOR RTI
	PSHA
;
;  Return to user
	RTI
;
;===========================================================================
;
;  Set target byte(s):  FN, len { (page, alow, ahigh, data), (...)... }
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
;  Return has FN, len, (data from memory locations)
;
;  If error in insert (memory not writable), abort to return short data
;
;  This function is used primarily to set and clear breakpoints
;
;  Uses 3 bytes of stack
;
SET_BYTES:
	LDY	#COMBUF+1		; POINTER TO RETURN BUFFER
	LDAA	#0
	STAA	0,Y			; SET RETURN COUNT AS ZERO
	INY				; POINT AT FIRST RETURN DATA BYTE
	LSRB
	LSRB				; LEN/4 = NUMBER OF BYTES TO SET
	BEQ	SB99			; JIF NO BYTES (COMBUF+1 = 0)
;
;  Loop on inserting bytes
SB10:	PSHB				; SAVE LOOP COUNTER
	PSHY				; SAVE RETURN BUFFER POINTER
;
;  Set page
;;	LDAA	0,X
;;	STAA	PAGEIMAGE
;;	STAA	PAGELATCH
;
;  Get address
	LDAA	2,X			; MSB OF ADDRESS IN A
	LDAB	1,X			; LSB OF ADDRESS IN B
	XGDY				; MEMORY ADDRESS IN Y
;
;  Read current data at byte location
	LDAA	0,Y
;
;  Insert new data at byte location
	LDAB	3,X			; GET BYTE TO STORE
	STAB	0,Y			; WRITE TARGET MEMORY
;
;  Verify write
	CMPB	0,Y			; READ TARGET MEMORY
	PULY				; RESTORE RETURN PTR (CC'S INTACT)
	PULB				; RESTORE LOOP COUNTER (CC'S INTACT)
	BNE	SB90			; BR IF INSERT FAILED: ABORT
;
;  Save target byte in return buffer
	STAA	0,Y
	INY				; ADVANCE TO NEXT RETURN BYTE
	INC	COMBUF+1		; COUNT ONE RETURN BYTE
;
;  Loop for next byte
	INX				; STEP TO NEXT BYTE SPECIFIER
	INX
	INX
	INX
	CMPB	COMBUF+1
	BNE	SB10			; LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:
;
;  Compute checksum on buffer, and send to master, then return
SB99:	JMP	SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
;  While the HC11 has no input or output instructions, we retain these
;  to allow write-without-verify
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
IN_PORT:
;
;  Get port address
	LDAA	1,X			; MSB OF ADDRESS IN A
	LDAB	0,X			; LSB OF ADDRESS IN B
	XGDY				; MEMORY ADDRESS IN Y
;
;  Read the requested byte from local memory
	LDAA	0,Y
;
;  Return byte read as "status"
	JMP	SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
OUT_PORT:
;
;  Get port address
	LDAA	1,X			; MSB OF ADDRESS IN A
	LDAB	0,X			; LSB OF ADDRESS IN B
	XGDY				; MEMORY ADDRESS IN Y
;
;  Get data
	LDAA	2,X
;
;  Write value to port
	STAA	0,Y
;
;  Do not read port to verify (some I/O devices don't like it)
;
;  Return status of OK
	LDAA	#0
	JMP	SEND_STATUS

;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
	STAA	COMBUF+2		; SET STATUS
	LDAA	#1
	STAA	COMBUF+1		; SET LENGTH
	BRA	SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
SEND:	JSR	CHECKSUM		; GET A=CHECKSUM, X->checksum location
	NEGA
	STAA	0,X			; STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
	LDX	#COMBUF			; POINTER TO DATA
	LDAB	1,X			; LENGTH OF DATA
	ADDB	#3			; PLUS FUNCTION, LENGTH, CHECKSUM
SND10:	LDAA	0,X
	JSR	PUTCHAR			; SEND A BYTE
	INX
	DECB
	BNE	SND10
;
	JMP	MAIN			; BACK TO MAIN LOOP

;===========================================================================
;  Compute checksum on COMBUF.  COMBUF+1 has length of data,
;  Also include function byte and length byte
;
;  Returns:
;	A = checksum
;	X = pointer to next byte in buffer (checksum location)
;	B is scratched
;
;  Uses 2 bytes of stack including return address
;
CHECKSUM:
	LDX	#COMBUF			; pointer to buffer
	LDAB	1,X			; length of message
	ADDB	#2			; plus function, length
	LDAA	#0			; init checksum to 0
CHK10:	ADDA	0,X
	INX
	DECB
	BNE	CHK10			; loop for all
	RTS				; return with checksum in A

;**********************************************************************
;
;  Interrupt handlers to catch unused interrupts and traps
;  Registers are stacked.  Jump through RAM vector using X, type in A
;
;  This will affect only interrupt routines looking for register values!
;
;  Our default handler uses the code in "A" as the processor state to be
;  passed back to the host.
;
SCI_ENT:	 LDAA	#20		; ffd6
		LDX	RAMVEC+0
		JMP	0,X
;
SPI_ENT:	 LDAA	#19		; ffd8
		LDX	RAMVEC+2
		JMP	0,X
;
PACE_ENT:	LDAA	#18		; ffda
		LDX	RAMVEC+4
		JMP	0,X
;
PACO_ENT:	LDAA	#17		; ffdc
		LDX	RAMVEC+6
		JMP	0,X
;
TOV_ENT:	 LDAA	#16		; ffde
		LDX	RAMVEC+8
		JMP	0,X
;
TCOMP5_ENT:	LDAA	#15		; ffe0
		LDX	RAMVEC+10
		JMP	0,X
;
TCOMP4_ENT:	LDAA	#14		; ffe2
		LDX	RAMVEC+12
		JMP	0,X
;
TCOMP3_ENT:	LDAA	#13		; ffe4
		LDX	RAMVEC+14
		JMP	0,X
;
TCOMP2_ENT:	LDAA	#12		; ffe6
		LDX	RAMVEC+16
		JMP	0,X
;
TCOMP1_ENT:	LDAA	#11		; ffe8
		LDX	RAMVEC+18
		JMP	0,X
;
TCAP3_ENT:	LDAA	#10		; ffea
		LDX	RAMVEC+20
		JMP	0,X
;
TCAP2_ENT:	LDAA	#9		; ffec
		LDX	RAMVEC+22
		JMP	0,X
;
TCAP1_ENT:	LDAA	#8		; ffee
		LDX	RAMVEC+24
		JMP	0,X
;
RTC_ENT:	 LDAA	#7		; fff0
		LDX	RAMVEC+26
		JMP	0,X
;
IRQ_ENT:	 LDAA	#6		; fff2
		LDX	RAMVEC+28
		JMP	0,X
;
;  Non-RAM vectored
SWI_ENTRY:	LDAA	#1
		JMP	INT_ENTRY
XIRQ_ENTRY:	LDAA	#2
		JMP	INT_ENTRY
ILLOP_ENT:	LDAA	#5
		JMP	INT_ENTRY
;
;  INTERRUPT VECTORS
	.area	CODE
	.ORG	HARD_VECT
;
;  VECTORS THROUGH RAM
VEC0:	.FDB	SCI_ENT			; ffd6
	.FDB	SPI_ENT			; ffd8
	.FDB	PACE_ENT		; ffda
	.FDB	PACO_ENT		; ffdc
	.FDB	TOV_ENT			; ffde
	.FDB	TCOMP5_ENT		; ffe0
	.FDB	TCOMP4_ENT		; ffe2
	.FDB	TCOMP3_ENT		; ffe4
	.FDB	TCOMP2_ENT		; ffe6
	.FDB	TCOMP1_ENT		; ffe8
	.FDB	TCAP3_ENT		; ffea
	.FDB	TCAP2_ENT		; ffec
	.FDB	TCAP1_ENT		; ffee
	.FDB	RTC_ENT			; fff0
	.FDB	IRQ_ENT			; fff2
NVEC	=	.-VEC0			; number of vector bytes
;
;  The remaining interrupts are permanently trapped to the monitor
	.FDB	XIRQ_ENTRY		; fff4 (non-maskable interrupt)
	.FDB	SWI_ENTRY		; fff6 SWI/breakpoint
	.FDB	ILLOP_ENT		; fff8 illegal op-code
	.FDB	COP_ENT			; fffa Watchdog timeout
	.FDB	CLOCK_ENT		; fffc clock fail
	.FDB	RESET			; fffe reset
;
	.END	RESET
