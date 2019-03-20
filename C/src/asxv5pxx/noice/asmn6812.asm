;  ASMN6812.ASM - 68HC12 Debug monitor for use with NOICE12
;  Copyright (c) 2001 by John Hartman
;
;  Modification History:
;   31-Jul-99 JLH ported from MONHC11
;   17-Aug-99 JLH make generic and table driven
;   17-Sep-99 JLH do initial writes twice: needed for SPECIAL modes
;   21-Jul-00 JLH change FN_MIN from F7 to F0, Add HKE Tempest12
;   13-Oct-00 JLH V2.0: add CALL address to TSTG
;   12-Mar-01 JLH V3.0: improve text about paging, formerly called "mapping"
;   28-May-01 ARB Ported to the ASxxxx 68HC12 assembler AS6812
;
;============================================================================
;  To customize for a given target, you must change code in the
;  hardware equates, the string TSTG, and the routines RESET and REWDT.
;  You may or may not need to change GETCHAR, PUTCHAR, depending on
;  how peculiar your UART is.
;
;  For more information, refer to the NoICE help file monitor.htm
;
;  To enable banked or paged memory support
;  1) Define page latch port PPAGE to match your target chip (0x1035 on the A4)
;  2) Search for and modify PPAGE and REG_PAGE usage below
;  3) In TSTG below edit "LOW AND HIGH LIMIT OF PAGED MEM"
;     to appropriate range (8000H to BFFFH for the HC12's built-in banking)
;
;  For more information, refer to the NoICE help file 2bitmmu.htm
;
;  If you are using one of the boards shown below, just define the
;  appropriate symbol.
;  DEFINE ONLY ONE SYMBOL AT A TIME.
;
;  This file has been assembled with the Motorola Freeware assembler
;  available from the Motorola Freeware BBS and elsewhere.
;
;  This file may also be assembled with the Dunfield assembler
;
;==========================================================================
;
; ASxxxx V4.0 AS6812 Specifics
;
; Define the banks with the mapping (paging) parameters
	.bank	CHIP_RAM	;START OF HC12 ON-CHIP RAM
	.bank	CHIP_IO		;START OF HC12 ON-CHIP I/O
	.bank	CHIP_EEPROM	;START OF HC12 ON-CHIP EEPROM
	.bank	RAM_START	;START OF MONITOR RAM
	.bank	ROM_START	;START OF MONITOR CODE
; Area Definitions
	.area	CHIP_RAM	(ABS,OVR,BANK=CHIP_RAM)
	.area	CHIP_IO		(ABS,OVR,BANK=CHIP_IO)
	.area	CHIP_EEPROM	(ABS,OVR,BANK=CHIP_EEPROM)
	.area	RAM_START	(ABS,OVR,BANK=RAM_START)
	.area	ROM_START	(ABS,OVR,BANK=ROM_START)
; Default Radix
	.radix	D
;
;============================================================================
; Axiom CMD12A4
;  - Operates in either wide or narrow mode, either single-chip or expanded
;  - Comes with 64K or more RAM, 64K or more EEPROM in DIP packages
;    I have 64K of 70 nsec RAM and 64K of 200 nsec EEPROM
;  - ROM (EEPROM) is on CSP0 or CSP1
;  - RAM is on CSD or CSP1.  However, cannot locate CSP1 C000-FFFF
;
;  Define the following for wide mode -
;  
;32K RAM and 32K EEPROM (with NoICE monitor).
;
AXIOM_WIDE_32K	=	1
;
.if AXIOM_WIDE_32K
CHIP_RAM	=	0x0800		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1	;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.endif

;  Define the following for narrow mode 32K RAM and 32K EEPROM (with NoICE monitor).
;
AXIOM_NARROW_32K	=	0
;
.if AXIOM_NARROW_32K
CHIP_RAM	=	0x0800		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1		;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.endif
;
;  ? Could we put RAM in the ROM sockets on CSP0?  Boot in single-chip
;	mode from EEPROM.  Remap to put EEPROM in "normal" location
;	at 0x1000.  Map RAM in ROM socket into top 32K with paging.
;	initialize interrupt vectors to point to monitor in EEPROM.
;
;	OR copy monitor to RAM via code banking and run from RAM.
;
;	2 by 128K = 256K of RAM = 16 pages of 16K
;
;============================================================================
; Technological Arts Adapt812DX
;  - Operates only in narrow mode, either single-chip or expanded
;  - Comes with either 128K or 512K RAM, 128K or 512K Flash
;	I have 512K of 50 nsec RAM, and 512K of 90 nsec Flash
;  - Flash is on CSP0.
;  - RAM is on CSD.  Thus, there can be at most 32K of RAM mapped at once.
;
;  Define the following for 32K RAM and 32K Flash (with NoICE monitor).
;
ADAPT_32K	=	0
;
.if ADAPT_32K
CHIP_RAM	=	0x0800		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1	;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.endif
;
;============================================================================
; MCT Lange & Thamm HC12compact
;  - Operates only in wide mode, either single-chip or expanded
;  - Comes with 256K RAM, 512K Flash (1024K RAM optional)
;	I have 256K of 70 nsec RAM and 512K of 70 nsec Flash
;  - Flash is on CSP0.
;  - RAM is on CSD.  Thus, there can be at most 32K of RAM mapped at once.
;
;  Define the following for 32K RAM and 32K Flash (with NoICE monitor).
;
COMPACT_32K	=	0
;
.if COMPACT_32K
CHIP_RAM	=	0x0800		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1	;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.endif
;
;============================================================================
; HKE tempest12
;  - Operates only in wide mode, either single-chip or expanded
;  - Comes with 256K RAM, 512K Flash (1024K RAM optional)
;	I have 256K of 70 nsec RAM and 512K of 70 nsec Flash
;  - Flash is on CSP0.
;  - RAM is on CSD.  Thus, there can be at most 32K of RAM mapped at once.
;
;  Define the following for 32K RAM and 32K Flash (with NoICE monitor).
;
TEMPEST12	=	0
;
.if TEMPEST12
CHIP_RAM	=	0x0A00		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1	;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.endif
;
;============================================================================
;  If no particular board has been defined, then you had better
;  define these yourself!
;
CHIP_RAM	=	0
;
.if CHIP_RAM
USER_DEFINED	=	1		;flag as user definitions
CHIP_RAM	=	0x0800		;START OF HC12 ON-CHIP RAM
INITSTACK	=	0x0BFF+1	;INIT USER STACK: TOP+1 OF ON-CHIP RAM
CHIP_IO		=	0x0000		;START OF HC12 ON-CHIP I/O
CHIP_EEPROM	=	0x1000		;START OF HC12 ON-CHIP EEPROM
USER_VECTORS	=	0x7FC0		;START OF HARDWARE VECTORS
RAM_START	=	0x7F00		;START OF MONITOR RAM
ROM_START	=	0xFC00		;START OF MONITOR CODE
HARD_VECT	=	0xFFC0		;START OF HARDWARE VECTORS
.else
USER_DEFINED	=	0		;flag as user definitions
.endif
;
;============================================================================
;  Define HC12 I/O register locations (68HC12A4)
;
	.area	CHIP_IO
	.org	CHIP_IO
;
PORTA	=	.+0	;port A = Address lines A8 - A15
PORTB	=	.+1	;port B = Address lines A0 - A7
DDRA	=	.+2	;port A direction register
DDRB	=	.+3	;port A direction register
PORTC	=	.+4	;port C = Data 7-15 wide,Data 0-7narrow
PORTD	=	.+5	;port D = Data 0-7 wide
DDRC	=	.+6	;port C direction register
DDRD	=	.+7	;port D direction register
PORTE	=	.+8	;port E = mode,IRQandcontrolsignals
DDRE	=	.+9	;port E direction register
PEAR	=	.+0xA	;port E assignments
MODE	=	.+0xB	;Mode register
PUCR	=	.+0xC	;port pull-up control register
RDRIV	=	.+0xD	;port reduced drive control register
INITRM	=	.+0x10	;Ram location register
INITRG	=	.+0x11	;Register location register
INITEE	=	.+0x12	;EEprom location register
MISC	=	.+0x13	;Miscellaneous Mapping control
RTICTL	=	.+0x14	;Real time clock control
RTIFLG	=	.+0x15	;Real time clock flag
COPCTL	=	.+0x16	;Clock operating properly control
COPRST	=	.+0x17	;COP reset register

INTCR	=	.+0x1E	;interrupt control register
HPRIO	=	.+0x1F	;high priority reg
KWIED	=	.+0x20	;Key wake-up port D enable
KWIFD	=	.+0x21	;Key wake-up port D flags
PORTH	=	.+0x24	;port H = keypad port
DDRH	=	.+0x25	;port H direction register
KWIEH	=	.+0x26	;Key wake-up port H enable
KWIFH	=	.+0x27	;Key wake-up port H flags
PORTJ	=	.+0x28	;port J = Keypad / Serial ctl lines
DDRJ	=	.+0x29	;port J direction register
KWIEJ	=	.+0x2A	;Key wake-up port J enable
KWIFJ	=	.+0x2B	;Key wake-up port J flags
KPOLJ	=	.+0x2C	;port J wake-up polarity
PUPSJ	=	.+0x2D	;port J pull-up/down select
PULEJ	=	.+0x2E	;port J Pull-up/down enable
PORTF	=	.+0x30	;port F = Chip selects
PORTG	=	.+0x31	;port G = Address lines A16 - A21
DDRF	=	.+0x32	;port F direction register
DDRG	=	.+0x33	;port G direction register
DPAGE	=	.+0x34	;CSD chip select page register
PPAGE	=	.+0x35	;CSP chip select page register
EPAGE	=	.+0x36	;CS3/Epage chip select page register
WINDEF	=	.+0x37	;memory page window enable register
MXAR	=	.+0x38	;memory expansion enable A16-A21
CSCTL0	=	.+0x3C	;chip select control register
CSCTL1	=	.+0x3D	;chip select control register
CSSTR0	=	.+0x3E	;chip select stretch register
CSSTR1	=	.+0x3F	;chip select stretch register

LDV	=	.+0x40	;PLL loop divider value hi
;LDV	=	.+0x41	;PLL loop divider value lo
RDV	=	.+0x42	;PLL reference divider value hi
;RDV	=	.+0x43	;PLL reference divider value lo
CLKCTL	=	.+0x47	;System clock control
ATDCTL0	=	.+0x60	;ADC control 0 (reserved)
ATDCTL1	=	.+0x61	;ADC control 1 (reserved)
ATDCTL2	=	.+0x62	;ADC control 2
ATDCTL3	=	.+0x63	;ADC control 3
ATDCTL4	=	.+0x64	;ADC control 4
ATDCTL5	=	.+0x65	;ADC control 5
ATDSTAT	=	.+0x66	;ADC status register hi
;ATDSTAT	=	.+0x67	;ADC status register lo
ATDTEST	=	.+0x68	;ADC test (reserved)
;ATDTEST	=	.+0x69
PORTAD	=	.+0x6F	;port ADC = input only
ADR0H	=	.+0x70	;ADC result 0 register
ADR1H	=	.+0x72	;ADC result 1 register
ADR2H	=	.+0x74	;ADC result 2 register
ADR3H	=	.+0x76	;ADC result 3 register
ADR4H	=	.+0x78	;ADC result 4 register
ADR5H	=	.+0x7A	;ADC result 5 register
ADR6H	=	.+0x7C	;ADC result 6 register
ADR7H	=	.+0x7E	;ADC result 7 register
TIOS	=	.+0x80	;timer input/output select
CFORC	=	.+0x81	;timer compare force
OC7M	=	.+0x82	;timer output compare 7 mask
OC7D	=	.+0x83	;timer output compare 7 data
TCNT	=	.+0x84	;timer counter register hi
;TCNT	=	.+0x85	;timer counter register lo
TSCR	=	.+0x86	;timer system control register
TQCR	=	.+0x87	;reserved
TCTL1	=	.+0x88	;timer control register 1
TCTL2	=	.+0x89	;timer control register 2
TCTL3	=	.+0x8A	;timer control register 3
TCTL4	=	.+0x8B	;timer control register 4
TMSK1	=	.+0x8C	;timer interrupt mask 1
TMSK2	=	.+0x8D	;timer interrupt mask 2
TFLG1	=	.+0x8E	;timer flags 1
TFLG2	=	.+0x8F	;timer flags 2
TC0	=	.+0x90	;timer capture/compare register 0
;TC0	=	.+0x91
TC1	=	.+0x92	;timer capture/compare register 1
;TC1	=	.+0x93
TC2	=	.+0x94	;timer capture/compare register 2
;TC2	=	.+0x95
TC3	=	.+0x96	;timer capture/compare register 3
;TC3	=	.+0x97
TC4	=	.+0x98	;timer capture/compare register 4
;TC4	=	.+0x99
TC5	=	.+0x9A	;timer capture/compare register 5
;TC5	=	.+0x9B
TC6	=	.+0x9C	;timer capture/compare register 6
;TC6	=	.+0x9D
TC7	=	.+0x9E	;timer capture/compare register 7
;TC7	=	.+0x9F
PACTL	=	.+0xA0	;pulse accumulator controls
PAFLG	=	.+0xA1	;pulse accumulator flags
PACNT	=	.+0xA2	;pulse accumulator counter
;PACNT	=	.+0xA3
TIMTST	=	.+0xAD	;timer test register
PORTT	=	.+0xAE	;port T = Timer port
DDRT	=	.+0xAF	;port T direction register
SC0BDH	=	.+0xC0	;sci 0 baud reg hi byte
SC0BDL	=	.+0xC1	;sci 0 baud reg lo byte
SC0CR1	=	.+0xC2	;sci 0 control1 reg
SC0CR2	=	.+0xC3	;sci 0 control2 reg
SC0SR1	=	.+0xC4	;sci 0 status reg 1
SC0SR2	=	.+0xC5	;sci 0 status reg 2
SC0DRH	=	.+0xC6	;sci 0 data reg hi
SC0DRL	=	.+0xC7	;sci 0 data reg lo
SC1BDH	=	.+0xC8	;sci 1 baud reg hi byte
SC1BDL	=	.+0xC9	;sci 1 baud reg lo byte
SC1CR1	=	.+0xCA	;sci 1 control1 reg
SC1CR2	=	.+0xCB	;sci 1 control2 reg
SC1SR1	=	.+0xCC	;sci 1 status reg 1
SC1SR2	=	.+0xCD	;sci 1 status reg 2
SC1DRH	=	.+0xCE	;sci 1 data reg hi
SC1DRL	=	.+0xCF	;sci 1 data reg lo
SP0CR1	=	.+0xD0	;spi 0 control1 reg
SP0CR2	=	.+0xD1	;spi 0 control2 reg
SP0BR	=	.+0xD2	;spi 0 baud reg
SP0SR	=	.+0xD3	;spi 0 status reg hi
SP0DR	=	.+0xD5	;spi 0 data reg
PORTS	=	.+0xD6	;port S = Serial port
DDRS	=	.+0xD7	;port S direction register
EEMCR	=	.+0xF0	;EEprom mode control
EEPROT	=	.+0xF1	;EEprom	block protect reg
EETST	=	.+0xF2	;EEprom test register
EEPROG	=	.+0xF3	;EEprom program reg
;
;============================================================================
;  HARDWARE PLATFORM CUSTOMIZATIONS
;============================================================================
;
;  Put you UART equates here
;  (These are for the SCI)
SER_STATUS	=	SC0SR1	 	;STATUS FROM SCI
SER_RXDATA	=	SC0DRL	 	;DATA FROM SCI
SER_TXDATA	=	SC0DRL	 	;DATA TO SCI
RXRDY		=	0x20
TXRDY		=	0x80		;TRANSMIT COMPLETE (FOR TURNOFF)
;
;============================================================================
;  Monitor RAM definitions
	.area	RAM_START
	.ORG	RAM_START
;
;  Target registers:  order must match that in TRGHC12.C
TASK_REGS:
REG_STATE:	.rmb	1
REG_PAGE:	.rmb	1
REG_SP:		.rmb	2
REG_Y:		.rmb	2
REG_X:		.rmb	2
REG_B:		.rmb	1		;B BEFORE A, SO D IS LEAST SIG. FIRST
REG_A:		.rmb	1
REG_CC:		.rmb	1
REG_PC:		.rmb	2
TASK_REG_SZ	=	.-TASK_REGS
;
;  Communications buffer
;  (Must be at least as long as the longer of TASK_REG_SZ or TSTG_SIZE.
;  At least 19 bytes recommended.  Larger values may improve speed of NoICE
;  download and memory move commands.  Maximum 128.)
COMBUF_SIZE	=	128		;DATA SIZE FOR COMM BUFFER
COMBUF:		.rmb	2+COMBUF_SIZE+1 ;BUFFER ALSO HAS FN, LEN, AND CHECK
;
;  Don't let this overlap the user vectors...
RAM_END		=	.		;ADDRESS OF TOP+1 OF RAM
;
;============================================================================
;  RAM interrupt vectors.  Equivalent to vectors FFC0 to FFFF
	.area	RAM_START
	.ORG	USER_VECTORS
;
RAMVEC:		.rmb	2*32
;
;===========================================================================
	.area	ROM_START
	.ORG	ROM_START
;
;  On-chip I/O initialization.  Each entry is (port, value)
;  Table ends with port=0xFF.
;
;  The monitor assumes operation in either Expanded or Special Expanded mode.
;  The exact initialization required here will depend on which variant of
;  the 68HC12 you have, and on your hardware layout.  The following is
;  basic, and may not be sufficient for your case.
;
;  Many of these registers can be written only once after reset.  They are
;  set here, often to their default values, so that an errant user program
;  doesn't change them (and possibly lock up the target).  If you want your
;  user program to be responsible for setting them, either remove this code,
;  or change to "special" mode, in which these registers can be written at
;  will.  However, note that in special mode many registers must be written
;  TWICE, as the first write is ignored.
;
;  CHIP SELECTS
;  If E is 8 MHz (16 MHz crystal), then 1 cycle is 125 nsec and
;  - 0 wait states requires 80 nsec access time
;  - 1 wait states requires 200 nsec access time
;  - 2 wait states requires 330 nsec access time
;  - 3 wait states requires 455 nsec access time
;
;  Any "real" program should enable the COP.  However, we disable it
;  for the convenience of your initial testing.
;  You should enable the clock monitor unless you are going to use
;  the STOP instruction for lowest power consumption.
;
;  We have made internal bus operations visible, so that you can see them
;  with a scope or logic analyzer.  For production systems, you may wish
;  to disable this in order to reduce emissions.
;
INIT_TABLE:

.if AXIOM_WIDE_32K
	.FCB INITRM-CHIP_IO, CHIP_RAM/256	;locate RAM
	.FCB INITEE-CHIP_IO, CHIP_EEPROM/256+1	;locate and enable EEPROM
	.FCB COPCTL-CHIP_IO, 0x00	;DISABLE CLOCK MONITOR, NO COP TIMEOUT
	.FCB INTCR-CHIP_IO,  0x60	;IRQ LEVEL SENSE, IRQ ENABLED, STOP DLY ENABLED
	.FCB PEAR-CHIP_IO,   0x0C	;PE4=E, PE3=LSTRB, PE2=R/W
	.FCB MODE-CHIP_IO,   0xF8	;NORMAL EXPANDED WIDE, VISIBLE BUS
	.FCB CSCTL0-CHIP_IO, 0x7F	;USE CSP1, CSP0, CSD, CS3, CS2, CS1, AND CS0
	.FCB CSCTL1-CHIP_IO, 0x10	;CSD IS 32K
	.FCB CSSTR0-CHIP_IO, 0x15	;1 WAIT STATE ON ALL MEMORY CHIP SELECTS
					;(uses 200 nsec EEPROM: 1 wait state)
	.FCB CSSTR1-CHIP_IO, 0xFF	;3 WAIT STATES ON ALL I/O CHIP SELECTS
	.FCB MISC-CHIP_IO,   0x40	;NO EXTRA WINDOW, CS3-0 ARE 8-BIT
	.FCB WINDEF-CHIP_IO, 0x00	;NO DATA WINDOW, NO PROGRAM WINDOW
	.FCB PPAGE-CHIP_IO,  0x00	;INITIAL PAGE.  SEE ALSO COPY TO REG_PAGE BELOW
	.FCB DPAGE-CHIP_IO,  0x00
	.FCB EPAGE-CHIP_IO,  0x00
	.FCB MXAR-CHIP_IO,   0x00	;A21-A16 USED AS PORT PINS
.endif

.if AXIOM_NARROW_32K
	.FCB INITRM-CHIP_IO, CHIP_RAM/256	;locate RAM
	.FCB INITEE-CHIP_IO, CHIP_EEPROM/256+1	;locate and enable EEPROM
	.FCB COPCTL-CHIP_IO, 0x00	;DISABLE CLOCK MONITOR, NO COP TIMEOUT
	.FCB INTCR-CHIP_IO,  0x60	;IRQ LEVEL SENSE, IRQ ENABLED, STOP DLY ENABLED
	.FCB PEAR-CHIP_IO,   0x04	;PE4=E, PE2=R/W
	.FCB MODE-CHIP_IO,   0xB8	;NORMAL EXPANDED NARROW, VISIBLE BUS
	.FCB CSCTL0-CHIP_IO, 0x7F	;USE CSP1, CSP0, CSD, CS3, CS2, CS1, AND CS0
	.FCB CSCTL1-CHIP_IO, 0x10	;CSD IS 32K
	.FCB CSSTR0-CHIP_IO, 0x15	;1 WAIT STATE ON ALL MEMORY CHIP SELECTS
	.FCB CSSTR1-CHIP_IO, 0xFF	;3 WAIT STATES ON ALL I/O CHIP SELECTS
	.FCB MISC-CHIP_IO,   0x40	;NO EXTRA WINDOW, CS3-0 ARE 8-BIT
	.FCB WINDEF-CHIP_IO, 0x00	;NO DATA WINDOW, NO PROGRAM WINDOW
	.FCB PPAGE-CHIP_IO,  0x00	;INITIAL PAGE.  SEE ALSO COPY TO REG_PAGE BELOW
	.FCB DPAGE-CHIP_IO,  0x00
	.FCB EPAGE-CHIP_IO,  0x00
	.FCB MXAR-CHIP_IO,   0x00	;A21-A16 USED AS PORT PINS
.endif

.if ADAPT_32K
	.FCB INITRM-CHIP_IO, CHIP_RAM/256	;locate RAM
	.FCB INITEE-CHIP_IO, CHIP_EEPROM/256+1	;locate and enable EEPROM
	.FCB COPCTL-CHIP_IO, 0x00	;DISABLE CLOCK MONITOR, NO COP TIMEOUT
	.FCB INTCR-CHIP_IO,  0x60	;IRQ LEVEL SENSE, IRQ ENABLED, STOP DLY ENABLED
	.FCB PEAR-CHIP_IO,   0x04	;PE4=E, PE2=R/W
	.FCB MODE-CHIP_IO,   0xB8	;NORMAL EXPANDED NARROW, VISIBLE BUS
	.FCB CSCTL0-CHIP_IO, 0x7F	;USE CSP1, CSP0, CSD, CS3, CS2, CS1, AND CS0
	.FCB CSCTL1-CHIP_IO, 0x10	;CSD IS 32K
	.FCB CSSTR0-CHIP_IO, 0x15	;1 WAIT STATE ON ALL MEMORY CHIP SELECTS
	.FCB CSSTR1-CHIP_IO, 0xFF	;3 WAIT STATES ON ALL I/O CHIP SELECTS
	.FCB MISC-CHIP_IO,   0x40	;NO EXTRA WINDOW, CS3-0 ARE 8-BIT
	.FCB WINDEF-CHIP_IO, 0x00	;NO DATA WINDOW, NO PROGRAM WINDOW
	.FCB PPAGE-CHIP_IO,  0x00	;INITIAL PAGE.  SEE ALSO COPY TO REG_PAGE BELOW
	.FCB DPAGE-CHIP_IO,  0x00
	.FCB EPAGE-CHIP_IO,  0x00
	.FCB MXAR-CHIP_IO,   0x00	;A21-A16 USED AS PORT PINS
.endif

.if COMPACT_32K
	.FCB INITRM-CHIP_IO, CHIP_RAM/256	;locate RAM
	.FCB INITEE-CHIP_IO, CHIP_EEPROM/256+1	;locate and enable EEPROM
	.FCB COPCTL-CHIP_IO, 0x00	;DISABLE CLOCK MONITOR, NO COP TIMEOUT
	.FCB INTCR-CHIP_IO,  0x60	;IRQ LEVEL SENSE, IRQ ENABLED, STOP DLY ENABLED
	.FCB PEAR-CHIP_IO,   0x0C	;PE4=E, PE3=LSTRB, PE2=R/W
	.FCB MODE-CHIP_IO,   0xF8	;NORMAL EXPANDED WIDE, VISIBLE BUS
	.FCB CSCTL0-CHIP_IO, 0x7F	;USE CSP1, CSP0, CSD, CS3, CS2, CS1, AND CS0
	.FCB CSCTL1-CHIP_IO, 0x10	;CSD IS 32K
	.FCB CSSTR0-CHIP_IO, 0x15	;1 WAIT STATE ON ALL MEMORY CHIP SELECTS
	.FCB CSSTR1-CHIP_IO, 0xFF	;3 WAIT STATES ON ALL I/O CHIP SELECTS
	.FCB MISC-CHIP_IO,   0x40	;NO EXTRA WINDOW, CS3-0 ARE 8-BIT
	.FCB WINDEF-CHIP_IO, 0x00	;NO DATA WINDOW, NO PROGRAM WINDOW
	.FCB PPAGE-CHIP_IO,  0x00	;INITIAL PAGE.  SEE ALSO COPY TO REG_PAGE BELOW
	.FCB DPAGE-CHIP_IO,  0x00
	.FCB EPAGE-CHIP_IO,  0x00
	.FCB MXAR-CHIP_IO,   0x00	;A21-A16 USED AS PORT PINS
.endif

.if TEMPEST12
	.FCB INITRM-CHIP_IO, CHIP_RAM/256	;locate RAM
	.FCB INITEE-CHIP_IO, CHIP_EEPROM/256+1	;locate and enable EEPROM
	.FCB COPCTL-CHIP_IO, 0x00	;DISABLE CLOCK MONITOR, NO COP TIMEOUT
	.FCB INTCR-CHIP_IO,  0x60	;IRQ LEVEL SENSE, IRQ ENABLED, STOP DLY ENABLED
	.FCB PEAR-CHIP_IO,   0x0C	;PE4=E, PE3=LSTRB, PE2=R/W, ARSIE = general io
	.FCB MODE-CHIP_IO,   0xF0	;NORMAL EXPANDED WIDE,
	.FCB CSCTL0-CHIP_IO, 0x3F	;USE CSP0, CSD, CS3, CS2, CS1, AND CS0
				;CS0 = 0x200 - 0x2FF  = CAN 8Bit(D8-D15)
				;CS1 = 0x300 - 0x37F  = Display must be 16Bit
				;CS2 = 0x380 - 0x3FF  = extern (8 od 16 bit)
				;CS3 = 0x400 - 0x7ff  = extern (8 od 16 bit)
	.FCB CSCTL1-CHIP_IO, 0x18	;CSD IS 32K and cs3 follows extra page
	.FCB CSSTR0-CHIP_IO, 0x00	;0 WAIT STATE ON ALL MEMORY CHIP SELECTS
	.FCB CSSTR1-CHIP_IO, 0x00	;0 WAIT STATES ON ALL I/O CHIP SELECTS
	.FCB MISC-CHIP_IO,   0x40	;puts epage at 0x0400 to 0x07ff and /CS0-/CS3 default 8bit
	.FCB WINDEF-CHIP_IO, 0xE0	;enable programm & data window & extrapage
	.FCB PPAGE-CHIP_IO,  0xFF	;INITIAL PAGE.  SEE ALSO COPY TO REG_PAGE BELOW
	.FCB DPAGE-CHIP_IO,  0x00	;
	.FCB EPAGE-CHIP_IO,  0x01	;
	.FCB MXAR-CHIP_IO,   0x0F	;A21 & A20 are general io
	.FCB PORTG-CHIP_IO,  0x00	;
	.FCB DDRG-CHIP_IO,   0x30	;pin4 & pin5 are outputs (leds)
	.FCB PORTE-CHIP_IO,  0x00	;
	.FCB DDRE-CHIP_IO,   0x80	;Bit7 pE is output (for Peep)
.endif

.if USER_DEFINED
	.ERROR 1			;you had better define some initialization values
.endif
INIT_TABLE_END:		;END OF TABLE
;
;======================================================================
;  Response string for GET TARGET STATUS request
;  Reply describes target:
TSTG:	.FCB	13			;2: PROCESSOR TYPE = 68HC12
	.FCB	COMBUF_SIZE		;3: SIZE OF COMMUNICATIONS BUFFER
	.FCB	0x80			;4: has CALL
	.FDB	0			;5,6: BOTTOM OF PAGED MEM
	.FDB	0			;7,8: TOP OF PAGED MEM
	.FCB	B1-B0			;9 BREAKPOINT INSTR LENGTH
B0:	SWI				;10+ BREKAPOINT INSTRUCTION
B1:	.FCC	'68HC12A4 monitor V3.0 ';DESCRIPTION

.if AXIOM_WIDE_32K
	.FCC	'for Axiom CMD12A4 wide'
.endif

.if AXIOM_NARROW_32K
	.FCC	'for Axiom CMD12A4 narrow'
.endif

.if ADAPT_32K
	.FCC	'for Technological Arts Adapt812DX'
.endif

.if COMPACT_32K
	.FCC	'MCT Lange & Thamm HC12compact'
.endif

.if TEMPEST12
	.FCC	'for HKE Tempest12'
.endif
	.FCB	0

	.FCB	0			;page of CALL breakpoint
	.FDB	B0			;address of CALL breakpoint in native order
TSTG_SIZE	=	.-TSTG		;SIZE OF STRING
;
;===========================================================================
;  Initialize the NoICE UART
;
;  Default implementation uses SCI
INITUART:
;
;  Baud DIV = MCLK / (16 * Baud_Rate)
;  MCLK = crystal / 2
;  With a 16 Mhz crystal, DIV = 8,000,000/(16*Baud_Rate) = 500000/Baud_Rate
;  For 19200 baud, DIV = 26 (actual baud rate = 19231, or +0.16%)
	LDD	#26		;BAUD RATE CONSTANT
	STD	SC0BDH		;WRITE HIGH BYTE, LOW BYTE
	LDAA	#0x00		;NO LOOP, 8-BIT, NO WAKE, NO PARITY
	STAA	SC0CR1
	LDAA	#0x0C		;NO INTS, ENABLE TRANSMIT AND RECEIVE
	STAA	SC0CR2
	RTS
;
;===========================================================================
;  Get a character from UART to A
;
;  Return A=char, CY=0 if data received
;	 CY=1 if timeout (0.5 seconds)
;
;  Uses 6 bytes of stack including return address
;
GETCHAR:
	PSHX
	LDX	#0		;LONG TIMEOUT
GC10:	BSR	REWDT		;PREVENT WATCHDOG TIMEOUT
	DEX
;;;	BEQ	GC90		;EXIT IF TIMEOUT
;(Disable timeout in most cases...)
	BRCLR	SER_STATUS,#RXRDY, GC10 ;NOT READY YET.
;
;  Data received:  return CY=0. data in A
	CLC			;CY=0
	LDAA	SER_RXDATA	;READ DATA
	PULX
	RTS
;
;  Timeout:  return CY=1
GC90:	SEC			;CY=1
	PULX
	RTS
;
;===========================================================================
;  Output character in A to UART
;
;  Uses 5 bytes of stack including return address
;
PUTCHAR:
	PSHA
PC10:	BSR	REWDT		;PREVENT WATCHDOG TIMEOUT
	BRCLR	SER_STATUS, #TXRDY, PC10
	PULA
	STAA	SER_TXDATA	;TRANSMIT CHAR.
	RTS
;
;======================================================================
;  Reset watchdog timer.  Must be called at least once every little while
;  or COP interrupt will occur
;
;  Uses 2 bytes of stack including return address
;
REWDT:	LDAA	#0x55
	STAA	COPRST
	LDAA	#0xAA
	STAA	COPRST
	RTS
;
;======================================================================
;  Power on reset
RESET:
;
;  Set CPU mode to safe state
	SEI			;INTERRUPTS OFF (WE MAY JUMP HERE)
	CLRB			;STATE 0 = "RESET"
	BRA	RES10
;
;------------------------------------------------
;  COP reset
COP_ENT:
	LDAB	#4		;STATE 4 = "COP"
	BRA	RES10
;
;------------------------------------------------
;  Clock Fail reset
CLOCK_ENT:
	LDAB	#3		;STATE 3 = "Clock fail"
;  BE SURE THAT "B" REMAINS INTACT UNTIL IT IS STORED TO REG_STATE BELOW!
RES10:
;
;  CAUTION: DON'T USE I/O ADDRESS EQUATES UNTIL INITRG IS WRITTEN
;  TO SET THE I/O BASE TO MATCH OUR EQUATES!
	LDAA	#CHIP_IO/256
	STAA	0x0011		;POST-RESET LOCATION OF INITRG
;
;  Copy init table to on-chip registers (without using B)
	LDX	#INIT_TABLE
RES15:	LDAA	1,X+		;A=PORT
	LDY	#CHIP_IO
	LEAY	A,Y		;Y POINTS AT PORT
	LDAA	1,X+		;A=DATA
	STAA	0,Y
	STAA	0,Y		;store twice: first may be ignored in SPECIAL mode
	CPX	#INIT_TABLE_END
	BLO	RES15
;
;  Save reset type (RESET, COP, or Clock Fail)
	STAB	REG_STATE	;SAVE STATE
	LDS	#INITSTACK	;Initial stack value
	BSR	INITUART
;
;  Initialize RAM interrupt vectors
	LDY	#INT_ENTRY	;ADDRESS OF DEFAULT HANDLER
	LDX	#RAMVEC		;POINTER TO RAM VECTORS
	LDAB	#NVEC/2		;NUMBER OF VECTORS
RST10:	STY	2,X+		;SET VECTOR
	DBNE	B,RST10
;
;  Initialize user registers
	LDD	#INITSTACK
	STAA	REG_SP+1	;INIT USER'S STACK POINTER MSB
	STAB	REG_SP		;LSB
	CLRA
	CLRB
	STD	REG_PC
	STAA	REG_A
	STAA	REG_B
	STD	REG_X
	STD	REG_Y
;
;  Initialize memory paging variables and hardware
	LDAA	PPAGE
	STAA	REG_PAGE	;PAGE FROM HARDWARE (or zero)
;
;  Initialize non-zero registers
	LDAA	#0x50		;disable interrupts in user program
	STAA	REG_CC
;
;  Set function code for "GO".  Then if we are here because of a reset
;  (such as a COP timeout or clock fail) after being told to GO, we will
;  come back with registers so user can see the reset
	LDAA	#FN_RUN_TARG
	STAA	COMBUF
	JMP	RETURN_REGS	;DUMP REGS, ENTER MONITOR
;
;======================================================================
;  HARDWARE PLATFORM INDEPENDENT EQUATES AND CODE
;
;  Communications function codes.
FN_GET_STAT	=	0xFF	;reply with device info
FN_READ_MEM	=	0xFE	;reply with data
FN_WRITE_M	=	0xFD	;reply with status (+/-)
FN_READ_RG	=	0xFC	;reply with registers
FN_WRITE_RG	=	0xFB	;reply with status
FN_RUN_TARG	=	0xFA	;reply (delayed) with registers
FN_SET_BYTE	=	0xF9	;reply with data (truncate if error)
FN_IN		=	0xF8	;input from port
FN_OUT		=	0xF7	;output to port
;
FN_MIN		=	0xF0	;MINIMUM RECOGNIZED FUNCTION CODE
FN_ERROR	=	0xF0	;error reply to unknown op-code
;
;===========================================================================
;  Common handler for default interrupt handlers
;  Enter with A=interrupt code = processor state
;  All registers stacked, PC=next instruction
INT_ENTRY:
	STAA	REG_STATE	;SAVE STATE
;
;  Save registers from stack to reg block for return to master
;  Host wants least significant bytes first, so flip as necessary
	PULA
	STAA	REG_CC		;CONDITION CODES
	PULA
	STAA	REG_B
	PULA
	STAA	REG_A
	PULD
	STAA	REG_X+1		;MSB
	STAB	REG_X		;LSB
	PULD
	STAA	REG_Y+1		;MSB
	STAB	REG_Y		;LSB
;
;  If this is a breakpoint (state = 1), then back up PC to point at SWI
	PULX			;PC AFTER INTERRUPT
	LDAA	REG_STATE
	CMPA	#1
	BNE	NOTBP		;BR IF NOT A BREAKPOINT
	LEAX	B0-B1,X		;ELSE BACK UP TO POINT AT SWI LOCATION
NOTBP:	TFR	X,D
	STAA	REG_PC+1	;MSB
	STAB	REG_PC		;LSB
	TFR	SP,D		;USER STACK POINTER
	STAA	REG_SP+1	;MSB
	STAB	REG_SP		;LSB
;
;  Save memory page
;  (Could make this conditional on WINDEF PWEN bit: set page 0 if bit clear)
	LDAA	PPAGE		;GET CURRENT USER PAGE
;;;	LDAA	#0		... OR ZERO IF UNPAGED TARGET
	STAA	REG_PAGE	;SAVE USER'S PAGE
;
;  Return registers to master
	JMP	RETURN_REGS
;
;===========================================================================
;  Main loop:  wait for command frame from master
;
;  Uses 7 bytes of stack before jump to handlers
;
MAIN:	LDX	#COMBUF		;BUILD MESSAGE HERE
;
;  First byte is a function code
	JSR	GETCHAR		;GET A FUNCTION
	BCS	MAIN		;JIF TIMEOUT: RESYNC
	CMPA	#FN_MIN
	BLO	MAIN		;JIF BELOW MIN: ILLEGAL FUNCTION
	STAA	1,X+		;SAVE FUNCTION CODE
;
;  Second byte is data byte count (may be zero)
	JSR	GETCHAR		;GET A LENGTH BYTE
	BCS	MAIN		;JIF TIMEOUT: RESYNC
	CMPA	#COMBUF_SIZE
	BHI	MAIN		;JIF TOO LONG: ILLEGAL LENGTH
	STAA	1,X+		;SAVE LENGTH
	BEQ	MA80		;SKIP DATA LOOP IF LENGTH = 0
;
;  Loop for data
	TFR	A,B		;SAVE LENGTH FOR LOOP
MA10:	JSR	GETCHAR		;GET A DATA BYTE
	BCS	MAIN		;JIF TIMEOUT: RESYNC
	STAA	1,X+		;SAVE DATA BYTE
	DBNE	B,MA10
;
;  Get the checksum
MA80:	JSR	GETCHAR		;GET THE CHECKSUM
	BCS	MAIN		;JIF TIMEOUT: RESYNC
	PSHA			;SAVE CHECKSUM
;
;  Compare received checksum to that calculated on received buffer
;  (Sum should be 0)
	JSR	CHECKSUM
	ADDA	1,SP+
	BNE	MAIN		;JIF BAD CHECKSUM
;
;  Process the message.
	LDX	#COMBUF
	LDD	2,X+		;A= FUNCTION CODE, B= LENGTH, X=DATA
	CMPA	#FN_GET_STAT
	BEQ	TARGET_STAT
	CMPA	#FN_READ_MEM
	BEQ	READ_MEM
	CMPA	#FN_WRITE_M
	BEQ	WRITE_MEM
	CMPA	#FN_READ_RG
	LBEQ	READ_REGS
	CMPA	#FN_WRITE_RG
	LBEQ	WRITE_REGS
	CMPA	#FN_RUN_TARG
	LBEQ	RUN_TARGET
	CMPA	#FN_SET_BYTE
	LBEQ	SET_BYTES
	CMPA	#FN_IN
	LBEQ	IN_PORT
	CMPA	#FN_OUT
	LBEQ	OUT_PORT
;
;  Error: unknown function.  Complain
	LDAA	#FN_ERROR
	STAA	COMBUF		;SET FUNCTION AS "ERROR"
	LDAA	#1
	JMP	SEND_STATUS	;VALUE IS "ERROR"

;===========================================================================
;
;  Target Status:  FN, len
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
TARGET_STAT:
	LDY	#TSTG		;DATA FOR REPLY
	LDAB	#TSTG_SIZE	;LENGTH OF REPLY
	STAB	COMBUF+1
TS10:	LDAA	1,Y+		;MOVE REPLY DATA TO BUFFER
	STAA	1,X+
	DBNE	B,TS10
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
	LDAA	0,X
	STAA	PPAGE
;
;  Get address
	LDAA	2,X		;MSB OF ADDRESS IN A
	LDAB	1,X		;LSB OF ADDRESS IN B
	TFR	D,Y		;ADDRESS IN Y
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LDAB	3,X		;NUMBER OF BYTES TO RETURN
	STAB	COMBUF+1	;RETURN LENGTH = REQUESTED DATA
	BEQ	GLP90		;JIF NO BYTES TO GET
;
;  Read the requested bytes from local memory
GLP:	LDAA	1,Y+		;GET BYTE
	STAA	1,X+		;STORE TO RETURN BUFFER
	DBNE	B,GLP
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
	LDAA	0,X
	STAA	PPAGE
;
;  Get address
	LDAA	2,X		;MSB OF ADDRESS IN A
	LDAB	1,X		;LSB OF ADDRESS IN B
	TFR	D,Y		;ADDRESS IN Y
;
;  Prepare return buffer: FN (unchanged), LEN, DATA
	LDAB	COMBUF+1	;NUMBER OF BYTES TO RETURN
	SUBB	#3		;MINUS PAGE AND ADDRESS
	BEQ	WLP50		;JIF NO BYTES TO PUT
;
;  Write the specified bytes to local memory
	PSHB
	PSHX
	PSHY
WLP:	LDAA	3,X		;GET BYTE TO WRITE
	STAA	1,Y+		;STORE THE BYTE AT AAAA,Y
	INX
	DBNE	B,WLP
;
;  Compare to see if the write worked
	PULY
	PULX
	PULB
WLP20:	LDAA	3,X		;GET BYTE JUST WRITTEN
	CMPA	1,Y+
	BNE	WLP80		;BR IF WRITE FAILED
	INX
	DBNE	B,WLP20
;
;  Write succeeded:  return status = 0
WLP50:	CLRA			;RETURN STATUS = 0
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
	LDY	#TASK_REGS	;POINTER TO REGISTERS
	LDAB	#TASK_REG_SZ	;NUMBER OF BYTES
	STAB	COMBUF+1	;SAVE RETURN DATA LENGTH
;
;  Copy the registers
	LDX	#COMBUF+2	;POINTER TO RETURN BUFFER
GRLP:	LDAA	1,Y+		;GET BYTE TO A
	STAA	1,X+		;STORE TO RETURN BUFFER
	DBNE	B,GRLP
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
	TSTB			;NUMBER OF BYTES
	BEQ	WRR80		;JIF NO REGISTERS
;
;  Copy the registers
	LDY	#TASK_REGS	;POINTER TO REGISTERS
WRRLP:	LDAA	1,X+		;GET BYTE TO A
	STAA	1,Y+		;STORE TO REGISTER RAM
	DBNE	B,WRRLP
;
;  Reload SP, in case it has changed
	LDAB	REG_SP
	LDAA	REG_SP+1
	TFR	D,SP
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
	LDAA	REG_PAGE
	STAA	PPAGE
;
;  Switch to user stack, if not already running on it
;;	LDAB	REG_SP		;BACK TO USER STACK
;;	LDAA	REG_SP+1
;;	TFR	D,SP
;
;  Restore registers
	LDAA	REG_PC+1	;MSB USER PC FOR RTI
	LDAB	REG_PC		;LSB
	PSHD
;
	LDAA	REG_Y+1
	LDAB	REG_Y
	PSHD
;
	LDAA	REG_X+1
	LDAB	REG_X
	PSHD
;
	LDAA	REG_A
	PSHA
	LDAA	REG_B
	PSHA
;
	LDAA	REG_CC	 ;SAVE USER CONDITION CODES FOR RTI
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
	LDY	#COMBUF+1	;POINTER TO RETURN BUFFER
	LDAA	#0
	STAA	1,Y+		;SET RETURN COUNT =0, POINT AT FIRST RETURN DATA BYTE
	LSRB
	LSRB			;LEN/4 = NUMBER OF BYTES TO SET
	BEQ	SB99		;JIF NO BYTES (COMBUF+1 = 0)
;
;  Loop on inserting bytes
SB10:	PSHB			;SAVE LOOP COUNTER
	PSHY			;SAVE RETURN BUFFER POINTER
;
;  Set page
	LDAA	0,X
	STAA	PPAGE
;
;  Get address
	LDAA	2,X		;MSB OF ADDRESS IN A
	LDAB	1,X		;LSB OF ADDRESS IN B
	TFR	D,Y		;MEMORY ADDRESS IN Y
;
;  Read current data at byte location
	LDAA	0,Y
;
;  Insert new data at byte location
	LDAB	3,X		;GET BYTE TO STORE
	STAB	0,Y		;WRITE TARGET MEMORY
;
;  Verify write
	CMPB	0,Y		;READ TARGET MEMORY
	PULY			;RESTORE RETURN PTR (CC'S INTACT)
	PULB			;RESTORE LOOP COUNTER (CC'S INTACT)
	BNE	SB90		;BR IF INSERT FAILED: ABORT
;
;  Save target byte in return buffer
	STAA	1,Y+
	INC	COMBUF+1	;COUNT ONE RETURN BYTE
;
;  Loop for next byte
	LEAX	4,X		;STEP TO NEXT BYTE SPECIFIER
	CMPB	COMBUF+1
	BNE	SB10		;LOOP FOR ALL BYTES
;
;  Return buffer with data from byte locations
SB90:
;
;  Compute checksum on buffer, and send to master, then return
SB99:	BRA	SEND

;===========================================================================
;
;  Input from port:  FN, len, PortAddressLo, PAhi (=0)
;
;  While the HC12 has no input or output instructions, we retain these
;  to allow write-without-verify
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
IN_PORT:
;
;  Get port address
	LDAA	1,X		;MSB OF ADDRESS IN A
	LDAB	0,X		;LSB OF ADDRESS IN B
	TFR	D,Y		;MEMORY ADDRESS IN Y
;
;  Read the requested byte from local memory
	LDAA	0,Y
;
;  Return byte read as "status"
	BRA	SEND_STATUS

;===========================================================================
;
;  Output to port:  FN, len, PortAddressLo, PAhi (=0), data
;
;  Entry with A=function code, B=data size, X=COMBUF+2
;
OUT_PORT:
;
;  Get port address
	LDAA	1,X		;MSB OF ADDRESS IN A
	LDAB	0,X		;LSB OF ADDRESS IN B
	TFR	D,Y		;MEMORY ADDRESS IN Y
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
	BRA	SEND_STATUS

;===========================================================================
;  Build status return with value from "A"
;
SEND_STATUS:
	STAA	COMBUF+2	;SET STATUS
	LDAA	#1
	STAA	COMBUF+1	;SET LENGTH
;;	BRA	SEND

;===========================================================================
;  Append checksum to COMBUF and send to master
;
SEND:	BSR	CHECKSUM	;GET A=CHECKSUM, X->checksum location
	NEGA
	STAA	0,X		;STORE NEGATIVE OF CHECKSUM
;
;  Send buffer to master
	LDX	#COMBUF	;POINTER TO DATA
	LDAB	1,X		;LENGTH OF DATA
	ADDB	#3		;PLUS FUNCTION, LENGTH, CHECKSUM
SND10:	LDAA	1,X+
	JSR	PUTCHAR	;SEND A BYTE
	DBNE	B,SND10
;
	JMP	MAIN		;BACK TO MAIN LOOP

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
	LDX	#COMBUF	;pointer to buffer
	LDAB	1,X		;length of message
	ADDB	#2		;plus function, length
	CLRA			;init checksum to 0
CHK10:	ADDA	1,X+
	DBNE	B,CHK10		;loop for all
	RTS			;return with checksum in A

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
IC0_ENTRY:	LDAA	#31		;ffc0
		LDX	RAMVEC+0
		JMP	0,X
IC2_ENTRY:	LDAA	#30		;ffc2
		LDX	RAMVEC+2
		JMP	0,X
IC4_ENTRY:	LDAA	#29		;ffc4
		LDX	RAMVEC+4
		JMP	0,X
IC6_ENTRY:	LDAA	#28		;ffc6
		LDX	RAMVEC+6
		JMP	0,X
IC8_ENTRY:	LDAA	#27		;ffc8
		LDX	RAMVEC+8
		JMP	0,X
ICA_ENTRY:	LDAA	#26		;ffca
		LDX	RAMVEC+0xA
		JMP	0,X
ICC_ENTRY:	LDAA	#25		;ffcc
		LDX	RAMVEC+0xC
		JMP	0,X
ICE_ENTRY:	LDAA	#24		;ffce
		LDX	RAMVEC+0xE
		JMP	0,X
ID0_ENTRY:	LDAA	#23		;ffd0
		LDX	RAMVEC+0x10
		JMP	0,X
ID2_ENTRY:	LDAA	#22		;ffd2 ATD
		LDX	RAMVEC+0x12
		JMP	0,X
ID4_ENTRY:	LDAA	#21		;ffd4 Serial Comm Port 1
		LDX	RAMVEC+0x14
		JMP	0,X
SCI0_ENTRY:	LDAA	#20		;ffd6 Serial Comm Port 0
		LDX	RAMVEC+0x16
		JMP	0,X
SPI_ENTRY:	LDAA	#19		;ffd8 Serial Peripheral Port
		LDX	RAMVEC+0x18
		JMP	0,X
PAIE_ENTRY:	LDAA	#18		;ffda Pulse Accumulator input
		LDX	RAMVEC+0x1A
		JMP	0,X
PAO_ENTRY:	LDAA	#17		;ffdc Pulse Accumulator overflow
		LDX	RAMVEC+0x1C
		JMP	0,X
TOF_ENTRY:	LDAA	#16		;ffde Timer Overflow
		LDX	RAMVEC+0x1E
		JMP	0,X
TC7_ENTRY:	LDAA	#15		;ffe0 Timer Channel 7
		LDX	RAMVEC+0x20
		JMP	0,X
TC6_ENTRY:	LDAA	#14		;ffe2 Timer Channel 6
		LDX	RAMVEC+0x22
		JMP	0,X
TC5_ENTRY:	LDAA	#13		;ffe4 Timer Channel 5
		LDX	RAMVEC+0x24
		JMP	0,X
TC4_ENTRY:	LDAA	#12		;ffe6 Timer Channel 4
		LDX	RAMVEC+0x26
		JMP	0,X
TC3_ENTRY:	LDAA	#11		;ffe8 Timer Channel 3
		LDX	RAMVEC+0x28
		JMP	0,X
TC2_ENTRY:	LDAA	#10		;ffea Timer Channel 2
		LDX	RAMVEC+0x2A
		JMP	0,X
TC1_ENTRY:	LDAA	#9		;ffec Timer Channel 1
		LDX	RAMVEC+0x2C
		JMP	0,X
TC0_ENTRY:	LDAA	#8		;ffee Timer Channel 0
		LDX	RAMVEC+0x2E
		JMP	0,X
RTI_ENTRY:	LDAA	#7		;fff0 Real Time Interrupt
		LDX	RAMVEC+0x30
		JMP	0,X
IRQ_ENT:	LDAA	#6		;fff2
		LDX	RAMVEC+0x32
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
	.area	ROM_START
	.ORG	HARD_VECT
;
;  VECTORS THROUGH RAM
; HC12A4 Interrupt Vectors....
VEC0:	.FDB	IC0_ENTRY	;ffc0
	.FDB	IC2_ENTRY	;ffc2
	.FDB	IC4_ENTRY	;ffc4
	.FDB	IC6_ENTRY	;ffc6
	.FDB	IC8_ENTRY	;ffc8
	.FDB	ICA_ENTRY	;ffca
	.FDB	ICC_ENTRY	;ffcc
	.FDB	ICE_ENTRY	;ffce
	.FDB	ID0_ENTRY	;ffd0
	.FDB	ID2_ENTRY	;ffd2
	.FDB	ID4_ENTRY	;ffd4
	.FDB	SCI0_ENTRY	;ffd6 Serial Comm Port 0
	.FDB	SPI_ENTRY	;ffd8 Serial Peripheral Port
	.FDB	PAIE_ENTRY	;ffda Pulse Accumulator input
	.FDB	PAO_ENTRY	;ffdc Pulse Accumulator overflow
	.FDB	TOF_ENTRY	;ffde Timer Overflow
	.FDB	TC7_ENTRY	;ffe0 Timer Channel 7
	.FDB	TC6_ENTRY	;ffe2 Timer Channel 6
	.FDB	TC5_ENTRY	;ffe4 Timer Channel 5
	.FDB	TC4_ENTRY	;ffe6 Timer Channel 4
	.FDB	TC3_ENTRY	;ffe8 Timer Channel 3
	.FDB	TC2_ENTRY	;ffea Timer Channel 2
	.FDB	TC1_ENTRY	;ffec Timer Channel 1
	.FDB	TC0_ENTRY	;ffee Timer Channel 0
	.FDB	RTI_ENTRY	;fff0 Real Time Interrupt
	.FDB	IRQ_ENT		;fff2
NVEC	=	.-VEC0		;number of vector bytes
;
;  The remaining interrupts are permanently trapped to the monitor
	.FDB	XIRQ_ENTRY	;fff4 (non-maskable interrupt)
	.FDB	SWI_ENTRY	;fff6 SWI/breakpoint
	.FDB	ILLOP_ENT	;fff8 illegal op-code
	.FDB	COP_ENT		;fffa Watchdog timeout
	.FDB	CLOCK_ENT	;fffc clock monitor reset
	.FDB	RESET		;fffe reset
;
	.END	RESET
