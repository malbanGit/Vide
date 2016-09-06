*********************************************************
*                                                       *
*             VECTREX MONITOR Version 1.02              *
*                                                       *
*         1986 (C) Richard Albers & Jeff Lavin          *
*                                                       *
*    Generic monitor program for the 6809 processor     *
*       Designed for debugging Vectrex programs         *
*                                                       *
*********************************************************

* Rev 1.00                       Initial version 12/18/86
* Rev 1.01                       Added .G .R .V  12/28/86
* Rev 1.02                       Added SWI & IRQ 02/04/87

 NAM VECTREX MONITOR VERSION 1.02
 TTL by R. Albers & J. Lavin
 OPT D66
 OPT W80
 OPT M
 OPT E

***  SYSTEM RAM  ***

FRAME EQU $C826
FRMTIM EQU $C83D ;Defaults to 20 msec.

 ORG $C9E2

SUBPTR RMB 2 ;Indirect JSR ptr

TECHO RMB 1 ;Set bit 7 for echo
LSTCOM RMB 1 ;Last command
ADDR RMB 2 ;Last address
CKSM RMB 2 ;Checksum
PSCR RMB 1 ;Scratch

PARMS RMB 1 ;Parameter count
PARM1 RMB 2 ;Command parameters
PARM2 RMB 2
PARM3 RMB 2

CCR RMB 1 ;Register save area
AR RMB 1
BR RMB 1
DPR RMB 1
XR RMB 2
YR RMB 2
SR RMB 2
PCR RMB 2
UR RMB 2

FREE RMB $100

 ORG $CBEA

STACK RMB 1
HISCOR RMB 7

VSWI2 RMB 3 ;SWI3 & SWI2
VFIRQ RMB 3 ;FIRQ
VIRQ RMB 3 ;IRQ
VSWI RMB 3 ;NMI & SWI1

***  ACIA  ***

ACIA EQU $3800 ;6551
DATA EQU ACIA ;Write Transmit/read Recieve
STAT EQU ACIA+1 ;Status reg
COMM EQU ACIA+2 ;Command reg
CONT EQU ACIA+3 ;Control reg

***  VIA  ***

VIA EQU $D000
CNTRL EQU VIA ;ORB
DAC EQU VIA+1 ;ORA
DCNTRL EQU VIA+2 ;DDRB
DDAC EQU VIA+3 ;DDRA
T1LOLC EQU VIA+4 ;Timer 1, counter/latch low
T1HOC EQU VIA+5 ;Timer 1, counter high
T1LOL EQU VIA+6 ;Timer 1, latch low
T1HOL EQU VIA+7 ;Timer 1, latch high
T2LOLC EQU VIA+8 ;Timer 2, counter/latch low
T2HOC EQU VIA+9 ;Timer 2, counter high
SHIFT EQU VIA+10 ;Shift register
ACTR EQU VIA+11 ;Auxiliary ctrl register
PCTR EQU VIA+12 ;Peripheral ctrl reg
IFR EQU VIA+13 ;Interrupt flag reg
IER EQU VIA+14 ;Interrupt enable reg

T1TIMO EQU %01000000 ;Timer 1 interrupt
T2TIMO EQU %00100000 ;Timer 2 interrupt
SETINT EQU %10000000 ;Enable interrupts

***  EXEC EQUATES ***

FRWAIT EQU $F192 ;Wait for frame boundary
DPIO EQU $F1AA ;Set DP=$D0
INT3Q EQU $F2A5 ;Set 3/4 intensity
DEFLOK EQU $F2E6 ;Prevent scan collapse
RSTSIZ EQU $F373 ;Display text string
TXTSIZ EQU $F385 ;Display mult text

***  OTHER EQUATES  ***

CARRY EQU %00000001 ;Processor flags
OVERFL EQU %00000010
ZERO EQU %00000100
INTRPT EQU %00010000
ENTIRE EQU %10000000

CART EQU $0000
RAMST EQU $2000
RAMEND EQU RAMST+$07FF
FFARE1 EQU $FEF8 ;Vectrex resident tune

 ORG CART
 SETDP $D0

 FCB $67 VECTREX ;Text & tune
 FCC ' GCE 1986'
 FCB $80
 FDB FFARE1 ;Address of tune
TITLE FDB $F940 ;Raster size
 FDB $00C8 ;Position, Y:X
 FCC 'VMON  REV 1.02' ;Title
 FCB $80
 FDB $FD30
 FDB $D0B0
 FCB $67 ;Copyright
 FCC ' 1987 R.ALBERS/J.LAVIN'
 FCB $80,0

 SAVER PSHS CC ;Save all regs
 STU UR
 LDU #UR
 PULS CC
 PSHU CC,A,B,DP,X,Y,S,PC

ENTRY JSR INIT
 JMP GETCOM

***  SUBROUTINES  ***

INTCHR LDA #$08 ;Get input char
ILOOK BITA STAT ;Wait for one
 BEQ ILOOK
 LDA DATA
 ANDA #$7F ;Mask bit 7
 TST TECHO ;Echo?
 BMI OUTCHR ;Branch if yes
 RTS

CRLF2 BSR CRLF ;Output 2 newlines
CRLF LDA #$0D ;Print CR + LF
 BSR OUTCHR
 LDA #$0A
 BRA OUTCHR

PROMPT LDA #'V ;Print a prompt
 BSR OUTCHR
 LDA #':
 BRA OUTCHR

OUTQM LDA #'?
 BRA OUTCHR

COMMA LDA #',
 BRA OUTCHR

SPC2 BSR SPACE ;Print 2 spaces
SPACE LDA #$20 ;Print a space

OUTCHR PSHS B ;Print a char
 LDB #$10 ;Wait 'til ACIA ready
OLOOK BITB STAT
 BEQ OLOOK
 STA DATA
 PULS B,PC

INBYTE JSR INTCHR ;Input a hex byte
 BSR ASCNIB
 BCS INB0 ;Branch of not hex
 ASLA ;Move to
 ASLA ; hi nibble
 ASLA
 ASLA
 PSHS A
 JSR INTCHR ;Get next ASCII
 BSR ASCNIB
 BCS INB2 ;Branch if not hex
 ORA ,S+ ;Combine nibbles
 RTS

INB0 CMPA #': ;Want ASCII char?
 BNE INB1
 JMP INTCHR ;Yes, get it

INB1 CMPA #$0D ;CR?
 ORCC #CARRY
 RTS

INB2 LEAS 1,S ;Clean stack
 ORCC #CARRY+OVERFL
 RTS

ASCNIB CMPA #'0 ;Convert ASCII to
 BLO NOTHEX ; binary nibble
 CMPA #'9 ;Numeric?
 BLS CONVN ;Branch if yes
 CMPA #'A ;Hex alpha?
 BLO NOTHEX ;Branch if no
 CMPA #'F
 BLS CONVA ;Branch if yes
 CMPA #'a ;Lowercase?
 BLO NOTHEX ;Branch if no
 CMPA #'f
 BHI NOTHEX ;Branch if no
CONVA SUBA #$07 ;Convert alpha
CONVN ANDA #$0F ;Make hex
 ANDCC #$FF-CARRY
 RTS

NOTHEX ORCC #CARRY
 RTS

OUTADR JSR OUTBYT ;Output ADH
 TFR B,A ;Output ADL
OUTBYT PSHS A ;Output a hex byte
 LSRA
 LSRA
 LSRA
 LSRA
 BSR NIBASC
 JSR OUTCHR
 PULS A
 ANDA #$0F
 BSR NIBASC
 JMP OUTCHR

NIBASC ADDA #$30 ;Convert nibble to ASCII
 CMPA #$39
 BLE NIBA0
 ADDA #$07
NIBA0 RTS

GETPAR BSR ZERPAR ;Get command parameter(s)
GP0 JSR INTCHR ;Get 1st nibble
 JSR ASCNIB ;Convert it
 BCS GP1 ;Branch if not hex
 PSHS A
 LDD PARM1 ;Shift old
 ASLB ; parameter
 ROLA ; nibble(s)
 ASLB ; to left
 ROLA
 ASLB
 ROLA
 ASLB
 ROLA
 ORB ,S+ ;Add in new nibble
 STD PARM1
 LDB PSCR ;PSCR is
 INCB ; one less than
 CMPB PARMS ; parm count
 BEQ GP0 ; after first hex
 STB PARMS ; nibble is input
 BRA GP0

GP1 CMPA #$0D ;End of input?
 BNE GP2
 ANDCC #$FF-CARRY
 RTS

GP2 CMPA #', ;Start next parm?
 BEQ DELIM ;/,/-/ / valid delimiters
 CMPA #'-
 BEQ DELIM
 CMPA #$20
 BNE GP3
DELIM LDD PARM2 ;Yes, move up
 STD PARM3 ; any we
 LDD PARM1 ; now have
 STD PARM2
 CLRA ; and clear for
 CLRB ; next input
 STD PARM1
 INC PARMS ;Count parms
 INC PSCR
 BRA GP0

GP3 ORCC #CARRY ;Non-hex
 RTS

ZERPAR PSHS A,B ;Clear parameter area
 CLRA
 CLRB
 STD PSCR
 STD PARM1
 STD PARM2
 STD PARM3
 PULS A,B,PC

***  ENTRY POINT FOR SWI  ***

SWIENT LDU #YR
 PULS D,X,Y ;CC,A,B,DP,X
 PSHU D,X,Y ;Save in user regs
 PULS D,X,Y ;Y,U,PC
 STS SR
 STX UR
 STX YR
 TFR Y,D ;PC to D
 SUBD #1 ;Backup for .G command
 STD PCR
 ANDCC #$FF-ENTIRE ;Clear [E] & fall thru

***  GET COMMAND ROUTINE  ***

GETCOM JSR CRLF ;Get a command
 JSR PROMPT ;Print "V:"
 JSR INTCHR ; from user
 CMPA #$0D ;CR ?
 BEQ GETCOM
 CMPA #'a
 BLE GET1
 SUBA #$20 ;Make uppercase
GET1 TFR A,B ;Save [A]
 JSR SPACE
 TFR B,A
 STA LSTCOM ;Save
 CMPA #'M ;Memory exam?
 BEQ MEMX
 CMPA #'G ;Go?
 BEQ GOX
 CMPA #'R ;Register exam?
 LBEQ RGX
 CMPA #'V ;Verify?
 LBEQ VRX
 BNE GETCOM ;Invalid, ignore

***  EXECUTE BLOCKS START HERE  ***

***  MEMORY EXAMINE / MODIFY  ***

MEMX JSR GETPAR ;Get any parms
 BCS MEMRET ;Non-hex parm, exit
 LDB PARMS
 BEQ MEMZP ;No parms, use last addr
 DECB
 BEQ MEMP1 ;1 parm, new addr
MEMRET BRA GETCOM ;Return

MEMP1 LDX PARM1 ;Get new address
MEMRS STX ADDR ;Save address
MEMZP LDX ADDR
MEMLP JSR CRLF
 TFR X,D ;Print Address
 JSR OUTADR
 JSR COMMA
 LDA ,X ;Get address contents
 JSR OUTBYT ;Print it
 JSR COMMA
 JSR INBYTE ;Hex or M's command?
 BCS MCOM ;Branch if non-hex
MEMST STA ,X+ ;Store new hex
 CMPA -1,X ;Did it take?
 BEQ MEMRS ;Yes, do next
 JSR OUTQM ;No, show it
 BRA MEMRS

MCOM BVS MEMLP ;2nd nibble non-hex
 CMPA #$0D ;Exit?
 BEQ MEMRET ;Yes, else fall thru

MC0 CMPA #'< ;Back-up one?
 BNE MC1
 LEAX -1,X
 BRA MEMRS
MC1 CMPA #'- ;Back-up 16?
 BNE MC2
 LEAX -16,X
 BRA MEMRS
MC2 CMPA #'+ ;Forward 16?
 BNE MC3
 LEAX 16,X
 BRA MEMRS
MC3 CMPA #'! ;"OR" char with $80?
 BNE MC4
 JSR INTCHR ;Get char
 ORA #$80  ;Set bit 7
 BRA MEMST ; & store it
MC4 LEAX 1,X ;Else, next address
 BRA MEMRS

***  GO TO SUBROUTINE  ***

GOX JSR GETPAR ;Get any parms
 BCS GORET ;Non-hex, exit
 JSR CRLF
 LDB PARMS ;Only 0 or 1
 BEQ GOPZ ;0 parms, use PC
 DECB
 BEQ GOP1 ;1 parm, use new addr
GORET JMP GETCOM
GOP1 LDD PARM1 ;Get addr
 STD PCR ;New destination
GOPZ LDD #SAVER ;Return addr
 LDS SR ;Initialize stack
 PSHS D ;Put return addr on stack
 LDX PCR ;Use existing addr
 LDD UR ;Save
 LDU #CCR ;Point to reg save area
 PSHS D,X ;Push PC,U
 PULU CC,D,DP,X,Y ;Get regs
 PULS U,PC ; and go

***  REGISTER EXAMINE / MODIFY  ***

RGX LDY #RGNAM
 LDX #CCR
NXTREG JSR CRLF
 LDA ,Y+
 JSR OUTCHR ;1st char of name
 LDA ,Y+
 STA PSCR ;Save sign
 ANDA #$7F ;Clr for term
 JSR OUTCHR ;2nd char of name
 JSR SPACE
 LDA ,X+
 JSR OUTBYT ;1st byte of reg
 TST PSCR ;8 or 16 bit
 BPL SBRG ;Branch if 8
 LDA ,X+
 JSR OUTBYT ;2nd byte of reg
SBRG JSR COMMA
 JSR INBYTE ;Get 1st replacement
 BCS RGCHK ;Branch if not hex
 TST PSCR ;8 or 16 bit
 BMI DBRG ;Branch if 16
 STA -1,X ;Store in reg
 BRA XRCHK ;Get next
DBRG STA PSCR ;Save hi-byte
 JSR INBYTE ;Get 2nd replacement
 BCS RGCHK ;Branch if not hex
 TFR A,B ;Xfer to lo
 LDA PSCR ;Get hi back
 STD -2,X ;Store in reg
XRCHK CMPX #UR+2 ;Reached end?
 BHS RGX ;Yes, reset
 BLO NXTREG ;No, get next

RGCHK LBEQ GETCOM ;Return if CR
 BNE XRCHK ;If anything else

RGNAM FCC 'CC'
 FCC ' A'
 FCC ' B'
 FCC 'DP'
 FCS ' X' ;+$80
 FCS ' Y' ;+$80
 FCS ' S' ;+$80
 FCS 'PC' ;+$80
 FCS ' U' ;+$80

***  VERIFY MEMORY  ***

VRX CLR CKSM ;Zero checksum
 CLR CKSM+1
 JSR GETPAR ;Get any parms
 BCS VERET ;Non-hex parm, exit
 LDB PARMS
 BEQ VERZP ;No parms, use last address
 CMPB #1
 BEQ VERP1 ;1 parm, new address
 CMPB #2
 BEQ VERP2 ;2 parms: SA-EA
VERET LBRA GETCOM

VERP2 LDX PARM2 ;Get start address
 PSHS X
 LDX PARM1 ;Get end address
 STX PARM2
 PULS X
 BRA VERRS
VERP1 LDX PARM1 ;Get new address
VERRS STX ADDR ;Save address
VERZP LDX ADDR
 TFR X,D
 ADDD #$000F
 STD PARM3 ;End of line
 JSR CRLF
 TFR X,D ;Print address
 JSR OUTADR
VERNXT JSR SPACE
 LDA ,X+ ;Get address contents
 PSHS A ;Save byte
 JSR OUTBYT ;Print it
 PULS A
 TFR A,B ;Move to lo-nibble
 CLRA ;Clear hi-nibble
 ADDD CKSM ;Add to existing
 STD CKSM ; and store
 LDA PARMS
 CMPA #2 ;If 1 parm
 BNE VER1P ; check line only
 CMPX PARM2 ;At end of block?
 BHI VCHKSM ;Yes, print checksum
VER1P CMPX PARM3 ;At end of line?
 BLS VERNXT ;No, do next byte
 CMPA #2 ;2 parms?
 BEQ VERRS ;Yes do next line

VCHKSM JSR CRLF
 JSR SPACE
 LDD CKSM
 JSR OUTADR ;Print 16 bit checksum
 BRA VERET

***  INITIALIZATION  ***

INIT LDA #$1E ;Initialize ACIA
 STA STAT ;Reset
 STA CONT ;9600 baud
 LDA #$8B ;8-N-1
 STA COMM

 LDA #$80
 STA TECHO ;Setup for echo

 LDA #$7E ;JMP
 STA VSWI
 STA VIRQ
 LDD #SWIENT ;Setup SWI service
 STD VSWI+1
 LDD #IRQSRV ;Setup IRQ service
 STD VIRQ+1

 LDD #DSPTTL ;Set pointer
 STD SUBPTR

 LDA #SETINT+T2TIMO
 STA IER ;Enable TIMER2 only
 ANDCC #$FF-INTRPT ;Enable interrupts
 RTS

DSPTTL JSR INT3Q ;3/4 intensity
 LDU #TITLE ;Set pointer
 JSR TXTSIZ ;Display title
 RTS

*** IRQ SERVICE ROUTINE ***

 SETDP $D0

IRQSRV JSR DPIO
 LDA #T2TIMO ;Check if interrupt
 BITA IER ; came from TIMR2
 BEQ IRQRET ;If not, exit
 JSR DEFLOK ;Overcome scan collapse
 LDX FRAME-1
 LEAX -1,X
 STX FRAME-1
 LDD FRMTIM
 STD T2LOLC
 JSR [SUBPTR]
IRQRET RTI

VEND EQU *-1
 END
