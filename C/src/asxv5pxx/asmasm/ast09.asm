	.title	assist09 - mc6809 monitor

	.module	assist09

	.radix	d

	;*  Modification date:  November 23, 1988

	;********************************************************
	;*  miscelaneous	equates
	;********************************************************

dftchp	=	0		; default character pad count
dftnlp	=	0		; default new line pad count
prompt	=	'>		; prompt character
numbkp	=	8		; number of breakpoints

eot	=	0x04		; end of transmission
bell	=	0x07		; bell character
lf	=	0x0a		; line feed
cr	=	0x0d		; carriage return
can	=	0x18		; cancel (ctl-x)

	.page
	.sbttl	SWI Functions

	;********************************************************
	;* assist09 monitor swi functions
	;*
	;*  the following equates define functions provided
	;*  by the assist09 monitor via the swi instruction.
	;********************************************************

inchnp	=	0		; input char in a reg - no parity
outch	=	1		; output char from a reg
pdata1	=	2		; output string
pdata	=	3		; output cr/lf then string
out2hs	=	4		; output two hex and space
out4hs	=	5		; output four hex and space
pcrlf	=	6		; output cr/lf
space	=	7		; output a space
monitr	=	8		; enter assist09 monitor
vctrsw	=	9		; vector examine/switch
brkpt	=	10		; user program breakpoint
pause	=	11		; task pause function
numfun	=	11		; number of available functions

	;* sub-codes for accessing the vector table.
	;* they are equivalent to offsets in the table.
	;* relative positioning must be maintained.

.avtbl	=	0		; address of vector table
.cmdl1	=	2		; first command list
.rsvd	=	4		; reserved hardware vector
.swi3	=	6		; swi3 routine
.swi2	=	8		; swi2 routine
.firq	=	10		; firq routine
.irq	=	12		; irq routine
.swi	=	14		; swi routine
.nmi	=	16		; nmi routine
.reset	=	18		; reset routine
.cion	=	20		; console on
.cidta	=	22		; console input data
.cioff	=	24		; console input off
.coon	=	26		; console output on
.codta	=	28		; console output data
.cooff	=	30		; console output off
.hsdta	=	32		; high speed printdata
.bson	=	34		; punch/load on
.bsdta	=	36		; punch/load data
.bsoff	=	38		; punch/load off
.pause	=	40		; task pause routine
.expan	=	42		; expression analyzer
.cmdl2	=	44		; second command list
.pad	=	46		; character pad and new line pad
.echo	=	48		; echo/load and null bkpt flag

numvtr	=	48/2+1		; number of vectors
hivtr	=	48		; highest vector offset

	.page
	.sbttl	Work Area

	;********************************************************
	;* work area
	;*
	;*  The direct page register during most routine
	;*  operations will point to this work area.  the Stack
	;*  initially starts under the reserved work areas as
	;*  defined herein.
	;********************************************************

	.area	WORKPG	(ABS,OVR)
	.setdp	0

workpg:				; beginning of work aera

.blkb	0d256-(endpg-astack)	; stack space

astack:				; top of assist09 stack
tstack:	.blkb	0d21		; temporary stack hold
delim:	.blkb	1		; expression delimiter/work byte
misflg:	.blkb	1		; load cmd/thru breakpoint flag
swicnt:	.blkb	1		; trace "swi" nest level count
pcnter:	.blkb	2		; last program counter
pstack:	.blkb	2		; command recovery stack
rstack:	.blkb	2		; reset stack pointer
anumber:.blkb	2		; binary build area
basepg:	.blkb	1		; base page value
addr:	.blkb	2		; address pointer value
window:	.blkb	2		; window
bkptop:	.blkb	0x10		; breakpoint opcode table
bkptbl:	.blkb	0x10		; breakpoint table
vectab:	.blkb	0x32		; vector table
bkptct:	.blkb	1		; breakpoint count
swibfl:	.blkb	1		; bypass swi as breakpoint flag
pauser:	.blkb	4		; pause routine
endpg:

	.page
	.sbttl	Assist09 Code

	.area	ASSIST09 (ABS,OVR)

	;********************************************************
	;* bldvtr - build assist09 vector table
	;*
	;*  hardware reset calls this subroutine to build the
	;*  assist09 vector table.
	;*
	;*  input: s->valid stack ram
	;*  output: u->vector table address
	;*         dpr->assist09 work area page
	;*         the vector table and defaults are initialized
	;*
	;*  all registers volatile
	;********************************************************

bldvtr:	leax	vectab,pcr	; address vector table
	tfr	x,d		; obtain base page address
	tfr	a,dp		; setup dpr
	sta	*basepg		; store for quick reference
	leau	,x		; return table to caller
	stu	,x++		; and init vector table address
	ldb	#numvtr-3	; number relocatable vectors
	pshs	b		; store index on stack
	leay	initvt,pcr	; load from addr
1$:	tfr	y,d		; prepare address resolve
	addd	,y++		; to absolute address
	std	,x++		; into vector table
	dec	,s		; count down
	bne	1$		; branch if more to insert
	ldb	#intve-intvs	; static value init length
2$:	lda	,y+		; load next byte
	sta	,x+		; store into position
	decb			; count down
	bne	2$		; loop until done
	puls	pc,b		; return to initializer

	;********************************************************
	;* reset entry point
	;*
	;*  hardware reset enters here if assist09 is enabled
	;*  to receive the mc6809 hardware vectors.  we call
	;*  the bldvtr subroutine to initialize the vector
	;*  table, stack, and then fireup the monitor via swi
	;*  call.
	;********************************************************

reset:	leas	astack,pcr	; setup initial stack
	bsr	bldvtr		; build vector table
1$:	clra			; issue startup message
	tfr	a,dp		; default to page zero
	swi			; perform monitor fireup
	.byte	monitr		; to enter command processing
	bra	1$		; reenter monitor if 'continue'

	.page
	.sbttl	Vector Table

	;********************************************************
	;* initvt - initialize vector table
	;*
	;*  this table is relocated to ram and represents the
	;*  initial state of the vector table. all addresses
	;*  are converted to absolute form.  this table starts
	;*  with the second entry, ends with static constant
	;*  initialization data which carries beyond the table.
	;********************************************************

initvt:	.word	cmdtb1-.	; default first command table
	.word	rsrvdr-.	; default undefined hardware vector
	.word	swi3r-.		; default swi3
	.word	swi2r-.		; default swi2
	.word	firqr-.		; default firq
	.word	irqr-.		; default irq routine
	.word	swir-.		; default swi routine
	.word	nmir-.		; default nmi routine
	.word	reset-.		; restart vector
	.word	cion-.		; default cion
	.word	cidta-.		; default cidta
	.word	cioff-.		; default cioff
	.word	coon-.		; default coon
	.word	codta-.		; default codta
	.word	cooff-.		; default cooff
	.word	hsdta-.		; default hsdta
	.word	bson-.		; default bson
	.word	bsdta-.		; default bsdta
	.word	bsoff-.		; default bsoff
	.word	cpause-.	; default pause routine
	.word	exp1-.		; default expression analyzer
	.word	cmdtb2-.	; default second command table

	;* constants
	;*
intvs:	.byte	dftchp,dftnlp	; default null padds
	.word	0		; default echo
	.byte	0		; initial breakpoint count
	.byte	0		; swi breakpoint level
	rts			; default pause routine
intve	=	.

	.page
	.sbttl	SWI Handler

	;********************************************************
	;* assist09 swi handler
	;*
	;*  the swi handler provides all interfacing necessary
	;*  for a user program.  a function byte is assumed to
	;*  follow the swi instruction.  it is bound checked
	;*  and the proper routine is given control.  this
	;*  invocation may also be a breakpoint interrupt.
	;*  if so, the breakpoint handler is entered.
	;*
	;* input: machine state defined for swi
	;* output: varies according to function called. pc on
	;*
	;*     callers stack incremented by one if valid call.
	;* volatile registers: see functions called
	;*
	;* state: runs disabled unless function clears i flag.
	;********************************************************

	;* swi function vector table

swivtb:	.word	 zinch-swivtb	; inchnp
	.word	zotch1-swivtb	; outch
	.word	zpdta1-swivtb	; pdata1
	.word	zpdata-swivtb	; pdata
	.word	zot2hs-swivtb	; out2hs
	.word	zot4hs-swivtb	; out4hs
	.word	zpcrlf-swivtb	; pcrlf
	.word	zspace-swivtb	; space
	.word	zmontr-swivtb	; monitr
	.word	zvswth-swivtb	; vctrsw
	.word	zbkpnt-swivtb	; breakpoint
	.word	zpause-swivtb	; task pause

swir:	dec	swicnt,pcr	; up "swi" level for trace
	lbsr	lddp		; setup page and verify stack

	;* check for breakpoint trap

	ldu	10,s		; load program counter
	leau	-1,u		; back to swi address
	tst	*swibfl		; this "swi" breakpoint ?
	bne	2$		; no - branch to let through
	lbsr	cbkldr		; obtain breakpoint pointers
	negb			; obtain positive count
1$:	decb			; count down
	bmi	2$		; branch when done
	cmpu	,y++		; ?  was this a breakpoint
	bne	1$		; branch if not
	stu	10,s		; set program counter back
	lbra	zbkpnt		; go do breakpoint

2$:	clr	*swibfl		; clear in case set
	pulu	d		; obtain function byte, up pc
	cmpb	#numfun		; ? too high
	lbhi	error		; yes, do breakpoint
	stu	10,s		; bump program counter past swi
	aslb			; function code times two
	leau	swivtb,pcr	; obtain vector branch address
	ldd	b,u		; load offset
	jmp	d,u		; jump to routine

	.page
	.sbttl	Monitor Entry

	;********************************************************
	;* registers to function routines:
	;*  dp-> work area page
	;*  d,y,u=unreliable           x=as called from user
	;*  s=as from swi interrupt
	;********************************************************

	;********************************************************
	;* [swi function 8]
	;*  monitor entry
	;*
	;*  fireup the assist09 monitor.
	;*  the stack with its values for the direct page
	;*  register and condition code flags are used as is.
	;*   1) initialize console i/o
	;*   2) optionally print signon
	;*   3) enter command processor
	;*
	;* input: a=0 init console and print startup message
	;*        a#0 omit console init and startup message
	;********************************************************

signon:	.ascii	/Assist09 -- 6809 Monitor/	; signon eye-catcher
	.byte	eot

zmontr:	sts	*rstack		; save for bad stack recovery
	tst	1,s		; ? init console and send msg
	bne	1$		; branch if not
	jsr [vectab+.cion,pcr]	; ready console input
	jsr [vectab+.coon,pcr]	; ready console output
	leax	signon,pcr	; ready signon eye-catcher
	swi			; perform
	.byte	pdata		; print string
1$:				; fall through to cmd

	.page
	.sbttl	Command Processor

	;********************************************************
	;* command handler
	;*
	;*  breakpoints are removed at this time.
	;*  prompt for a command, and store all characters
	;*  until a separator on the stack.
	;*  search for first matching command subset,
	;*  call it or give '?' response.
	;*
	;*  during command search:
	;*      b=offset to next entry on x
	;*      u=saved s
	;*      u-1=entry size+2
	;*      u-2=valid number flag (>=0 valid)/compare cnt
	;*      u-3=carriage return flag (0=cr has been done)
	;*      u-4=start of command store
	;*      s+0=end of command store
	;********************************************************

	;********************************************************
	;* commands are entered as a subroutine with:
	;*    dpr->assist09 direct page work area
	;*    z=1 carriage return entered
	;*    z=0 non carriage return delimiter
	;*    s=normal return address
	;*
	;*  the label "cmdbad" may be entered to issue an
	;*  an error flag (?).
	;********************************************************

cmd:	swi			; to new line
	.byte	pcrlf		; function

	;* disarm the breakpoints

cmdnep:	lbsr	cbkldr		; obtain breakpoint pointers
	bpl	2$		; branch if not armed or none
	negb			; make positive
	stb	*bkptct		; flag as disarmed
1$:	decb			; ?  finished
	bmi	2$		; branch if so
	lda	-numbkp*2,y	; load opcode stored
	sta	[,y++]		; store back over "swi"
	bra	1$		; loop until done
2$:	ldx	10,s		; load users program counter
	stx	*pcnter		; save for expression analyzer
	lda	#prompt		; load prompt character
	swi			; send to output handler
	.byte	outch		; function
	leau	,s		; remember stack restore address
	stu	*pstack		; remember stack for error use
	clra			; prepare zero
	clrb			; prepare zero
	std	*anumber	; clear number build area
	std	*misflg		; clear miscel. and swicnt flags
	ldb	#2 		; set d to two
	pshs	d,cc		; place defaults onto stack

	;* check for "quick" commands.

	lbsr	read		; obtain first character
	leax	cmpadp+2,pcr	; ready memory entry point
	cmpa	#'/		; open last used memory ?
	beq	11$		; yes - doit

	;* process next character

3$:	cmpa	#' 		; ? blank or delimiter
	bls	5$		; branch yes, we have it
	pshs	a		; build onto stack
	inc	-1,u		; count this character
	cmpa	#'/		; ? memory command
	beq	12$		; branch if so
	lbsr	bldhxc		; treat as hex value
	beq	4$		; branch if still valid number
	dec	-2,u		; flag as invalid number
4$:	lbsr	read		; obtain next character
	bra	3$		; test next character

	;* got command, now search tables

5$:	suba	#cr		; set zero if carriage return
	sta	-3,u		; setup flag
	ldx	*vectab+.cmdl1	; start with first cmd list
6$:	ldb	,x+		; load entry length
	bpl	7$		; branch if not list end
	ldx	*vectab+.cmdl2	; now to second cmd list
	incb			; ? to continue to default list
	beq	6$		; branch if so
cmdbad=.
	lds	*pstack		; restore stack
	leax	errmsg,pcr	; point to error string
	swi			; send out
	.byte	pdata1		; to console
	bra	cmd		; and try again

	;* search next entry

7$:	decb			; take account of length byte
	cmpb	-1,u		; ? entered longer than entry
	bhs	9$		; branch if not too long
8$:	abx			; skip to next entry
	bra	6$		; and try next
9$:	leay	-3,u		; prepare to compare
	lda	-1,u		; load size+2
	suba	#2		; to actual size entered
	sta	-2,u		; save size for countdown
10$:	decb			; down one byte
	lda	,x+		; next command character
	cmpa	,-y		; ? same as that entered
	bne	8$		; branch to flush  if not
	dec	-2,u		; count down length of entry
	bne	10$		; branch if more to test
	abx			; to next entry
	ldd	-2,x		; load offset
	leax	d,x		; compute routine address+2
11$:	tst	-3,u		; set cc for carriage return test
	leas	,u		; delete stack work area
	jsr	-2,x		; call command
	lbra	2$		; go get next command
12$:	tst	-2,u		; ? valid hex number entered
	bmi	cmdbad		; branch error if not
	leax	cmemn-cmpadp,x	; to different entry
	ldd	*anumber	; load number entered
	bra	11$		; and enter memory command

	.page
	.sbttl	assist09 Command Tables

	;********************************************************
	;* assist09 command tables
	;*
	;*  these are the default command tables.  external
	;*  tables of the same format may extend/replace
	;*  these by using the vector swap function.
	;*
	;* entry format:
	;*     +0...total size of entry (including this byte)
	;*     +1...command string
	;*     +n...two byte offset to command (entryaddr-.)
	;*
	;*  the tables terminate with a one byte -1 or -2.
	;*  the -1 continues the command search with the
	;*         second command table.
	;*  the -2 terminates command searches.
	;********************************************************

	;* this is the default list for the second command
	;* list entry.

cmdtb2:	.byte	-2		; stop command searches

	;* this is the default list for the first command
	;* list entry.

cmdtb1:				; monitor command table
	.byte	4
	.ascii	/B/		; 'breakpoint' command
	.word	cbkpt-.
	.byte	4
	.ascii	/C/		; 'call' command
	.word	ccall-.
	.byte	4
	.ascii	/D/		; 'display' command
	.word	cdi-.
	.byte	4
	.ascii	/E/		; 'encode' command
	.word	cencde-.
	.byte	4
	.ascii	/G/		; 'go' command
	.word	cgo-.
	.byte	4
	.ascii	/L/		; 'load' command
	.word	cload-.
	.byte	4
	.ascii	/M/		; 'memory' command
	.word	cmem-.
	.byte	4
	.ascii	/N/		; 'nulls' command
	.word	cnulls-.
	.byte	4
	.ascii	/O/		; 'offset' command
	.word	coffs-.
	.byte	4
	.ascii	/P/		; 'punch' command
	.word	cpunch-.
	.byte	4
	.ascii	/R/		; 'registers' command
	.word	creg-.
	.byte	4
	.ascii	/V/		; 'verify' command
	.word	cver-.
	.byte	4
	.ascii	/W/		; 'window' command
	.word	cwindo-.
	.byte	-1		; end, continue with the second

	.page
	.sbttl	SWI Functions

	;********************************************************
	;* [swi functions 4 and 5]
	;*
	;*  4 - out2hs - decode byte to hex and add space
	;*  5 - out4hs - decode word to hex and add space
	;*
	;*  input: x->byte or word to decode
	;*  output: characters sent to output handler
	;*         x->next byte or word
	;********************************************************

zout2h:	lda	,x+		; load next byte
	pshs	d		; save - do not reread
	ldb	#16		; shift by 4 bits
	mul			; with multiply
	bsr	zouthx		; send out as hex
	puls	d		; restore bytes
	anda	#0x0f		; isolate right hex
zouthx:	adda	#0x90		; prepare a-f adjust
	daa			; adjust
	adca	#0x40		; prepare character bits
	daa 			; adjust
send:	jmp [vectab+.codta,pcr]	; send to out handler

zot4hs:	bsr	zout2h		; convert first byte
zot2hs:	bsr	zout2h		; convert byte to hex
	stx	4,s		; update users x register

	;* fall into space routine

	;********************************************************
	;* [swi function 7]
	;*  ace - send blank to output handler
	;*
	;*  input: none
	;*  output: blank send to console handler
	;********************************************************

zspace:	lda	#' 		; load blank
	bra	zotch2		; send and return
  	
	;********************************************************
	;* [swi function 9]
	;*  swap vector table entry
	;*
	;*  input:  a=vector table code (offset)
	;*          x=0 or replacement value
	;*  output: x=previous value
	;********************************************************

zvswth:	lda	1,s		; load requesters a
	cmpa	#hivtr		; ? sub-code too high
	bhi	zotch3		; ignore call if so
	ldy	*vectab+.avtbl	; load vector table address
	ldu	a,y		; u=old entry
	stu	4,s		; return old value to callers x
	stx	-2,s		; ? x=0
	beq	zotch3		; yes, do not change entry
	stx	a,y		; replace entry
	bra	zotch3		; return from swi

	.page

	;********************************************************
	;* [swi function 0]
	;*  inchnp - obtain input char in a (no parity)
	;*
	;*  nulls and rubouts are ignored.
	;*  automatic line feed is sent upon recieving a
	;*      carriage return.
	;*  unless we are loading from tape.
	;********************************************************

zinchp:	bsr	xqpaus		; release processor
zinch:	bsr	xqcidt		; call input data appendage
	bcc	zinchp		; loop if none available
	tsta 			; test for null
	beq	zinch		; ignore null
	cmpa	#0x7f		; ? rubout
	beq	zinch		; branch yes to ignore
	sta	1,s		; store into callers a
	tst	*misflg		; ? load in progress
	bne	zotch3		; branch if so to not echo
	cmpa	#cr		; ? carriage return
	bne	1$		; no, test echo byte
	lda	#lf		; load line feed
	bsr	send		; always echo line feed
1$:	tst	*vectab+.echo	; ? echo desired
	bne	zotch3		; no, return

	;* fall through to outch

	;********************************************************
	;* [swi function 1]
	;*  outch - output character from a
	;*
	;*  input:  none
	;*  output: if linefeed is the output character then
	;*           c=0 no ctl-x recieved, c=1 ctl-x recieved
	;********************************************************

zotch1:	lda	1,s		; load character to send
	leax	zpcrls,pcr	; default for line feed
	cmpa	#lf		; ? line feed
	beq	zpdtlp		; branch to check pause if so
zotch2:	bsr	send		; send to output routine
zotch3:	inc	*swicnt		; bump up "swi" trace nest level
	rti			; return from "swi" function

	;********************************************************
	;* [swi function 6]
	;*  pcrlf - send cr/lf to console handler
	;*
	;*  input: none
	;*  output: cr and lf sent to handler
	;*          c=0 no ctl-x, c=1 ctl-x recieved
	;********************************************************

zpcrls:	.byte	eot		; null string

zpcrlf:	leax	zpcrls,pcr	; ready cr,lf string

	;* fall into cr/lf code

	;********************************************************
	;* [swi function 3]
	;*  pdata - output cr/lf and string
	;*
	;*  input: x->string
	;*  output: cr/lf and string sent to output console
	;*         handler.
	;*     c=0 no ctl-x, c=1 ctl-x recieved
	;*
	;*  note: line feed must follow carriage return for
	;*       proper punch data.
	;********************************************************

zpdata:	lda	#cr		; load carriage return
	bsr	send		; send it
	lda	#lf		; load line feed

	;* fall into	pdata1

	;********************************************************
	;* [swi function 2]
	;*  pdata1 - output string till eot (0x04)
	;*
	;*  this routine pauses if an input byte becomes
	;*  available during output transmission until a
	;*  second is recieved.
	;*
	;*  input: x->string
	;*  output: string sent to output console driver
	;*         c=0 no ctl-x, c=1 ctl-x recieved
	;********************************************************

zpdtlp:	bsr	send		; send character to driver
zpdta1:	lda	,x+		; load next character
	cmpa	#eot		; ? eot
	bne	zpdtlp		; loop if not

	;* fall into pause check function

	;********************************************************
	;* [swi function 12]
	;*  pause - return to task dispatching and check
	;*
	;*  for freeze condition or ctl-x break
	;*  this function enters the task pause handler so
	;*  optionally other 6809 processes may gain control.
	;*  upon return, check for a 'freeze' condition
	;*  with a resulting wait loop, or condition code
	;*  return if a control-x is entered from the input
	;*  handler.
	;*
	;*  output: c=1 if ctl-x has entered, c=0 otherwise
	;********************************************************

zpause:	bsr	xqpaus		; release control at every line
	bsr	chkabt		; check for freeze or abort
	tfr	cc,b		; prepare to replace cc
	stb	,s		; overlay old one on stack
	bra	zotch3		; return from "swi"

	;* chkabt - scan for input pause/abort during output
	;* output: c=0 ok, c=1 abort (ctl-x issued)
	;* volatile: u,x,d

chkabt:	bsr	xqcidt		; attempt input
	bcc	2$		; branch no to return
	cmpa	#can		; ? ctl-x for abort
	bne	3$		; branch no to pause
1$:	comb			; set carry
2$:	rts			; return to caller with cc set

3$:	bsr	xqpaus		; pause for a moment
	bsr	xqcidt		; ? key for start
	bcc	3$		; loop until recieved
	cmpa	#can		; ? abort signaled from wait
	beq	1$		; branch yes
	clra			; set c=0 for no abort
	rts			; and return

	;* save memory with jumps

xqpaus:	jmp [vectab+.pause,pcr]	; to pause routine
xqcidt:	jsr [vectab+.cidta,pcr]	; to input routine
	anda	#0x7f		; strip parity
	rts			; return to caller


	;* lddp - setup direct page register, verify stack.
	;* an invalid stack causes a return to the command
	;* handler.
	;* input: fully stacked registers from an interrupt
	;* output: dpr loaded to work page

errmsg:	.byte	'?,bell,0x20,eot ; error response

ldrtn:	rts
lddp:	ldb	basepg,pcr	; load direct page high byte
	tfr	b,dp		; setup direct page register
	cmpa	3,s		; ? is stack valid
	beq	ldrtn		; yes, return
	lds	*rstack		; reset to initial stack pointer
error:	leax	errmsg,pcr	; load error report
	swi			; send out before registers
	.byte	pdata		; on next line

	;* fall into breakpoint handler

	;********************************************************
	;* [swi function 10]
	;*  breakpoint program function
	;*
	;*  print registers and go to command handler
	;********************************************************

zbkpnt:	bsr	zbkstk		; stack an extra word
zbkcmd:	lbra	cmdnep		; now enter command handler
zbkstk:	lbsr	regprt		; print out registers
	rts

	;********************************************************
	;*    irq, reserved, swi2 and swi3 interrupt handlers
	;*  the default handling is to cause a breakpoint.
	;********************************************************

swi2r:				; swi2 entry
swi3r:				; swi3 entry
irqr:				; irq entry
nmir:				; nmi entry
rsrvdr:	bsr	lddp		; set base page, validate stack
	bra	zbkpnt 		; force a breakpoint

	;********************************************************
	;*        firq handler
	;*  just return for the firq interrupt
	;********************************************************

firqr:		rti		; immediate return

	.page
	.sbttl	Read / Verify / Punch Routines

	;* bson - turn on read/verify/punch mechanism

bson:	inc	*misflg		; set load in progress flag
	rts			; return to caller

	;* bsoff - turn off read/verify/punch mechanism
	;* a,x volatile

bsoff:	dec	*misflg		; clear load in progress flag
	rts			; return to caller

	;* bsdta - read/verify/punch handler
	;* input: s+6=code byte, verify(-1),punch(0),load(1)
	;*        s+4=start address
	;*        s+2=stop address
	;*        s+0=return address
	;* output: z=1 normal completion, z=0 invalid load/ver
	;* registers are volatile

bsdta:	ldu	2,s		; u=to address or offset
	tst	6,s		; ? punch
	beq	10$		; branch yes

	;* during read/verify: s+2=msb address save byte
	;*                     s+1=byte counter
	;*                     s+0=checksum
	;*                     u holds offset

	leas	-3,s		; room for work/counter/checksum
1$:	swi			; get next character
	.byte	inchnp		; function
2$:	cmpa	#'S		; ? start of s1/s9
	bne	1$		; branch not
	swi			; get next character
	.byte	inchnp		; function
	cmpa	#'9		; ? have s9
	beq	5$		; yes, return good code
	cmpa	#'1		; ? have new record
	bne	2$		; branch if not
	clr	,s		; clear checksum
	bsr	9$		; obtain byte count
	stb	1,s		; save for decrement

	;* read address

	bsr	9$		; obtain high value
	stb	2,s		; save it
	bsr	9$		; obtain low value
	lda	2,s		; make d=value
	leay	d,u		; y=address+offset

	;* store text

3$:	bsr	9$		; next byte
	beq	6$		; branch if checksum
	tst	9,s		; ? verify only
	bmi	4$		; yes, only compare
	stb	,y		; store into memory
4$:	cmpb	,y+		; ? valid ram
	beq	3$		; yes, continue reading
5$:	puls	pc,x,a		; return with z set proper

6$:	inca			; ? valid checksum
	beq	1$		; branch yes
	bra	5$		; return z=0 invalid

	;* byte builds 8 bit value from two hex digits in

7$:	bsr	9$		; obtain first hex
	ldb	#16		; prepare shift
	mul			; over to a
	bsr	9$		; obtain second hex
	pshs	b		; save high hex
	adda	,s+		; combine both sides
	tfr	a,b		; send back in b
	adda	2,s		; compute new checksum
	sta	2,s		; store back
	dec	3,s		; decrement byte count
8$:	rts			; return to caller

9$:	swi			; get next hex
	.byte	inchnp		; character
	lbsr	cnvhex		; convert to hex
	beq	8$		; return if valid hex
	puls	pc,u,y,x,a	; return to caller with z=0

	;* punch stack use: s+8=to address
	;*                  s+6=return address
	;*                  s+4=saved padding values
	;*                  s+2 from address
	;*                  s+1=frame count/checksum
	;*                  s+0=byte count

10$:	ldu	*vectab+.pad	; load padding values
	ldx	4,s		; x=from address
	pshs	u,x,d		; create stack work area
	ldd	#24		; set a=0, b=24
	stb	*vectab+.pad	; setup 24 character pads
	swi			; send nulls out
	.byte	outch		; function
	ldb	#4		; setup new line pad to 4
	std	*vectab+.pad	; setup punch padding

	;* calculate size

11$:	ldd	8,s		; load to
	subd	2,s		; minus from=length
	cmpd	#24		; ? more than 23
	blo	12$		; no, ok
	ldb	#23		; force to 23 max
12$:	incb			; prepare counter
	stb	,s		; store byte count
	addb	#3		; adjust to frame count
	stb	1,s		; save

	;*punch cr,lf,nuls,s,1

	leax	16$,pcr		; load start record header
	swi			; send out
	.byte	pdata		; function

	;* send frame count

	clrb			; initialize checksum
	leax	1,s		; point to frame count and addr
	bsr	14$		; send frame count

	;*data address

	bsr	14$		; send address hi
	bsr	14$		; send address low

	;*punch data

	ldx	2,s		; load start data address
13$:	bsr	14$		; send out next byte
	dec	,s		; ? final byte
	bne	13$		; loop if not done
	stx	2,s		; update from address value

	;*punch checksum

	comb			; complement
	stb	1,s		; store for sendout
	leax	1,s		; point to it
	bsr	15$		; send out as hex
	ldx	8,s		; load top address
	cmpx	2,s		; ? done
	bhs	11$		; branch not
	leax	17$,pcr		; prepare end of file
	swi			; send out string
	.byte	pdata		; function
	ldd	4,s		; recover pad counts
	std	*vectab+.pad	; restore
	clra			; set z=1 for ok return
	puls	pc,u,x,d	; return with ok code

14$:	addb	,x		; add to checksum
15$:	lbra	zout2h		; send out as hex and return

16$:	.byte	'S,'1,eot 	; cr,lf,nulls,S,1
17$:	.ascii	/S9030000FC/	; eof string
	.byte	cr,lf,eot

	;* hsdta - high  speed print memory
	;* input: s+4=start address
	;*        s+2=stop address
	;*        s+0=return address
	;* x,d volatile
	;*  send title

hsdta:	swi			; send new line
	.byte	pcrlf		; function
	ldb	#6		; prepare 6 spaces
1$:	swi			; send blank
	.byte   space		; function
	decb			; count down
	bne	1$		; loop if more
	clrb			; setup byte count
2$:	tfr	b,a		; prepare for convert
	lbsr	zouthx		; convert to a hex digit
	swi			; send blank
	.byte	space		; function
	swi			; send another
	.byte	space		; blank
	incb			; up another
	cmpb	#0x10		; ? past 'f'
	blo	2$		; loop until so
3$:	swi			; to next line
	.byte	pcrlf		; function
	bcs	8$		; return if user entered ctl-x
	leax	4,s		; point at address to convert
	swi			; print out address
	.byte	out4hs		; function
	ldx	4,s		; load address proper
	ldb	#16		; next sixteen
4$:	swi			; convert byte to hex and send
	.byte	out2hs		; function
	decb			; count down
	bne	4$		; loop if not sixteenth
	swi			; send blank
	.byte	space		; function
	ldx	4,s		; reload from address
	ldb	#16		; count
5$:	lda	,x+		; next byte
	bmi	6$		; too large, to a dot
	cmpa	#' 		; ? lower than a blank
	bhs	7$		; no, branch ok
6$:	lda	#'.		; convert invalid to a blank
7$:	swi			; send character
	.byte	outch		; function
	decb			; ? done
	bne	5$		; branch no
	cpx	2,s		; ? past last address
	bhs	8$		; quit if so
	stx	4,s		; update from address
	lda	5,s		; load low byte address
	asla			; ? to section boundry
	bne	3$		; branch if not
	bra	hsdta		; branch if so
8$:	swi			; send new line
	.byte	pcrlf		; function
	rts			; return to caller

	;********************************************************
	;*     a s s i s t 0 9    c o m m a n d s
	;********************************************************

	;**********   registers - display and change registers

creg:	bsr	regprt		; print registers
	inca			; set for change function
	bsr	regchg		; go change, display registers
	rts			; return to command processor

	;********************************************************
	;*      regprt - print/change registers subroutine
	;*  will abort to 'cmdbad' if overflow detected during
	;*  a change operation.  change displays registers when
	;*  done.
	;*
	;* register mask list consists of:
	;*  a) characters denoting register
	;*  b) zero for one byte, -1 for two
	;*  c) offset on stack to register position
	;*
	;* input:    +4=stacked registers
	;*        a=0 print, a#0 print and change
	;* output: (only for register display)
	;*         c=1 control-x entered, c=0 otherwise
	;*
	;* volatile: d,x (change)
	;*           b,x (display)
	;********************************************************

regmsk:	.byte	'P,'C,-1,19	; pc reg
	.byte	'A,0,10		; a reg
	.byte	'B,0,11		; b reg
	.byte	'X,-1,13	; x reg
	.byte	'Y,-1,15	; y reg
	.byte	'U,-1,17	; u reg
	.byte	'S,-1,1		; s reg
	.byte	'C,'c,0,9	; cc reg
	.byte	'D,'p,0,12	; dp reg
	.byte	0		; end of list

regprt:	clra			; setup print only flag
regchg:	leax	4+12,s		; ready stack value
	pshs	y,x,a		; save on stack with option
	leay	regmsk,pcr	; load register mask
1$:	ldd	,y+		; load next char or <=0
	tsta			; ? end of characters
	ble	2$		; branch not character
	swi			; send to console
	.byte	outch		; function byte
	bra	1$		; check next
2$:	lda	#'-		;  ready '-'
	swi			; send out
	.byte	outch		; with outch
	leax	b,s		; x->register to print
	tst	,s		; ? change option
	bne	5$		; branch yes
	tst	-1,y		; ? one or two bytes
	beq	3$		; branch zero means one
	swi			; perform word hex
	.byte	out4hs		; function
	bra	4$

3$:	swi			; perform byte hex
	.byte	out2hs		; function
4$:	ldd	,y+		; to front of next entry
	tstb			; ? end of entries
	bne	1$		; loop if more
	swi			; force new line
	.byte	pcrlf		; function
	puls	pc,y,x,a	; restore stack and return

5$:	bsr	bldnnb		; input binary number
	beq	7$		; if change then jump
	cmpa	#cr		; ? no more desired
	beq	9$		; branch nope
	ldb	-1,y		; load size flag
	decb			; minus one
	negb			; make positive
	aslb			; times two (=2 or =4)
6$:	swi			; perform spaces
	.byte	space		; function
	decb
	bne	6$		; loop if more
	bra	4$		; continue with next register
7$:	sta	,s		; save delimiter in option

	;*                     (always > 0)

	ldd	*anumber	; obtain binary result
	tst	-1,y		; ? two bytes worth
	bne	8$		; branch yes
	lda	,-x		; setup for two
8$:	std	,x		; store in new value
	lda	,s		; recover delimiter
	cmpa	#cr		; ? end of changes
	bne	4$		; no, keep on truck'n

	;* move stacked data to new stack in case stack
	;* pointer has changed

9$:	leax	tstack,pcr	; load temp area
	ldb	#21		; load count
10$:	puls	a		; next byte
	sta	,x+		; store into temp
	decb			; count down
	bne	10$		; loop if more
	lds	-20,x		; load new stack pointer
	ldb	#21		; load count again
11$:	lda	,-x		; next to store
	pshs	a		; back onto new stack
	decb			; count down
	bne	11$		; loop if more
	puls	pc,y,x,a	; restore stack and return

	;********************************************************
	;*  bldnum - builds binary value from input hex
	;*  the active expression handler is used.
	;*
	;* input: s=return address
	;* output: a=delimiter which terminated value
	;*                            (if delm not zero)
	;*         "number"=word binary result
	;*         z=1 if input recieved, z=0 if no hex recieved
	;*
	;*  registers are transparent
	;********************************************************

	;* execute single or extended rom expression handler
	;*
	;* the flag "delim" is used as follows:
	;*   delim=0  no leading blanks, no forced terminator
	;*   delim=chr  accept leading 'chr's, forced terminator

bldnnb:	clra			; no dynamic delimiter
	sta	*delim		; store as delimiter
	jmp [vectab+.expan,pcr]	; to exp analyzer

	;* build with leading blanks

bldnum:	lda	#' 		; allow leading blanks
	sta	*delim		; store as delimiter
	jmp [vectab+.expan,pcr]	; to exp analyzer
	
	;* this is the default single rom analyzer. we accept:
	;*    1) hex input
	;*    2) 'M' for last memory examine address
	;*    3) 'P' for program counter address
	;*    4) 'W' for window value
	;*    5) '@' for indirect value

exp1:	pshs	x,b		; save registers
1$:	bsr	bldhxi		; clear number, check first char
	beq	3$		; if hex digit continue building

	;* skip blanks if desired

	cmpa	*delim		; ? correct delimiter
	beq	1$		; yes, ignore it

	;* test for m or p

	ldx	*addr		; default for 'm'
	cmpa	#'M		; ? memory examine addr wanted
	beq	5$		; branch if so
	ldx	*pcnter		; default for 'p'
	cmpa	#'P		; ? last program counter wanted
	beq	5$		; branch if so
	ldx	*window		; default to window
	cmpa	#'W		; ? window wanted
	beq	5$
2$:	puls	pc,x,b		; return and restore registers

	;* got hex, now continue building

3$:	bsr	bldhex		; compute next digit
	beq	3$		; continue if more
	bra	6$		; search for +/-

	;* store value and check if need delimiter

4$:	ldx	,x		; indirection desired
5$:	stx	*anumber	; store result
	tst	*delim		; ? to force a delimiter
	beq	2$		; return if not with value
	bsr	read		; obtain next character

	;* test for + or -

6$:	ldx	*anumber	; load last value
	cmpa	#'+		; ? add operator
	bne	8$		; branch not
	bsr	10$		; compute next term
	pshs	a		; save delimiter
	ldd	*anumber	; load new term
7$:	leax	d,x		; add to x
	stx	*anumber	; store as new result
	puls	a		; restore delimiter
	bra	6$		; now test it
8$:	cmpa	#'-		; ? subtract operator
	beq	9$		; branch if so
	cmpa	#'@		; ? indirection desired
	beq	4$		; branch if so
	clrb			; set delimiter return
	bra	2$		; and return to caller
9$:	bsr	10$		; obtain next term
	pshs	a		; save delimiter
	ldd	*anumber	; load up next term
	nega			; negate a
	negb			; negate b
	sbca	#0		; correct for a
	bra	7$		; go add to expresion

	;* compute next expression term
	;* output: x=old value
	;*         'number'=next term

10$:	bsr	bldnum		; obtain next value
	lbne	cmdbad		; abort command if invalid
	rts			; return if valid number

	;********************************************************
	;*  build binary value using input characters.
	;*
	;* input: a=ascii hex value or delimiter
	;*           +0=return address
	;*           +2=16 bit result area
	;* output: z=1 a=binary value
	;*         z=0 if invalid hex character (a unchanged)
	;*
	;* volatile: d
	;********************************************************

bldhxi:	clr	*anumber	; clear number
	clr	*anumber+1	; clear number
bldhex:	bsr	read		; get input character
bldhxc:	bsr	cnvhex		; convert and test character
	bne	cnvrts		; return if not a number
	ldb	#16		; prepare shift
	mul			; by four places
	lda	#4		; rotate binary into value
1$:	aslb			; obtain next bit
	rol	*anumber+1	; into low byte
	rol	*anumber	; into hi byte
	deca			; count down
	bne	1$		; branch if more to do
	bra	cnvok		; set good return code

	;********************************************************
	;* convert ascii character to binary byte
	;*
	;* input: a=ascii
	;* output: z=1 a=binary value
	;*         z=0 if invalid
	;*
	;* all registers transparent
	;* (a unaltered if invalid hex)
	;********************************************************

cnvhex:	cmpa	#'0		; ? lower tigh hex
	blo	cnvrts		; branch not value
	cmpa	#'9		; ? possible a-f
	ble	cnvgot		; branch no to accept
	cmpa	#'A		; ? less than ten
	blo	cnvrts		; return if minus (invalid)
	cmpa	#'F		; ? not too large
	bhi	cnvrts		; no, return too large
	suba	#7		; down to binary
cnvgot:	anda	#0x0f		; clear high byte
cnvok:	orcc	#4		; force zero on for valid hex
cnvrts:	rts			; return to caller

	;* get input char, abort command if control-x (cancel)

read:	swi			; get next character
	.byte	inchnp		; function
	cmpa	#can		; ? abort command
	lbeq	cmdbad		; branch to abort if so
	rts			; return to caller


	;************	console - dumby routines

cidta:	clc			; never a character
codta:				; dumby character out
cion:				; input console initialization
coon:				; output console initialization
cioff:				; console input off
cooff:				; console output off
cirtn:	rts

	;************	pause - process pause routine

cpause:	jmp	pauser		; go to default pause routine


	;************	go - start program execution

cgo:	bsr	goaddr		; build address if needed
	rti			; start executing

	;* find optional new program counter. also arm the
	;* breakpoints.

goaddr:	puls	y,x		; pop return addresses from cmd and cgo
	pshs	x		; restore return from cgo
	beq	1$		; <cr> ? yes - use current pc

	;* obtain new program counter

	lbsr	cdnum		; obtain new program counter
	std	12,s		; store into stack

1$:	ldx	12,s		; load program counter
	lbsr	cbkldr		; obtain table
	neg	*bkptct		; complement to show armed
2$:	decb			; ? done
	bmi	5$		; return when done
	lda	[,y]		; load opcode
	sta	-numbkp*2,y	; store into opcode table
	lda	#0x3f		; ready "swi" opcode
	cmpx	,y		; starting at a breakpoint ?
	bne	4$		; no - go set breakpoint

	cmpa	[,y++]		; ? swi breakpointed
	bne	2$		; no, skip setting of flag
	sta	*swibfl		; show upcomming swi not brkpnt
	bra	2$		; check others

4$:	sta	[,y++]		; store and move up table
	bra	2$		; and continue

5$:	rts

	;************	call - call address as subroutine

ccall:	bsr	goaddr		; fetch address if needed
	puls	u,y,x,dp,d,cc	; restore users registers
	jsr	[,s++]		; call user subroutine
1$:	swi			; perform breakpoint
	.byte	brkpt		; function
	bra	1$		; loop until user changes pc

	;************	memory - display/change memory
	;*	cmem and cmpadp are direct entry points from
	;*	the command handler for quick commands

cmem:	lbsr	cdnum		; obtain address
cmemn:	std	*addr		; store default
1$:	ldx	*addr		; load pointer
	lbsr	zout2h		; send out hex value of byte
	lda	#'-		; load delimiter
	swi			; send out
	.byte	outch		; function
2$:	lbsr	bldnnb		; obtain new byte value
	beq	3$		; branch if number

	;* coma - skip byte

	cmpa	#',		; ? comma
	bne	4$		; branch not
	stx	*addr		; update pointer
	leax	1,x		; to next byte
	bra	2$		; and input it
3$:	ldb	*anumber+1	; load low byte value
	bsr	13$		; go overlay memory byte
	cmpa	#',		; ? continue with no display
	beq	2$		; branch yes

	;* quoted string

4$:	cmpa	#''		; ? quoted string
	bne	6$		; branch no
5$:	bsr	read		; obtain next character
	cmpa	#''		; ? end of quoted string
	beq	7$		; yes, quit string mode
	tfr	a,b		; to b for subroutine
	bsr	13$		; go update byte
	bra	5$		; get next character

	;* blank - next byte

6$:	cmpa	#0x20		; ? blank for next byte
	bne	8$		; branch not
	stx	*addr		; update pointer
7$:	swi			; give space
	.byte	space		; function
	bra	1$

	;* dot - next byte with address

8$:	cmpa	#'.		; ? dot for next byte
	bne	9$		; branch no
	swi			; force new line
	.byte	pcrlf		; function
	stx	*addr		; store next address
	bra	cmpadp		; branch to show

	;* up arrow - previous byte and address

9$:	cmpa	#'^		; ? up arrow for previous byte
	bne	11$		; branch not
	leax	-2,x		; down to previous byte
	stx	*addr		; store new pointer
10$:	swi			; force new line
	.byte	pcrlf		; function
cmpadp=.
	bsr	12$		; go print its value
	bra	1$		; then prompt for input

	;* slash - for current byte with address

11$:	cmpa	#'/		; ? slash for current display
	beq	10$		; yes, send address
	rts			; return from command

	;* print current address

12$:	ldx	*addr		; load pointer value
	pshs	x		; save x on stack
	leax	,s		; point to it for display
	swi			; display pointer in hex
	.byte	out4hs		; function
	puls	pc,x		; recover pointer and return

	;* update byte

13$:	ldx	*addr		; load next byte pointer
	stb	,x+		; store and increment x
	cmpb	-1,x		; ?  successfull store
	bne	14$		; branch for '?'  if not
	stx	*addr		; store new pointer value
	rts			; back to caller

14$:	pshs	a		; save a register
	lda	#'?		; show invalid
	swi			; send out
	.byte	outch		; function
	puls	pc,a		; return to caller

	;************	window  -  set window value

cwindo:	bsr	cdnum		; obtain window value
	std	*window		; store it in
	rts			; end command

	;************	display - high speed display memory

cdi:	bsr	cdnum		; fetch address
	andb	#0xf0		; force to 16 boundry
	tfr	d,y		; save in y
	leax	15,y		; default length
	bcs	1$		; branch if end of input
	bsr	cdnum		; obtain count
	leax	d,y		; assume count, compute end addr
1$:	pshs	y,x		; setup parameters for hsdata
	cmpd	2,s		; ? was it count
	bls	2$		; branch yes
	std	,s		; store high address
2$:	jsr [vectab+.hsdta,pcr]	; call print routine
	puls	pc,u,y		; clean stack and end command

	;* obtain number - abort if none
	;* only delimiters of cr, blank, or '/' are accepted
	;* output: d=value, c=1 if carriage return delmiter,
	;*                                  else c=0
cdnum:	lbsr	bldnum		; obtain number
	lbne	cmdbad		; branch if invalid
	cmpa	#'/		; ? valid delimiter
	lbhi	cmdbad		; branch if not for error
	cmpa	#cr+1		; leave compare for carriage ret
	ldd	*anumber	; load number
	rts

	;************	punch - punch memory in s1-s9 format

cpunch:	bsr	cdnum		; obtain start address
	tfr	d,y		; save in y
	bsr	cdnum		; obtain end address
	clr	,-s		; setup punch function code
	pshs	y,d		; store values on stack
ccalbs:	jsr [vectab+.bson,pcr]	; initialize handler
	jsr [vectab+.bsdta,pcr]	; perform function
	pshs	cc		; save return code
	jsr [vectab+.bsoff,pcr]	; turn off handler
	puls	cc		; obtain condition code saved
	lbne	cmdbad		; branch if error
	puls	pc,y,x,a	; return from command

	;************	load - load memory from s1-s9 format

cload:	bsr	clvofs		; call setup and pass code
	.byte	1		; load function code for packet

clvofs:	leau	[,s++]		; load code in high byte of u
	leau	[,u]		; not changing cc and restore s
	beq	1$		; branch if carriage return next
	bsr	cdnum		; obtain offset
	bra	2$

1$:	clra			; create zero offset
	clrb			; as default
2$:	pshs	u,dp,d		; setup code, null word, offset
	bra	ccalbs		; enter call to bs routines

	;************	verify - compare memory with files

cver:	bsr	clvofs		; compute offset if any
	.byte	-1		; verify fnctn code for packet

	;************	nulls  -  set new line and char padding

cnulls:	bsr	cdnum		; obtain new line pad
	std	*vectab+.pad	; reset values
	rts			; end command

	;************	offset - compute short and long
	;*				branch offsets

coffs:	bsr	cdnum		; obtain instruction address
	tfr	d,x		; use as from address
	bsr	cdnum		; obtain to address

	;* d=to instruction, x=from instruction offset byte(s)

	leax	1,x		; adjust for *+2 short branch
	pshs	y,x		; store work word and value on s
	subd	,s		; find offset
	std	,s		; save over stack
	leax	1,s		; point for one byte display
	sex			; sign extend low byte
	cmpa	,s		; ? valid one byte offset
	bne	1$		; branch if not
	swi			; show one byte offset
	.byte	out2hs		; function
1$:	ldu	,s		; reload offset
	leau	-1,u		; convert to long branch offset
	stu	,x		; store back where x points now
	swi			; show two byte offset
	.byte	out4hs		; function
	swi			; force new line
	.byte	pcrlf		; function
	puls	pc,x,d		; restore stack and end command

	;************	breakpoint - display/enter/delete/clear
	;*				breakpoints

cbkpt:	beq	5$		; branch display of just 'b'
	lbsr	bldnum		; attempt value entry
	beq	7$		; branch to add if so
	cmpa	#'-		; ? correct delimiter
	bne	9$		; no, branch for error
	lbsr	bldnum		; attempt delete value
	beq	2$		; got one, go delete it
	clr	*bkptct		; was 'b -', so zero count
1$:	rts			; end command

	;* delete the entry

2$:	bsr	11$		; setup registers and value
3$:	decb			; ? any entries in table
	bmi	9$		; branch no, error
	cmpx	,y++		; ? is this the entry
	bne	3$		; no, try next

	;* found, now move others up in its place

4$:	ldx	,y++		; load next one up
	stx	-4,y		; move down by one
	decb			; ? done
	bpl	4$		; no, continue move
	dec	*bkptct		; decrement breakpoint count
5$:	bsr	11$		; setup registers and load value
	beq	1$		; return if none to delete
6$:	leax	,y++		; point to next entry
	swi			; display in hex
	.byte	out4hs		; function
	decb			; count down
	bne	6$		; loop if more to do
	swi			; skip to new line
	.byte	pcrlf		; function
	rts			; return to end command

	;* add new entry

7$:	bsr	11$		; setup registers
	cmpb	#numbkp		; ? already full
	beq	9$		; branch error if so
	lda	,x		; load byte to trap
	stb	,x		; try to change
	cmpb	,x		; ? changable ram
	bne	9$		; branch error if not
	sta	,x		; restore byte
8$:	decb			; count down
	bmi	10$		; branch if done to add it
	cmpx	,y++		; ? entry already here
	bne	8$		; loop if not
9$:	lbra	cmdbad		; exit with error

10$:	stx	,y		; add this entry
	clr	-numbkp*2+1,y	; clear optional byte
	inc	*bkptct		; add one to count
	bra	5$		; and now display all of 'em

	;* setup registers for scan

11$:	ldx	*anumber	; load value desired
cbkldr:	leay	bkptbl,pcr	; load start of table
	ldb	*bkptct		; load entry count
	rts			; return

	;************	encode  -  encode a postbyte

cencde:	clr	,-s		; default to not indirect
	clrb			; zero postbyte value
	leax	conv1,pcr	; start table search
	swi			; obtain first character
	.byte	inchnp		; function
	cmpa	#'[		; ? indirect here
	bne	2$		; branch if not
	lda	#0x10		; set indirect bit on
	sta	,s		; save for later
1$:	swi			; obtain next character
	.byte	inchnp		; function
2$:	cmpa	#cr		; ? end of entry
	beq	4$		; branch yes
3$:	tst	,x		; ? end of table
	lbmi	cmdbad		; exit with error
	cmpa	,x++		; ? this the character
	bne	3$		; branch if not
	addb	-1,x		; add this value
	bra	1$		; get next input
4$:	leax	conv2,pcr	; point at table 2
	tfr	b,a		; save copy in a
	anda	#0x60		; isolate register mask
	ora	,s		; add in indirection bit
	sta	,s		; save back as postbyte skeleton
	andb	#0x9f		; clear register bits
5$:	tst	,x		; ? end of table
	lbeq	cmdbad		; exit with error
	cmpb	,x++		; ? same value
	bne	5$		; loop if not
	ldb	-1,x		; load result value
	orb	,s		; add to base skeleton
	stb	,s		; save postbyte on stack
	leax	,s		; point to it
	swi			; send out as hex
	.byte	out2hs		; function
	swi			; to next line
	.byte	pcrlf		; function
	puls	pc,b		; end of command
   	
	;* table one defines valid input in sequence
conv1:	.byte	'A,0x04,'B,0x05,'D,0x06,'H,0x01
	.byte	'H,0x01,'H,0x01,'H,0x00,',,0x00
	.byte	'-,0x09,'-,0x01,'S,0x70,'Y,0x30
	.byte	'U,0x50,'X,0x10,'+,0x07,'+,0x01
	.byte	'P,0x80,'C,0x00,'R,0x00,'],0x00
	.byte	0xff		; end of table

	;*conv2 uses above conversion to set postbyte
	;*                             bit skeleton.

conv2:	.word	0x1084,0x1100	; R,        H,R
	.word	0x1288,0x1389	; HH,R      HHHH,R
	.word	0x1486,0x1585	; A,R       B,R
	.word	0x168b,0x1780	; D,R       ,R+
	.word	0x1881,0x1982	; ,R++      ,-R
	.word	0x1a83,0x828c	; ,--R      HH,pcr
	.word	0x838d,0x039f	; HHHH,pcr  [HHHH]
	.byte	0		; end of table

	;****************************************************
	;*            default interrupt transfers           *
	;****************************************************

rsrvd:	jmp	[vectab+.rsvd,pcr]	; reserved vector
swi3:	jmp	[vectab+.swi3,pcr]	; swi3 vector
swi2:	jmp	[vectab+.swi2,pcr]	; swi2 vector
firq:	jmp	[vectab+.firq,pcr]	; firq vector
irq:	jmp	[vectab+.irq,pcr]	; irq vector
swi:	jmp	[vectab+.swi,pcr]	; swi vector
nmi:	jmp	[vectab+.nmi,pcr]	; nmi vector

	.page
	.sbttl	Hardware Interrupt Tables

	;********************************************************
	;*             assist09 hardware vector table
	;*
	;*  this table is used if the assist09 rom addresses
	;*  the mc6809 hardware vectors.
	;********************************************************

	.=  bldvtr+0d2048-0d16	; assume 2K ROM

	.word	rsrvd		; reserved slot
	.word	swi3		; software interrupt 3
	.word	swi2		; software interrupt 2
	.word	firq		; fast interrupt request
	.word	irq		; interrupt request
	.word	swi		; software interrupt
	.word	nmi		; non-maskable interrupt
	.word	reset		; restart

