	.title	MONDEB - 09

	;	*********************************************************
	;	*							*
	;	*	MONDEB - 09  -  a monitor/debugger		*
	;	*		for the 6809  microprocessor		*
	;	*							*
	;	*********************************************************
	;
	; author:	Don Peters	(6800 version)
	; date:		April 1977
	;
	; modified for the 6809
	; by:		Alan R. Baldwin
	; date:		Nov 1988	
	;
	;	  This 6809 monitor/debugger does not use the
	;	direct page addressing mode.  Thus the user
	;	program has complete control of the page
	;	assignment and may use the monitor routines
	;	without concern for variable locations.
	;
	;	  To add user functions to MONDEB - 09
	;
	;	1) add your commands to the end of command list #1
	;	2) add the command entry points to the jump table
	;	3) append any local command lists after MONDEB's
	;	4) provide an external initialization routine to
	;		set up the console (and/or alternate)
	;		ports and any other start up processing.
	;	   MONDEB will call 'userinit' if inituser = 1.
	;

	.module	mond09

	standalone = 0	; standalone flag indicating the
			; vectors and associated code are
			; to be included during assembly

	inituser = 0	; call 'userinit' flag indicating
			; a user startup routine will be
			; called during intialization

	.page
	.sbttl	MONDEB - 09 working variables

	.radix	d

	.if	standalone

	.area	WORKPG	(REL,CON)

	.else

	.area	WORKPG	(ABS,OVR)

	.endif

	.setdp	0

workpg:	.blkb	256-(endpg-mstack)
			; main stack storage
mstack:	.blkb	12	; stack storage for rti instruction

ttybuf:	.blkb	72	; start of input line buffer
ttyend:	.blkb	1	; end of input line buffer
bufbeg:	.blkb	2	; input line start of buffer
bufend:	.blkb	2	; input line end of buffer

comadr:	.blkb	2	; address of beginning of command lists
synptr:	.blkb	2	; input line character pointer for good syntax
linptr:	.blkb	2	; input line character pointer (content =>
			; content of synptr)
bolflg:	.blkb	1	; "beginning of line flg"
delim:	.blkb	1	; characters permitted as valid command/modifier
			; delimiter
ibcode:	.blkb	1	; input base (1=hex, 2=dec, 3=oct)
dbcode:	.blkb	1	; display base (1=hex, 2=dec, 3=oct, 4=bin)
dbnbr:	.blkb	1	; display base number (e.g., 16,10,8, or 2)
nbrhi:	.blkb	1	; most significant byte of scanned number
nbrlo:	.blkb	1	; least significant byte of scanned number
ranglo:	.blkb	2	; range lower limit picked up by gtrang
ranghi:	.blkb	2	; range upper limit picked up by gtrang
verfrm:	.blkb	2	; beginning address of range to verify
verto:	.blkb	2	; ending address of range to checksum verify
chksum:	.blkb	1	; checksum of range given in the verify command
brkadr: .blkb	2	; address of inserted breakpoint
brkins:	.blkb	1	; instruction which should be there normally
inpflg:	.blkb	1	; alternate input flag
outflg:	.blkb	1	; alternate output flag
outadr:	.blkb	2	; alternate address that the output chars go to
hdxflg:	.blkb	1	; half-duplex terminal flag (if non-zero, no echo)
cplcnt:	.blkb	1	; "characters per line" count
cplmax:	.blkb	1	; "characters per line" maximum

	; temporary (locally used) variables

temp1:	.blkb	2	; in: main
temp2:	.blkb	2	; in: main
temp3:	.blkb	2	; in: main
temp4:	.blkb	2	; in: main
temp5:	.blkb	2	; in: main
temp6:	.blkb	2	; in: main

nummat:	.blkb	1	; used in command
lisnum:	.blkb	1	; used in command
comnum:	.blkb	1	; used in command
lisptr:	.blkb	2	; used in command
decdig:	.blkb	1	; decimal digit being built
numbhi:	.blkb	1	; used by outnum
numblo:	.blkb	1	; used by outnum
nbr2x:	.blkb	2	; used by number
timcon:	.blkb	2	; delay time constant
bytect:	.blkb	1	; record byte count used in load command
cksm:	.blkb	1	; record checksum used in load command

conin:	.blkb	2	; address of console input routine
conout:	.blkb	2	; address of console output routine
altin:	.blkb	2	; address of alternate input routine
altout:	.blkb	2	; address of alternate output routine

.rsrvd:	.blkb	2	; reserved vector
.swi3:	.blkb	2	; swi3 vector
.swi2:	.blkb	2	; swi2 vector
.firq:	.blkb	2	; firq vector
.irq:	.blkb	2	; irq vector
.swi:	.blkb	2	; swi vector
.nmi:	.blkb	2	; nmi vector
spsave:	.blkb	2	; saved stack pointer
endpg:

	; convenient equivalences for local variables

memadr	=	temp1	; display, set, search, test
strnum	=	temp2	; fndstr
eoschr	=	temp2+1	; fndstr

	; for "search" command

bytptr	=	temp2
nbytes	=	temp3
nbrmat	=	temp3+1
bytstr	=	temp4

	; other constants

cr	=	13	; carriage return
lf	=	10	; line feed


	.page
	.sbttl	MOND09 Startup

	.if	standalone

	.area	MONDEB	(REL,CON)

reset:	lds	#mstack+12	; load stack pointer
	bsr	mond09		; stack pc and start mondeb
	bra	reset
	.else

	.area	MONDEB	(ABS,OVR)

	.endif

mond09:	pshs	u,y,x,dp,b,a,cc	; pseudo swi
	sts	spsave		; save the pointer
	orcc	#0b01010000	; hold irq and firq interrupts
	lds	#mstack		; initialize the stack pointer
	jsr	inital		; initialize variables
	jsr	docrlf		; advance to a clean line
	ldx	#msghed		; get address of header
	jsr	outstr		; type it
	ldx	#ttybuf-1	; get address of terminal input buffer
	stx	bufbeg		; save it
	ldx	#ttyend		; define end of input buffer
	stx	bufend		; 72 char capacity, incl cr
	lda	#3		; delimiter class definition
	sta 	delim		; space or comma (code 3)
	bra	promp1

	; prepare to get a new command

prompt:	jsr	docrlf	; type cr-lf
	inc	bolflg	; set 'beginning of line' flag
	ldx 	synptr	; point to current character
	lda	,x	; get it
	cmpa	#';	; semicolon?
	beq	getcmd	; continue scan if it is, 
			; skipping the prompt
promp1:	ldx	#msgprm	; type prompt
	jsr	outstr
	jsr	getlin	; get line of input
	cmpb	#3	; abort line on a control-c
	beq	prompt

	ldx	bufbeg	; set syntax scanning pointer
	stx	synptr	; to beginning of buffer/line
	lda	1,x	; get first char
	jsr	tsteol	; reprompt on an empty line
	beq	prompt	; (first char = cr,lf,or ;)

	.page
	.sbttl	Get Command

getcmd:	lda	#1	; use list 1 when matching
	jsr	comand	; now go for a match
	beq	prompt	; reprompt if just a cr was typed
	bgt	jmpcmd	; good command if positive	

badsyn: ldx	bufbeg	; get start of line

1$:	cpx	linptr	; space over to the error in syntax
	beq	2$	; at error ?
	jsr 	outsp	; output a space
	inx		; no, move on
	bra	1$

	; the 'extra' char '1' is compensated for by the prompt
	; char on the preceeding line

2$:	lda	#'^	; at error - get an up-arrow
	jsr	outchr	; print it
	jsr	docrlf
	bra	promp1	; ignore any succeeding packed
			; commands

	; *******
	; *there should be no more characters on the input line
	;	(except delimiters)

nomore:	jsr	skpdlm
	bcs	prompt	; if carry bit set, end of line
			; (normal)
	bra	badsyn	; there is something there but shouldn't be

	.page
	.sbttl	Command Dispatcher

	; ******
	; execute a computed 'goto' to the proper command

jmpcmd:	asla		; multiply command by 2
	ldx	#1$-2
	jmp	[a,x]	; jump to designated command

1$:	.word	break
	.word	contin
	.word	compar
	.word	copy
	.word	displa
	.word	dbase
	.word	delay
	.word	dump
	.word	goto
	.word	help
	.word	ibase
	.word	load
	.word	reg
	.word	set
	.word	search
	.word	test
	.word	verify
	.word	cli
	.word	clf
	.word	sei
	.word	sef
	.word	xirq
	.word	xfirq
	.word	xnmi
	.word	xrsrvd
	.word	xswi
	.word	xswi2
	.word	xswi3

	.page
	.sbttl	REG - display registers

reg:			; print stack stored swi data
disreg:	ldx	spsave	; get saved stack pointer
	clr	comnum	; start at beginning of the
			; register name list
	bsr	1$	; type condition codes
	bsr	1$	; type acca
	bsr	1$	; type accb
	bsr	1$	; type dp
	jsr	docrlf	; advance to a clean line
	bsr	2$	; type index reg x
	bsr	2$	; type index reg y
	bsr	2$	; type index reg u
	jsr	docrlf	; advance to a clean line
	leax	-9,x	; back to d
	bsr	2$	; type d
	leax	7,x	; back to pc
	bsr	2$	; type program counter

	; type the stack pointer location

	bsr	3$	; type stack pointer id
	ldx	#spsave
	jsr	out2by	; type the value
	jmp	nomore

	; output content of a 1 byte register

1$:	bsr	3$
	jsr	out1by
	inx
	rts

	; output content of a 2 byte register

2$:	bsr	3$
	jsr	out2by
	leax	2,x	; skip to next word in stack
	rts

	; misc setup for register display

3$:	jsr	outsp	; output a space
	inc	comnum	; skip to next register name
	lda	#5	; register name is in list 5
	jsr	typcmd	; type it
	jsr	outeq	; type an '='
	rts

	.page
	.sbttl	Software Interrupt Entry Point

typswi:	sts	spsave
	ldx	#msgswi
	jsr	outstr

	; decrement pc so it points to 'swi' instruction

	ldx	spsave
	ldd	10,x
	subd	#1
	cmpd	brkadr	; a break point ?
	bne	disreg	; no - allow to pass
	std	10,x	; backup PC
	bra	disreg	; go display registers

	.sbttl	GOTO - Go To Memory Address

goto:	jsr	mnumber	; get destination
	beq	contin	; if none, just continue
	ldd	nbrhi
	lds	spsave	; place new PC
	std	10,s	; fall through to Continue

	.sbttl	Continue - Continue From a 'SWI'

contin:	lds	spsave	; in case sp was modified via set
	rti		; command

	.sbttl	SEI - Set Interrupt Mask

sei:	orcc	#0b00010000
	jmp	nomore

	.sbttl	CLI - Clear Interrupt Mask

cli:	andcc	#~0b00010000
	jmp	nomore

	.sbttl	SEF - Set Fast Interrupt Mask

sef:	orcc	#0b01000000
	jmp	nomore

	.sbttl	CLF - Clear Fast Interrupt Mask

clf:	andcc	#~0b01000000
	jmp	nomore

	.page
	.sbttl	COPY - Copy From One Location To Another

copy:	jsr	gtrang	; get source range into ranglo &
			; ranghi
	lble	badsyn	; error if no source
	jsr	mnumber	; get destination
	lble	badsyn	; error if no destination
	ldx	ranglo	; get source address pointer
	ldu	nbrhi	; get destination address pointer
	lda	,x	; get byte from source
1$:	sta	,u+	; save byte in destination
	cpx	ranghi	; compare to end of input range
	lbeq	nomore	; done if equal
	lda	,x+	; get byte from source
	bra	1$	; loop for next byte

	.page
	.sbttl	BREAK - Set Breakpoint at Specified Address

break:	jsr	mnumber	; get breakpoint location
	bmi	3$	; if not numeric, look for '?'
	beq	2$	; if no modifier, remove old breakpoint
	ldx	brkadr	; get current break address
	lda	,x	; and the char there
	cmpa	#0x3f	; compare to 'swi'
	bne	1$	; equal?
	lda	brkins	; yes, restore the old instruction
	sta	,x	; restore it

1$:	ldx	nbrhi	; get new breakpoint
	stx	brkadr	; save it
	lda	,x	; get instruction stored there
	sta	brkins	; save it
	lda	#0x3f	; get code for software interrupt
	sta	,x	; put it at breakpoint
	bra	5$	; all done

2$:	ldx	brkadr	; get address of break
	lda	,x	; get inst. there
	cmpa	#0x3f	; swi?
	bne	5$	; if not, return & prompt
	lda	brkins	; was a swi - get previous inst.
	sta	,x	; & restore it
	bra	5$

3$:	lda 	#4
	jsr	comand	; scan for it
	lble	badsyn	; bad syntax if not '?'
	ldx	brkadr	; it is, get break address
	lda	,x	; get instruction there
	cmpa	#0x3f	; is it a 'swi'?
	beq	4$	; if yes, say so
	ldx	#msgnbr	; get that message
	jsr	outstr	; say it
	bra	5$

4$:	ldx	#msgbat	; get that message
	jsr	outstr	; say it
	ldx	#brkadr	; get break address
	jsr	out2by	; type it
5$:	jmp	nomore

	.page
	.sbttl	IBASE - Set Input Base

ibase:	lda	#3	; look for hex,dec,or oct in list #3
	jsr	comand
	bmi	2$	; unrecognizable base, try'?'
	bgt	1$
	lda	#1	; no base given - default to hex
1$:	sta	ibcode	; save base code
	jmp	nomore

2$:	lda	ibcode	; get ib code in case its needed
	pshs	a	; save it on stack temporarily
	bra	ibdbq

	.sbttl	DBASE - Set Display Base

dbase:	lda	#3	; look for hex,dec,oct, or bin in list #3
	jsr	comand
	bmi	3$	; unrecognizable base, try '?'
	bgt	1$
	lda	#1	; no base given - default to hex
1$:	sta	dbcode
	ldx	#2$-1	; get numeric base from table
	lda	a,x
	sta	dbnbr	; save it
	jmp	nomore	; done

2$:	.byte	16	; display base table
	.byte	10
	.byte	8
	.byte	2

3$:	lda	dbcode	; get db code in case its needed
	pshs a		; save it on stack temporarily

ibdbq:	lda	#4	; look for '?' in list #4
	jsr	comand	
	puls b		; retrieve input base/display base code
	lble	badsyn	; error if the 'something' was not a '?'
	lda	#3	; base code is in list 3
	stb	comnum	; store base code
	jsr	typcmd	; type out base
	jmp	nomore

	.page
	.sbttl	Display - Display Memory Data

displa:	jsr	gtrang	; get memory display range
	lble	badsyn	; address is required
	ldx	ranglo	; initialize address pointer
	stx	memadr

	lda	#6	; search list 6 for
	jsr	comand	; display modifiers 'data' or 'used'
	lbmi	badsyn	; any other modifier is illegal
	deca		; adj display modifier code so that:
	sta	comnum	; -1=addr & data, 0=data, 1=used
	clrb		; init 'data values per line' counter
	incb
1$:	ldx	#memadr
	tst	comnum	; which display option?
	bmi	6$	; if 'address & data', go there
	decb		; count data values per line
	bne	2$	; if count not up, skip address output
	jsr	docrlf	; get to line beginning
	jsr	out2by	; output address
	jsr	outsp	; and a space
	ldb	dbnbr	; reset line counter

2$:	ldx	memadr	; point to data at that address
	tst	comnum	; want 'data' option?
	bgt	3$	; if not, go to 'used' code

	jsr	outsp	; output preceedng space
	bra 	7$

3$:	lda	,x	; get the data
	bne 	4$
	lda	#'.	; its zero, get a '.'
	bra 	5$

4$:	lda	#'+	; its non-zero, get a '+'
5$:	jsr	outchr	; output the '.' or '+'
	bra	8$

6$:	jsr	outsp	; output a preceeding space
	jsr	out2by	; type address
	jsr	outeq	; type	'='
	ldx	,x	; get content
7$:	jsr	out1by	; type it
8$:	cpx	ranghi	; are we done
	lbeq	nomore	; if yes, back to prompt
	inx		; no, inc memory address
	stx	memadr	; save it
	bra	1$

	.page
	.sbttl	SET - Set Memory Locations

set:	jsr	gtrang	; get memory location/range
	bmi	5$	; if not an address, look for a
			; register name
	lbeq	badsyn	; an address modifier is required

	; range of address specified?

	ldx	ranglo
	cpx	ranghi
	beq	2$	; if single address, set up
			; addresses individually

	; set a range of addresses to a single value

	jsr	mnumber	; get that value
	lble	badsyn	; its	required
	lda	nbrlo	; put it in acca
1$:	sta	,x	; store it in destination
	cpx	ranghi	; end of range hit?
	lbeq	nomore	; if yes, all done
	inx		; no, on to next address in range
	bra	1$	; loop to see it

	; set addresses up individually

2$:	stx	memadr	; save memory loc
3$:	jsr	mnumber	; get data to put there
	beq	4$	; end of line?
	lblt	badsyn	; abort if bad syntax
	lda	nbrlo	; load data byte
	ldx	memadr	; load address
	sta	,x+	; store data
	bra	2$

4$:	ldx	synptr	; point to end of line
	lda	,x	; get char there
	cmpa	#lf	; line feed?
	lbne	nomore	; if not,back to prompt
	ldx	#memadr	; yes, get next address to be set
	jsr	out2by	; type it
	jsr	outsp	; and a space
	jsr	getlin	; get a new line
	ldx	bufbeg	; get buffer beginning
	stx	synptr	; equate it to syntax scan pointer
	bra	3$	; go pick up data

	; look for (register name, register value) pairs

5$:	lda	#5	
	jsr	comand	; pick up a register name
	lbmi	badsyn	; error if unrecognizable
	lbeq	nomore	; done if end of line
	pshs a		; save register name(number)
	jsr	mnumber	; get new register value
	puls a		; restore register name(number)
	lble	badsyn	; got good register value?
	deca
	ldu	#6$
	lda	a,u
	leau	a,u
	ldx	spsave	; yes, point to top of stack
	ldd	nbrhi	; get register value
	jsr	,u	; go to function
	bra	5$	; and loop

6$:	.byte	7$-6$
	.byte	8$-6$
	.byte	9$-6$
	.byte	10$-6$
	.byte	11$-6$
	.byte	12$-6$
	.byte	13$-6$
	.byte	14$-6$
	.byte	15$-6$
	.byte	16$-6$

7$:	stb	,x	; condition codes
	rts

8$:	stb	1,x	; acca
	rts

9$:	stb	2,x	; accb
	rts

10$:	stb	3,x	; dp
	rts

11$:	std	4,x	; ix
	rts

12$:	std	6,x	; iy
	rts

13$:	std	8,x	; iu
	rts

14$:	std	1,x	; d
	rts

15$:	std	10,x	; pc
	rts

16$:	std	spsave	; sp
	rts

	.page
	.sbttl	Checksum Verify a Block of Memory

verify:	jsr	gtrang	; get a number range
	beq	1$	; no modifier means check what we have
	lbmi	badsyn	; anything else is illegal

	ldx	ranglo	; good range given,
	stx	verfrm	; transfer it to checksum addresses
	ldx	ranghi
	stx	verto

	bsr	cksum	; compute checksum
	sta	chksum	; save it
	ldx	#chksum	; type the checksum
	jsr	out1by
	bra	3$

1$:	bsr	cksum	; compute checksum
	cmpa 	chksum	; same as stored checksum?
	bne 	2$

	ldx	#msgver	; they verify - say so
	jsr	outstr
	bra	3$

2$:	ldx	#msgnve	; they don't - say so
	jsr	outstr
3$:	jmp	nomore

	; compute the checksum from addresses verfrm to verto
	; return the checksum in acca

cksum:	clra		; init checksum to zero
	ldx	verfrm	; get first address
	dex		; init to one less
1$:	inx		; start of checksum loop
	adda	,x	; update checksum in acca with
			; byte pointed to
	cpx	verto	; hit end of range?
	bne	1$	; if not, loop back
	coma		; complement the sum
	rts		; return with it


	.page
	.sbttl	Search Memory for Byte String

	; global variables used
	;  linptr - input line character pointer
	;  lisptr - command list character pointer
	;  ranglo - 'search from' address
	;  ranghi - 'search to' address
	;
	; local variables used
	;  memadr - starting memory address where a match
	;		occurred
	;  bytptr - address pointer used to fill bytstr and
	;		substr buffers
	;  nbytes - number of bytes in byte string
	;  nbrmat - number of chars that match so far in the
	;		matching process
	;  bytstr - starting address of 6 character byte sring
	;		buffer
	;
	; the search string occupies temp4, temp5, & temp6
	;		(6 bytes max)

search:	jsr	gtrang	; get search range
	lble	badsyn	; abort if no pair
	ldx	#bytstr	; get start of byte string
			; to search for
	stx	bytptr	; set pointer to it
	clr	nbytes	; zero # of bytes in byte string

1$:	jsr	mnumber	; get a byte string
	beq	2$	; begin search if eol
	lblt	badsyn	
			; good byte, add it to string
	inc	nbytes	; count this  byte
	lda	nbytes	; don't accept over 6 bytes
	cmpa	#6
	lbgt	badsyn
	lda	nbrlo	; get (low order) byte
	ldx	bytptr	; get byte pointer
	sta	,x+	; save byte, bump pointer
	stx	bytptr	; save it
	bra 	1$

2$:	tst	nbytes	; is # of bytes to look for >0
	lbeq	badsyn	; if not,bad syntax
	ldx	ranglo	; initialize memory pointer
	dex
	stx	linptr

3$:	ldx  #bytstr-1	; initialize byte pointer
	stx	lisptr
	clr	nbrmat	; set 'number of bytes that
			; matched' to zero
	jsr	getlst	; get byte from byte string

4$:	jsr	mgetchr	; get byte from memory range
	cba		; compare memory & byte string
			; characters
	beq	5$	; if no match, test for range end
	cpx	ranghi	; have we reached the range
			; search upper limit?
	lbeq	nomore	; yes, go prompt for next command
	bra	4$

5$:	stx	memadr	; match achieved - save address of match
6$:	inc	nbrmat	; bump number matched
	lda	nbrmat	
	cmpa	nbytes	; have all characters matched?
	beq	8$	; if so, match achieved

	jsr	getlst	; haven't matched all yet, go get next pair
	jsr	mgetchr	; even if past 'search to' address
	cba
	beq	6$

7$:	ldx	memadr	; mismatch on some byte past the first one

	cpx	ranghi	; this test handles special case
	lbeq	nomore	; of a match on range end
	stx	linptr
	bra 	3$	; go reset the byte string pointer


8$:	ldx	#memadr	; match on byte string achieved,
	jsr	out2by	; type out memory address
	jsr	outsp	; and a space
	bra 	7$

	.page
	.sbttl	Test Ram

test:	jsr	gtrang	; get an address range
	lble	badsyn	; abort if no pair
	ldu	ranglo	; ranglo holds starting address of range
			; ranghi holds ending address of range
1$:	lda	,u	; get byte stored at test location
	pshs	a	; save it
	clr	,u	; zero the location
	tst	,u	; test it
	beq	2$	; ok if = zero
	ldx	#msgccl	; can't clear location
	bra	4$

2$:	dec	,u	; set location to $ff
	lda	#0xff
	cmpa	,u	; did it get set to $ff?
	beq	3$
	ldx	#msgcso	; can't set location to one's
	bra 	4$

3$:	puls	a
	sta	,u	; restore previous content
	cmpu	ranghi	; hit end of test range?
	lbeq	nomore	; yes, all done
	leau	1,u	; no, move to test next location
	bra	1$

4$:	stx	temp3	; save error message temporarily
	ldx	#temp4
	stu	,x
	jsr	out2by	; type out bad address
	jsr	outeq	; and equal sign
	ldx	temp4
	jsr	out1by	; its content
	jsr	outsp	; a space
	ldx	temp3
	jsr	outstr	; and the type of error
	jsr	docrlf	
	bra	3$

	.page
	.sbttl	vector settup commands

	; rsrvd - set up rsvd pointer

xrsrvd:	jsr	numinx	; get pointer in ix
	stx	.rsrvd	; save it
	jmp	nomore

	; swi3 - set up swi3 pointer

xswi3:	jsr	numinx	; get pointer in ix
	stx	.swi3	; save it
	jmp	nomore

	; swi2 - set up swi2 pointer

xswi2:	jsr	numinx	; get pointer in ix
	stx	.swi2	; save it
	jmp	nomore

	; firq - set up interrupt pointer

xfirq:	jsr	numinx	; get pointer in ix
	stx	.firq	; save it
	jmp	nomore

	; irq - set up interrupt pointer

xirq:	jsr	numinx	; get pointer in ix
	stx	.irq	; save it
	jmp	nomore

	; swi - set up swi pointer

xswi:	jsr	numinx	; get pointer in ix
	stx	.swi	; save it
	jmp	nomore

	; nmi - set up non-maskable interrupt pointer

xnmi:	jsr 	numinx	; get ponter in ix
	stx	.nmi	; save it
	jmp	nomore

	.page
	.sbttl	compare numbers

	; compare - output sum & difference of two input numbers

compar:	jsr	numinx	; get first number
	stx	ranglo	; put it in ranglo
	jsr	numinx	; get second number
	stx	nbrhi	; save it in nbrhi

	; compute and output the sum

	jsr	sumnum	; compute sum
	ldx	#msgsis	;get its title
	bsr	1$	; output title & sum

	jsr	difnum	; compute difference
	ldx	#msgdis	; get its title
	bsr	1$	; output title & diff

	jmp	nomore

	; compute and output the result

1$:	jsr	outstr	; output it
	ldx	#ranghi	; get result
	jsr	out2by	; display result
	rts

	.page
	.sbttl	dump memory in S1-S9 format

	; *****
	; dump - dump portion of memory in S1-S9 format
	;
	; get address range: start in ranglo (2 bytes), end in
	;		ranghi (2bytes)
	; if no address range is given, use whatever is n
	;		ranlo & ranghi

dump:	jsr	gtrang
	clr	temp5	; initialize to dump to terminal

1$:	lda	#2	; look for a 'TO' modifier
	jsr	comand
	beq	2$
	lble	badsyn	; error if bad syntax
	cmpa	#1	; TO ?
	bne	1$	; go look for another modifier

	jsr	numinx	; get 'TO' address
	stx	outadr	; save it
	inc	temp5	; remember this
	bra	1$	; go look for another modifier

2$:	tst	temp5
	beq	3$
	inc	outflg	; set flag for proper output device

3$:	ldd	ranghi	; compute # of bytes to output
	subd	ranglo	; subtract lo bytes
	cmpd	#16	; diff 0-15.
	bcs	5$	
4$:	ldb	#15

	; to get frame count, add 1
	; (diff of 0 implies 1 output) + # of data bytes
	; + 2 addr bytes + 1 checksum byte

5$:	addb	#4
	stb	temp3	; temp3 is the frame count
	subb	#3
	stb	temp4	; temp4 is the record byte count

	ldx	#msgs1	; output a 'S1' header data record
	jsr	outstr
	clrb		; zero checksum

	ldx	#temp3	; punch frame count
	bsr	7$

	ldx	#ranglo	; punch address
	bsr	7$
	bsr	7$

	ldx	ranglo	; load memory pointer
6$:	bsr	7$	; output data byte
	dec	temp4	; dec byte count
	bne	6$
	stx	ranglo	; save memory pointer

	comb		; complement checksum
	pshs	b	; put it on stack
	tfr	s,x	; let ix point to it
	bsr	7$	; output checksum
	puls	b	; pull it off stack
	ldx	ranglo	; restore memory pointer
	dex
	cpx	ranghi 	; hit end of range?
	bne	3$

	ldx	#msgs9	; yes, output an 'S9' record
	jsr	outstr
	clr	outflg	; set to terminal output
	jmp 	nomore

7$:	jsr	out1by	; output a byte pointed to by ix as
	addb	,x+	; 2 hex characters, update checksum
	rts


	.page
	.sbttl	Load S1-S9 format Data

load:	jsr	inpchr	; get a char
	cmpa	#'S	; is it an S ?
	bne	load

	jsr	inpchr	; got an 'S', examine next character
	cmpa	#'9	; done if its a '9'
	beq	3$

	cmpa	#'1	; is it a '1'?
	bne	load	; if not, look for next 'S'

	clr	cksm	; clear checksum

	jsr	5$	; read record byte count
	suba	#2
	sta	bytect	; save count minus 2 address bytes

	bsr	4$	; build address

1$:	bsr	5$	; read a data byte into acca
	dec	bytect	; count it
	beq	2$	; if done with record, check checksum
	sta	,x+	; not done, store byte in memory
	bra	1$	; on to next memory address

2$:	inc 	cksm	; test checksum by adding 1
	beq	load	; if ok, result should be zero

	ldx	#msgnve	; record checksum error
	jsr	outstr
	ldx	#temp1	; get record address of it
	jsr	out2by	; type it too
3$:	clr	inpflg	; reset flag to normal terminal input
	jmp 	nomore

4$:	bsr	5$	; build address
	sta	temp1
	bsr	5$
	sta	temp1+1
	ldx	temp1
	rts

5$:	bsr	6$	; get left hex digit
	asla		; move to hi 4 bits
	asla
	asla
	asla
	tab		; save it in acca
	bsr	6$	; get right hex digit
	aba		; combine then in acca
	tab		; update the checksum
	addb	cksm
	stb	cksm
	rts

6$:	jsr	inpchr	; input a hex char & convert to internal form
	suba	#'0
	bmi	8$	; not hex if below ascii '1'
	cmpa	#'9-'0
	ble	7$	; ok if ascii '9' or less
	cmpa	#'A-'0	; below ascii 'A'?
	bmi	8$	; error if it is
	cmpa	#'F-'0	; over ascii 'F'?
	bgt	8$	; error if it is
	suba	#7	; conv ascii A-F to hex A-F
7$:	rts

8$:	ldx	#msgcnh	; error - char not hex, say so
	jsr	outstr
	rts

	.page
	.sbttl	Delay Function

	; *****
	; delay - delay specified # of milliseconds

delay:	jsr	numinx	; get delay time
	bsr	timdel
	jmp	nomore

	; *****
	; time delay subroutine
	; ix is input as the # of milliseconds to delay
	; adj timcon so (7*timcon*cycle time=1 ms)

timdel:	pshs	d
1$:	ldd	timcon

2$:	subd	#1	; a 7 cycle loop
	bne	2$

	dex		; decrement millisecond counter
	bne	1$
	puls	d,pc

	.page
	.sbttl	Help List

help:	jsr	docrlf	; next line
	ldx	#comlst	; command list

1$:	ldb	#4	; commands per line
	stb	temp1

2$:	ldb	#12	; positions per command
			; must be larger than longest command
3$:	lda	,x+	; get character
	cmpa	#cr	; <cr> is end of command
	beq	4$
	jsr	outchr	; print command character
	decb
	bne	3$

4$:	lda	,x	; get character
	cmpa	#lf	; <lf> is end of list
	beq	6$	; finished
	dec	temp1	; per line done ?
	bne	5$	; no - skip

	jsr	docrlf	; next line
	bra	1$

5$:	lda	#' 	; space
	jsr	outchr
	decb
	bne	5$
	bra	2$

6$:	jsr	docrlf	; next line
	jmp	nomore

	.page
	.sbttl	Command Lists

	;================================================
	;
	; c o m m a n d   l i s t   s c a n n i n g 
	;    r o u t i n e
	;
	; this routine seeks a match of the characters pointed
	; at by the input line scanning pointer to one of the
	; commands in a list specified by acca.
	; the result of the scan for a match is returned in
	; acca as follows:
	;
	;	acca=-1: the match was unsuccessful. the syntax
	;		 pointer (synptr) was not updated
	;			(advanced).
	;
	;	acca= 0: the match was unsuccessful since there
	;			were
	;		  no more characters, i.e., the end of
	;			the
	;		line was reached.
	;
	;	acca=+n: successful match. the syntax pointer
	;			was updated
	;		 to the first character following the 
	;		  command
	;		  delimiter.  acca holds the number of
	;		      the
	;		  command matched.
	; global variables for external communication
	; synptr - good syntax input line char pointer
	; linptr - input line character pointer
	; delim - class of permissible command delimiters
	;
	; temporary 2 byte internal variables
	; lisptr - command list character pointer
	;
	; temporary 1 byte internal variables
	; nummat - number of characters that successfully match
	; lisnum - # of list within which a match will be sought
	; comnum - command number matched
	;
	; constants used
	; cr - carriage return
	; lf - line feed
	;
	; a, b & ix are not preserved

comand:	sta	lisnum	; save list # to match within
	jsr	skpdlm	; test if we are at the end of the line
	bcc	1$
	clra
	rts

	; initialize the command list pointer to one less than
	; 		the beginning of the command lists

1$:	ldx	comadr	; entry point

	; move to the beginning of the desired command list

	lda	lisnum	; search for 'string' # lisnum
	ldb	#lf	; use lf as a 'string' terminator
	bsr	fndstr
	stx	lisptr

	; the list pointer, lisptr, now points to one less than
	; the first character
	; of the first command in the desired list

	clr	comnum

	; reset input line pointer to: 1) beginning of line, or
	; to 2) point where last successful scan terminated

2$:	inc	comnum	; initialize the command # to 1
	ldx	synptr
	stx	linptr
	clr	nummat	; clear number of characters
			; matched
3$:	jsr	mgetchr	; get input line char in accb
	jsr	tstdlm	; test for a delimiter
	bne	4$	; success (found delimiter)
	jsr	getlst	; get command list char in acca
	cmpa	#lf	; has end of command list been reached ?
	beq	5$	; if so, potential match failure
	cmpa	#cr	; has end of command been reached ?
	beq	5$	; if so, potential match failure
	cba		; compare the two characters
	bne	6$	; match not possible on this command
	inc	nummat	; they match, compare the succeeding characters
	bra	3$	; inc number of characters matched

4$:	ldx	linptr	; successful match
	stx	synptr	; update good syntax pointer
	lda	comnum	; return command number
	rts

	; no match

5$:	tst	nummat	; did at least one match?
	beq	6$	; to next command if none matched
	jsr	tstdlm	; at least one matched - test for delimiter
	bne	4$	; if a delimiter, match has been achieved
	lda	,x	; retrieve last character

	; illegal delimiter
	; move to next command within list

6$:	cmpa	#lf	; end of this list?
	beq	7$	; if so, nothing on list matched
	cmpa	#cr	; is it a cr?
	beq	2$	; yes, next command
	jsr	getlst	; get next command list character
	bra	6$	; no, get to end of command

7$:	clra	; match failure
	deca	; no match possible within this list
	rts

	.page
	.sbttl	Typeout Command

	;====================================
	; this routine types out command number "comnum"
	; the list is specified in acca
	; accb & ix are preserved

typcmd:	pshs	b,x
	ldx  #comlst-1	; move to head of command lists
	ldb	#lf	; and list terminator
	bsr	fndstr	; go to head of desired list
	lda	comnum	; get command number
	ldb	#cr	; get command terminator
	bsr	fndstr	; go to head of desired command

1$:	inx		; move to next character
	lda	,x	; get a command character
	cmpa	#cr	; is it a command terminator?
	beq	2$	; if so, return
	jsr	outchr	; no, type it
	bra	1$

2$:	puls	b,x,pc

	.page
	.sbttl	Find string

	;======================================
	; move to beginning of desired string number (in acca)
	; each string is terminated by an end of string
	;   character (in accb)
	; the index register is assumed initialized pointing to
	; one less than the first character of the first string
	; acca, accb & ix are not preserved
	; local variables
	; strnum - string # to find
	; eoschr - "end of string" character

fndstr:	sta	strnum	; save string number
	stb	eoschr	; save terminator
	clrb
1$:	incb		; string 1 is the first string
	cmpb	strnum	; is this the right string?
	beq	3$	; if so, done

	; no, swallow up characters until an end of string char is hit

2$:	inx		; bump pointer to next one
	lda	,x	; get char pointed at
	cmpa	eoschr	; end of string hit?
	beq	1$	; if it is, bump the string counter
	bra	2$	; no, move on to next char
3$:	rts		; ix set properly, return

	.page
	.sbttl	Skip Leading Delimiters

	;=================================================
	; skip leading delimiters
	; this routine should be called prior to scanning for
	; any information
	; on the input line
	; the current character is ignored if the scannng
	; pointer is at the beginning of a line. if not, the
	; scanning pointer skips over spaces and commas
	; until an end of line or non-delimiter is found.
	; the carry bit is set if and end of line is encountered.

	; acca, accb, & ix are not preserved

skpdlm:	clc
	tst	bolflg	; at beginning of line?
	bgt	2$

	; look at current input character

1$:	ldx	synptr	; get pointer to it
	lda	,x	; get char
	bsr	tsteol	; test for end of line
	bne	2$
	sec		; yes, end hit, set carry
	rts

	; "peek" at next char in line

2$:	ldb	1,x	; get it
	bsr	tstdlm	; see if its a delimiter
	bne	3$
	rts		; if not, return

	; next char is a delimiter

3$:	jsr	mgetchr	; move to next char in input line
	stx	synptr	; update syntax pointer
	bra	1$	; go test for end of line


	.page
	.sbttl	Test for End-of-Line Character

	;============================================
	; test for end-of-line character
	; z bit of cc reg set if char in acca is a terminator
	; acca, accb, & ix are preserved

tsteol:	cmpa	#cr	; carriage return?
	beq	1$
	cmpa	#lf	; line feed? (continued lines)
	beq	1$
	cmpa	#';	; for several commands on one line
1$:	rts

	.sbttl	Test for Delimeter

	;===============================================
	; check the character n accb aganst the delimiter(s) 
	; specified by variable delim
	; accb & ix are preserved
	; acca is set to 0 if accb is not a delimiter, to 1
	; if it is
	;  if delim=1, space s delimiter
	;  if delim=2, comma is delimiter
	;  if delim=3, space or comma is delimiter
	;  if delim=4, any non-alphanumeric is a delimiter
	; test for end-of-line (logical or physical)

tstdlm:	pshs b
	tba
	bsr	tsteol
	puls b
	beq	5$

	lda	delim
	cmpa	#1
	bne	1$
	cmpb	#' 	; want a space - is it?
	bne	6$
	bra	5$

1$:	cmpa	#2
	bne	3$
2$:	cmpb	#',	; want a comma - is it?
	bne	6$
	bra	5$
3$:	cmpa	#3
	bne	4$
	cmpb	#' 	; want either, is it a space?
	beq	5$
	bra	2$	; or a comma?

4$:	cmpa	#4
	bne	7$	; error if delm not 1-4
	cmpb	#'0	; test if char is 0-9 inclusive
	blt	5$
	cmpb	#'9
	ble	6$

	cmpb	#'A	; test if char is A to Z inclusive
	blt	5$
	cmpb	#'Z
	ble	6$	; over Z - its a delimiter

5$:	lda	#1	; char in accb is a delimiter
	rts

6$:	clra		; char in accb is not a delimiter
	rts
			; error in specifying delimiter class
7$:	swi		; have monitor type out pertinent
			; statistics

	.page
	.sbttl	Sum Two Numbers

	;================================================
	; add the 2 byte number stored in (ranglo,ranglo+1) to 
	; the number stored in (nbrhi,nbrlo) and put the result
	; in (ranghi,ranghi+1)

sumnum:	pshs	d	; add lo order bytes
	ldd	ranglo
	addd	nbrhi
	std	ranghi
	puls	d,pc

	.sbttl	Subtract Two Numbers

	;====================================================
	; subtract the 2 byte number stored in (nbrhi,nbrlo)
	; from the two byte number stored in (ranglo,ranglo+1)
	; and put the result in (ranghi,ranghi+1)
	; accb & ix are preserved
	; acca is altered

difnum:	pshs	d	; subtract lo order bytes
	ldd	ranglo
	subd	nbrhi
	std	ranghi
	puls	d,pc

	.page
	.sbttl	Get Range

	;===================================================
	; this routine scans the input line for a pair of numbers
	; representing an address range. a colon separating the
	; pair implies "thru", while an "!" implies "thru the
	; following"
	; e.g., 100:105 is equivalent to 100!5
	; a single number implies a range of 1
	; on return (ranglo,ranglo+1) holds the range start, and
	; (ranghi,ranghi+1) holds the range end
	; acca, accb, & ix are not preserved

gtrang:	bsr	mnumber	; pick up first number
	bgt	1$
	blt	2$
	rts		; nothing more on input line


1$:	ldx	nbrhi	; good single number
	stx	ranglo	; transfer it to ranglo
	bra	3$	; and to ranghi

	; bad number, but is it bad due to a ":" or "!" delimiter?
	; get the terminator for the first number

2$:	ldx	linptr
	lda	,x
	cmpa	#':	; was it a colon?
	bne	4$	; if not, go test for "!"
	bsr	8$	; was ":", process first number &
			; get next one
	ble	5$	; illegal if end of line or non-numeric

3$:	ldx	nbrhi	; transfer second number to ranghi
	stx	ranghi
	bra	7$

4$:	cmpa	#'!	; was delimiter a "!"?
	beq	6$	; if yes, get 2nd number
	clra		; illegal delimiter, return
	deca
5$:	rts

6$:	bsr	8$	; was "!", process first number &
			; get next one
	ble	5$
	bsr	sumnum	; compute range end, put into ranghi

7$:	lda	#1	; successful exit
	rts

	; update syntax pointer, move first number to ranglo,
	; & get 2nd number

8$:	stx	synptr	; update syntax pointer
	ldx	nbrhi	; get first number of the pair
	stx	ranglo	; save it in "low range" value
	bsr	mnumber	; pick up the second number of the pair
	rts

	.page
	.sbttl	Get number in IX

	;====================================================
	; get a 2 byte number & return it in the index register

numinx:	bsr	mnumber
	bgt	1$
	jmp	badsyn
1$:	ldx	nbrhi
	rts

	.page
	.sbttl	Scan For a Number

	;==================================================
	; scan for a number
	; return the most significant byte in nbrhi
	; and the least significant byte in nbrlo
	; the result of the scan for a number is returned in
	; acca as follows:
	;
	;	acca=-1: the match was unsuccessful. the syntax
	;		pointer (synptr) was not updated.
	;
	;	acca= 0: the scan was unsuccessful since there
	;		were no more characters. (i.e., the end
	;		of the line was encountered.)
	;
	;	acca=+1: the scan was successful. the syntax
	;		pointer was updated to the first character
	;		following the command.
	;
	; ix is preserved
	; global variables for external communication
	; nbrhi - number hi byte
	; nbrlo - number lo byte
	; ibcode - input base code
	; dbcode - display base code
	;
	; local variables
	; nbr2x - used in decimal conversion
	; initialize both bytes to zero

mnumber:pshs	x	; save ix
	clr	nbrhi
	clr	nbrlo
	ldx	synptr	; initialize the line scanning pointer
	stx	linptr
	jsr	skpdlm	; are we at end of line?
	bcc	1$
	clra		; yes, zero acca
	puls	x,pc

1$:	jsr	mgetchr	; get a character from the input
			; line into accb
	jsr	tstdlm	; test for a delimiter
	bne	6$	; good delimiter if acca is non-zero
	subb	#'0	; subtract ascii 0
	bmi	8$	; error if less

	lda	ibcode	; determine input base & go to right routine
	cmpa	#1	; hex code ?
	beq	2$

	cmpa	#2	; decimal code ?
	beq	4$

	cmpa	#3	; octal code ?
	beq	5$

	; hex input processing

2$:	cmpb	#'9-'0	; default an illegal input base to hex
	ble	3$	; if 9 or less
	cmpb	#'A-'0
	bmi	8$	; not hex if < A
	cmpb	#'F-'0
	bgt	8$	; not hex if > F
	subb	#7	; move A-F above 0-9

3$:	bsr	9$	; shift lo & hi bytes left 4 bits
	bsr	9$
	orb	nbrlo
	stb	nbrlo
	bra	1$

	; decimal input

4$:	cmpb	#9
	bgt	8$	; not decimal if > 9

	; multiply saved value by 10 & add in new digit

	bsr	10$	; multiply current number by 2 to get 2x value
	ldx	nbrhi	; save this *2 number temporarily
	stx	nbr2x
	bsr	9$	; multiply this # by 4 to get 8x value
	clra		; new digit <a,b>
	addd	nbr2x	; note that 10x=2x+8x
	bcs	8$	; carry out of ms byte is an error
	addd	nbrhi
	bcs	8$	; carry out of ms byte is an error
	std	nbrhi	; save result
	bra	1$

	; octal input

5$:	cmpb	#7
	bgt	8$	; not octal if > 7
	bsr	9$	; shift hi & lo bytes 3 places left
	bsr	10$	; carry out of hibyte is illegal
	orb	nbrlo	; add in new digit
	stb	nbrlo
	bra	1$

6$:	ldx	linptr	; good number - scan was successful
	stx	synptr	; update good syntax line pointer
	lda	#1	; set "good scan" flag
	puls	x,pc

7$:	leas	2,s
8$:	clra		; conversion error - scan was unsuccessful
	deca
	puls	x,pc

9$:	asl	nbrlo	; shift a two byte number left one position
	rol	nbrhi
	bcs	7$
10$:	asl	nbrlo	; shift a two byte number left one position
	rol	nbrhi
	bcs	7$
	rts

	.page
	.sbttl	General Output Routines

	;===========================================
	; output a space

outsp:	lda	#' 
	jsr	outchr
	rts

	;===========================================
	; output an "=" sign

outeq:	lda	#'=
	jsr	outchr
	rts

	;==========================================
	; output a 1 byte number

out1by:	pshs	d
	ldb	#1
	bsr	outnum
	puls	d,pc

	;==========================================
	; output a 2 byte number

out2by:	pshs	d
	ldb	#2
	bsr	outnum
	puls	d,pc

	;==========================================
	; display the number pointed at by the address in the
	; index register and output it according to the base
	; specified in "dbcode"
	; leading zeros are included
	; acca & ix are preserved
	; accb is input as the number of bytes comprising the
	; number.
	; global variables for external communication
	; ibcode - input base code
	; dbcode - display base code
	;
	; local variables
	; decdig - decimal digit being built
	; numbhi - hi byte of number being output
	; numblo - lo byte of number being output

outnum:	pshs	d,x	; save these
	ldx	,x	; get the two bytes at that address
	stx	numbhi	; put them in a scratch area for processing
	lda	dbcode	; get display base

	cmpa	#1
	beq	1$
	cmpa	#2
	beq	4$
	cmpa	#3
	beq	11$
	cmpa	#4
	beq	14$

	; output a hex number

1$:	aslb		; 1 byte=2 chars, 2 bytes=4 chars
2$:	bsr	16$	; get next 4 bits
	bsr	16$

	anda	#0x0f	; extract 4 bits
	cmpa	#9
	ble	3$
	adda	#7	; convert 10:15 to A-F

3$:	bsr	18$
	decb
	bne	2$
	puls	d,x,pc	; restore registers & return

	; output a decimal number

4$:	decb		; test # of bytes to output
	beq	5$
	ldx	#9$	; initialize for output of a 2 byte number
	ldd	numbhi
	bra	6$

5$:	ldx	#10$	; initialize for output of a 1 byte number
	clra
	ldb	numbhi
6$:	clr	decdig	; clear the digit to output
7$:	subd	,x	; subtract the power of 10 conversion constant
	bcs	8$	; test for borrow (carry)
	inc	decdig	; no borrow yet - nc digit being built
	bra	7$	; repeat loop

	; building of digit to output is complete - print it

8$:	pshs	a	; save lo byte of number being output
	lda	decdig	; get digit
	bsr	18$	; print it
	puls	a	; restore lo byte

	addd	,x++	; borrow generated - cancel last subtraction
	cpx	#9$+10	; are we thru with units conversion?
	bne	6$	; if not, back to get next digit
	puls	d,x,pc	; if yes, restore registers & return

	; decimal output conversion constants

9$:	.word	10000
	.word	1000
10$:	.word	100
	.word	10
	.word	1

	; output an octal number

11$:	aslb		; first approximation of # of
	clra		; digits to output
	cmpb	#2
	bgt	12$
	bsr	16$	; 1 byte - get first 2 bits
	bsr	18$
	bra	13$	; go output last 2 digits

12$:	bsr	17$	; two byte # - output hi order bit/digit
	bsr	18$
	incb		; 5 more digits to go

13$:	bsr	16$	; get next 3 bits
	bsr	17$
	anda	#7	; extract 3 bits
	bsr	18$
	decb		; count this digit
	bne	13$	; are we done?
	puls	d,x,pc	; if yes, restore registers & return

14$:	aslb	; output a binary number
	aslb
	aslb
15$:	bsr	17$	; get next bit
	anda	#1	; extract the bit
	bsr	18$	; output it
	decb		; count it
	bne	15$	; are we done?
	puls	d,x,pc	; if yes, restore registers & return

16$:	bsr	17$	; left shift 2 bits

17$:	asl	numblo	; left shift the 3 byte number 1 bit
	rol	numbhi
	rola
	rts

18$:	adda	#'0	; convert to a numeric ascii digit & output it
	jsr	outchr
	rts

	.page
	.sbttl	Get Character Routines

	;=================================================
	; this routine gets the next character from the input
	; line buffer
	; acca is preserved
	; accb is loaded with the character
	; ix is incremented and left pointing to the character
	; returned

mgetchr:
	ldx	linptr
	inx
	ldb	,x
	stx	linptr
	clr	bolflg	; set flag to not at "beginning of line"
	rts

	;==================================================
	; this routine gets the next character in the command
	; lists
	; acca is the character retrieved
	; accb is preserved
	; ix is incremented & left pointing to the character returned

getlst:	ldx	lisptr	; get current list pointer
	inx		; move pointer to next character
	lda	,x	; get character pointed at
	stx	lisptr	; save pointer
	rts		; and return

	.page
	.sbttl	Command Lists

	;=====================================================
	; command lists
	;  a carriage return signifies end-of-command
	;  a line feed signifies end-of-command-list
	; list 1 - major commands

comlst:	.ascii	/BREAK/		; set breakpoint (swi code)
	.byte	cr
	.ascii	/CONTINUE/	; continue from "swi"
	.byte	cr
	.ascii	/COMPARE/	; print sum & difference of 2 numbers
	.byte	cr
	.ascii	/COPY/		; copy from one location to another
	.byte	cr
	.ascii	/DISPLAY/	; display memory data
	.byte	cr
	.ascii	/DBASE/		; set display base
	.byte	cr
	.ascii	/DELAY/		; delay specified # of bytes
	.byte	cr
	.ascii	/DUMP/		; dump memory in mikbug or image format
	.byte	cr
	.ascii	/GOTO/		; go to memory address
	.byte	cr
	.ascii	/HELP/		; help listing
	.byte	cr
	.ascii	/IBASE/		; set input base
	.byte	cr
	.ascii	/LOAD/		; load mikbug tape
	.byte	cr
	.ascii	/REG/		; display registers
	.byte	cr
	.ascii	/SET/		; set memory data
	.byte	cr
	.ascii	/SEARCH/	; search memory for a byte string
	.byte	cr
	.ascii	/TEST/		; test a range of memory
	.byte	cr
	.ascii	/VERIFY/	; verify that memory content is unchanged
	.byte	cr
	.ascii	/CLI/		; clear interrupt mask
	.byte	cr
	.ascii	/CLF/		; clear fast interrupt mask
	.byte	cr
	.ascii	/SEI/		; set interrupt mask
	.byte	cr
	.ascii	/SEF/		; set fast interrupt mask
	.byte	cr
	.ascii	/IRQ/		; set interrupt pointer
	.byte	cr
	.ascii	/FIRQ/		; set fast interrupt pointer
	.byte	cr
	.ascii	/NMI/		; set non-maskable interrupt pointer
	.byte	cr
	.ascii	/RSRVD/		; set reserved interrupt pointer
	.byte	cr
	.ascii	/SWI/		; set software interrupt pointer
	.byte	cr
	.ascii	/SWI2/		; set swi2 interrupt pointer
	.byte	cr
	.ascii	/SWI3/		; set swi3 interrupt pointer
	.byte	cr
	.byte	lf		; end of list 1

	; list 2 - modifier to dump

	.ascii	/TO/		; destination
	.byte	cr
	.byte	lf		; end of list 2

	; list 3 - number base specifiers

	.ascii	/HEX/		; base 16
	.byte	cr
	.ascii	/DEC/		; base 10
	.byte	cr
	.ascii	/OCT/		; base 8
	.byte	cr
	.ascii	/BIN/		; base 2
	.byte	cr
	.byte	lf		; end of list 3

	; list 4 - information request

	.ascii	/?/
	.byte	cr
	.byte	lf		; end of list 4

	; list 5 - register names

	.ascii	/.CC/
	.byte	cr
	.ascii	/.A/
	.byte	cr
	.ascii	/.B/
	.byte	cr
	.ascii	/.DP/
	.byte	cr
	.ascii	/.IX/
	.byte	cr
	.ascii	/.IY/
	.byte	cr
	.ascii	/.IU/
	.byte	cr
	.ascii	/.AB/
	.byte	cr
	.ascii	/.PC/
	.byte	cr
	.ascii	/.SP/
	.byte	cr
	.byte	lf		; end of list 5

	; list 6 - modifiers to "display"

	.ascii	/DATA/
	.byte	cr
	.ascii	/USED/
	.byte	cr
	.byte	lf		; end of list 6

	; list 7 - modifier to "load"

	.ascii	/FROM/		; source
	.byte	cr
	.byte	lf		; end of list 7


	.page
	.sbttl	Get a line

	;=======================================================
	;
	; this routine constructs a line of input by getting all
	; input characters up to and including a carriage return
	; (which then designates "end of line").
	; typing rubout will delete the previous character
	; typing control-c will abort the line
	; typing control-z will use the previous line
	; the input line is stored beginning at the address
	; stored in bufbeg and ending at the address stored
	; in bufend
	; acca, accb, & ix are not preserved
	;
	; global variables
	; bufbeg - input line start of buffer
	; bufend - input line end of buffer
	;
	; local constants

getlin:	ldx	bufbeg	; set pointer to one less than
			; the beginning of the line buffer
	clrb		; accb holds last input char
1$:	cpx	bufend	; check current line end against buffer end
	bne	2$

	; line too long - abort it as if a control-c had been typed

	ldx	#msgltl	; get message
	jsr	outstr	; output it
	ldb	#3	; put ctl-c in accb
	rts

2$:	jsr	inpchr	; get a character (returned in acca)
	anda	#0x7f	; drop parity bit

	; control-z copies from present position to previous end of line

	cmpa	#26	; is char a control-z?
	bne	3$
	jsr	docrlf	; yes, type cr-lf
	rts

3$:	cmpa	#13	; is char a cr?
	beq	4$
	cmpa	#10	; or a lf?
	bne	6$
4$:	inx
	sta	,x	; yes, store the terminator
	tst	hdxflg	; test for half-duplex terminal
	bne	5$
	jsr	docrlf	; type cr-lf
5$:	rts		; now return

6$:	cmpa	#3	; is char a control-c?
	bne	7$	; no
	tab		; return ctl-c in accb
	lda	#'^	; echo an up-arrow
	jsr	outchr
	rts

7$:	cmpa	#127	; no, is it delete?
	beq	10$	; yes - delete character
	inx		; not a delete, so advance to next char
	sta	,x	; store it in inplin
	tab		; last character in b
	tst	hdxflg	; check half duplex
	bne	9$	; yes - skip
	jsr	outchr	; echo character
9$:	bra	1$	; get another

	; current character is a delete
	; test line length - if its zero, ignore this delete
	; since we can't delete prior to first char in input line

10$:	cpx	bufbeg
	beq	1$
	pshs	x
	ldx	#11$	; delete character on screen
	bsr	outstr
	puls	x
	ldb	,-x	; last character
	bra	1$

11$:	.byte  8,32,8,4	; BS, SPACE, BS, EOT


	;====================================================
	; initialization routine

inital:	lda	#1
	sta	ibcode	; set input base to hex
	sta	dbcode	; set display base to hex

	; set up display base number

	lda	#16
	sta	dbnbr

	; max # of characters per line

	lda	#72
	sta	cplmax
	clr	inpflg	; default input from terminal
	clr	outflg	; default output to terminal
	clr	hdxflg	; clear	half-duplex flag

	; set up swi interrupt address pointer

	ldx	#typswi	; type "swi" & do "reg" command
	stx	.swi

	; clear breakpoint address

	ldd	#0xfffe	; normal systems have rom here
	std	brkadr

	; initialize to mondeb's command lists

	ldx	#comlst-1
	stx	comadr

	; time constant for a .5 microsecond clock

	ldd	#285
	std	timcon

	.if	inituser
	jmp	userinit	; user returns via rts
	.else
	rts
	.endif

	;===================================================
	; output a character string which begins at the address
	; in the index register
	; acca & accb are preserved
	; ix is left pointing to the string terminator

outstr:	pshs	a
1$:	lda	,x	; get char pointed to
	cmpa	#4	; is it a string terminator?
	beq	2$	; done if it is
	bsr	outchr	; isn't, output it
	inx		; on to next char
	bra	1$
2$:	puls	a,pc

	;=====================================================
	; input a character

inpchr:	tst	inpflg	; console ?
	bne	2$

1$:	jsr	[conin]	; tst for a character
	bcc	1$	; none - loop until there is
	rts

2$:	jsr	[altin]	; tst for a character
	bcc	2$	; none - loop until there is
	rts

	;======================================================
	; output the character in acca to the desired output
	; device/location
	; if outflg = 0, output is to terminal
	; if outflg # 0, output is to address in outadr
	;    & this address is then incremented

outchr:	pshs	d,x	; save d and x
	ldb	outflg	; test output destination flag
	decb
	ble	1$	; skip this code if terminal output

	; output to something other than terminal

	ldx	outadr	; get output char destination addr
	sta	,x+	; save char in memory
	stx	outadr	; update output address
	puls	d,x,pc

1$:	cmpa	#lf	; ignore line feeds
	bne	2$
	puls	d,x,pc

2$:	cmpa	#cr	; test for carriage return
	bne	3$
	bsr	docrlf
	puls	d,x,pc

3$:	ldb	cplcnt	; get "chars per line" count
	cmpb	cplmax
	bge	4$	; send cr-lf if greater

	; less than max, but also send cr-lf if 10 from end and
	; printing a space

	addb	#10
	cmpb	cplmax
	blt	5$
	cmpa	#' 	; near end, test if about to print a space
	bne	5$

	; terminal line full or nearly full - interject a cr-lf

4$:	bsr	docrlf
5$:	inc	cplcnt	; bump counter
	bsr	chrout	; send it to acia1
	puls	d,x,pc

	;======================================================
	; send a carriage return-line feed to the terminal

docrlf:	pshs	d
	lda	#cr
	bsr	chrout
	lda	#lf
	bsr	chrout
	clr	cplcnt	; zero "chars/line" count
	puls	d,pc

	;======================================================
	; send char in acca

chrout:	tst	outflg	; check destination
	bne	1$
	jmp  [conout]	; output a character
1$:	jmp  [altout]

	;======================================================
	; misc text

msghed:	.ascii	/MONDEB-09 1.00/
	.byte	cr,4
msgprm:	.byte	'*,4
msgswi:	.byte	cr,lf
	.ascii	/swi:/
	.byte	cr,lf,4
msgltl:	.ascii	/too long/
	.byte	4
msgnbr:	.ascii	/not set/
	.byte	4
msgbat:	.ascii	/set @ /
	.byte	4
msgver:	.ascii	/ok/
	.byte	4
msgnve:	.ascii	/checksum error /
	.byte	4
msgccl:	.ascii	/can't clear/
	.byte	4
msgcso:	.ascii	/can't set to ones/
	.byte	4
msgsis:	.ascii	/sum is /
	.byte	4
msgdis:	.ascii	/, dif is /
	.byte	4
msgs1:	.byte	cr,lf,0,0,'S,'1,4
msgs9:	.byte	cr,lf,0
	.ascii	/S9030000FC/
	.byte	cr,lf,4
msgcnh:	.ascii	/char not hex/
	.byte	cr,4


	;****************************************************
	;*            default interrupt transfers           *
	;****************************************************

	.if	standalone
rsrvd:	jmp	[.rsrvd]	; reserved vector
swi3:	jmp	[.swi3]		; swi3 vector
swi2:	jmp	[.swi2]		; swi2 vector
firq:	jmp	[.firq]		; firq vector
irq:	jmp	[.irq]		; irq vector
swi:	jmp	[.swi]		; swi vector
nmi:	jmp	[.nmi]		; nmi vector
	.endif

	.page
	.sbttl	dispatch table

	.if	standalone

	.area	DISPAT	(REL,CON)

	.word	timdel	; time delay for # of ms specified by ix
	.word	cksum	; return checksum of an address range in acca
	.word	mgetchr	; return (in accb) char pointed to by linptr
	.word	getlst	; return (in acca) char pointed to by lisptr
	.word	gtrang	; pick up an address range in ranglo & ranghi
	.word	mnumber	; pick up a number & return it in nbrhi & nbrlo
	.word	skpdlm	; skip over input line delimiters
	.word	tstdlm	; test char in accb for a delimiter
	.word	tsteol	; test char in acca for end-of-line
	.word	comand	; search specified command list for a command
	.word	typcmd	; types out command number "comnum" in list acca
	.word	out1by	; display the 1 byte number pointed at by ix
	.word	out2by	; display the 2 byte number pointed at by ix
	.word	getlin	; get a line of input into the tty buffer
	.word	outstr	; output char string ix points to
	.word	docrlf	; send cr-lf with delay & zero line count
	.word	outchr	; like chrout, but with folding, cr delay, & lf
	.word	chrout	; send acca to console
	.word	inpchr	; get a char, return it in acca
	.word	prompt	; to prompt for new command
	.word	mond09	; start of mondeb
	.endif

	.page
	.sbttl	Hardware Interrupt Tables

	;********************************************************
	;*             MONDEB-09 hardware vector table
	;*
	;*  this table is used if the MONDEB-09 rom addresses
	;*  the mc6809 hardware vectors.
	;********************************************************

	.if	standalone

	.area	INTVEC	(ABS,OVR)

	. = 0xFFF0		; vector position

	.word	rsrvd		; reserved slot
	.word	swi3		; software interrupt 3
	.word	swi2		; software interrupt 2
	.word	firq		; fast interrupt request
	.word	irq		; interrupt request
	.word	swi		; software interrupt
	.word	nmi		; non-maskable interrupt
	.word	reset		; restart
	.endif
