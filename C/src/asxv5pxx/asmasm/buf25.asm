;*			buffalo
;* "bit user's fast friendly aid to logical operation"
;*
;* rev 2.0 - 4/23/85	- added disassembler.
;*			- variables now ptrn and tmpn.
;* rev 2.1 - 4/29/85	- added byte erase to chgbyt routine.
;* rev 2.2 - 5/16/85	- added hooks for evb board - acia
;*			  drivers, init and host routines.
;*	     7/8/85 	- fixed dump wraparound problem.
;*	     7/10/85	- added evm board commands.
;*			- added fill instruction.
;*	     7/18/85	- added jump to eeprom.
;* rev 2.3 - 8/22/85 	- call targco to disconnect sci from host
;*			  in reset routine for evb board.
;*	     10/3/85	- modified load for download through terminal.
;* rev 2.4 - 7/1/86	- changed dflop address to fix conflicts with
;*			  eeprom.  (was at a000)
;* rev 2.5 - 9/8/86	- modified to provide additional protection from
;*			  program run-away on power down.  also fixed bugs
;*			  in mm and move.  changed to 1 stop bit from 2.
;*
;********************************************************
;*	although the information contained herein,	*
;*	as well as any information provided relative	*
;*	thereto, has been carefully reviewed and is	*
;*	believed accurate, motorola assumes no		*
;*	liability arising out of its application or	*
;*	use, neither does it convey any license under	*
;*	its patent rights nor the rights of others.	*
;********************************************************

	.area	BUF25	(ABS,OVR)

	.setdp

;************************
;*	equates		*
;************************

rambs	=	0x0000		; start of ram
regbs	=	0x1000		; start of registers
rombs	=	0xe000		; start of rom
porte	=	regbs+0x0a	; port e
tcnt	=	regbs+0x0e	; timer count
toc5	=	regbs+0x1e	; oc5 reg
tctl1	=	regbs+0x20	; timer control 1
tmsk1	=	regbs+0x22	; timer mask 1
tflg1	=	regbs+0x23	; timer flag 1
tmsk2	=	regbs+0x24	; timer mask 2
baud	=	regbs+0x2b	; sci baud reg
sccr1	=	regbs+0x2c	; sci control1 reg
sccr2	=	regbs+0x2d	; sci control2 reg
scsr	=	regbs+0x2e	; sci status reg
scdat	=	regbs+0x2f	; sci data reg
option	=	regbs+0x39	; option reg
coprst	=	regbs+0x3a	; cop reset reg
pprog	=	regbs+0x3b	; ee prog reg
hprio	=	regbs+0x3c	; hprio reg
config	=	regbs+0x3f	; config register
dflop	=	0x4000		; evb d flip flop
duart	=	0xd000		; duart address
porta	=	duart
portb	=	duart+8
acia	=	0x9800		; acia address
prompt	=	'>
bufflng	=	35
ctla	=	0x01		; exit host or assembler
ctlb	=	0x02		; send break to host
ctlw	=	0x17		; wait
ctlx	=	0x18		; abort
del	=	0x7f		; abort
eot	=	0x04		; end of text/table
swi	=	0x3f

;***************
;* 	ram 	*
;***************

	.org	0x36

;*** buffalo ram space ***

	.blkb	20	; user stack area
ustack:	.blkb	30	; monitor stack area
stack:	.blkb	1
inbuff:	.blkb	bufflng	; input buffer
endbuff	= .
combuff:
	.blkb	8	; command buffer
shftreg:
	.blkb	2	; input shift register
brktabl:
	.blkb	8	; breakpoint table
regs:	.blkb	9	; user's pc,y,x,a,b,c
sp:	.blkb	2	; user's sp
autolf:	.blkb	1	; auto lf flag for i/o
iodev:	.blkb	1	; 0=sci,  1=acia, 2=duarta, 3=duartb
extdev:	.blkb	1	; 0=none, 1=acia, 2=duart,
hostdev:
	.blkb	1	; 0=sci,  1=acia,	    3=duartb
count:	.blkb	1	; # characters read
ptrmem:	.blkb	2	; current memory location

;*** buffalo variables - used by: ***
ptr0:	.blkb	2	; main,readbuff,incbuff,as
ptr1:	.blkb	2	; main,br,du,mo,as
ptr2:	.blkb	2	; du,go,mo,as
ptr3:	.blkb	2	; ho,mo,as
ptr4:	.blkb	2	; go,as
ptr5:	.blkb	2	; as
ptr6:	.blkb	2	; go,as
ptr7:	.blkb	2	; go,as
tmp1:	.blkb	1	; main,hexbin,buffarg,termarg
tmp2:	.blkb	1	; go,ho,as
tmp3:	.blkb	1	; as
tmp4:	.blkb	1	; go,ho,me,as

;*** vector jump table ***
jsci:	.blkb	3
jspi:	.blkb	3
jpaie:	.blkb	3
jpao:	.blkb	3
jtof:	.blkb	3
jtoc5:	.blkb	3
jtoc4:	.blkb	3
jtoc3:	.blkb	3
jtoc2:	.blkb	3
jtoc1:	.blkb	3
jtic3:	.blkb	3
jtic2:	.blkb	3
jtic1:	.blkb	3
jrti:	.blkb	3
jirq:	.blkb	3
jxirq:	.blkb	3
jswi:	.blkb	3
jillop:	.blkb	3
jcop:	.blkb	3
jclm:	.blkb	3

;*****************
;*
;* rom starts here *
;*
;*****************

	.org	rombs

;*****************
;**	buffalo - this is where buffalo starts
;** out of reset.  all initialization is done
;** here including determination of where the
;** user terminal is (sci,acia, or duart).
;*****************

buffalo:
	ldx	#porte
	brclr 0,x,#0x01,bufisit	; if bit 0 of port e is 1
	jmp	0xb600		; then jump to the start of eeprom
bufisit:
	ldaa	#0x93
	staa	option		; adpu, dly, irqe, cop
	ldaa	#0x00
	staa	tmsk2		; timer pre = %1 for trace
	lds	#stack		; monitor stack pointer
	jsr	vecinit
	ldx	#ustack
	stx	*sp		; default user stack
	ldaa	#0xd0
	staa	*regs+8		; default user ccr
	ldd	#0x3f0d		; initial command is ?
	std	*inbuff
	jsr	bpclr		; clear breakpoints
	clr	*autolf
	inc	*autolf		; auto cr/lf = on

;* determine type of external comm device - none, or acia *

	clr	*extdev		; default is none
	ldaa	hprio
	anda	#0x20
	beq	buff2		; jump if single chip mode
	ldaa	#0x03		; see if external acia exists
	staa	acia		; master reset
	ldaa	acia
	anda	#0x7f		; mask irq bit from status register
	bne	buff1		; jump if status reg not 0
	ldaa	#0x12
	staa	acia		; turn on acia
	ldaa	acia
	anda	#0x02
	beq	buff1		; jump if tdre not set
	ldaa	#0x01
	staa	*extdev		; external device is acia
	bra	buff2

buff1	= .			; see if duart exists
	ldaa	duart+0x0c	; read irq vector register
	cmpa	#0x0f		; should be out of reset
	bne	buff2
	ldaa	#0xaa
	staa	duart+0x0c	; write irq vector register
	ldaa	duart+0x0c	; read irq vector register
	cmpa	#0xaa
	bne	buff2
	ldaa	#0x02
	staa	*extdev		; external device is duart a

;* find terminal port - sci or external. *

buff2:	clr	*iodev
	jsr	targco		; disconnect sci for evb board
	jsr	signon		; initialize sci
	ldaa	*extdev
	beq	buff3		; jump if no external device
	staa	*iodev
	jsr	signon		; initialize external device
buff3:	clr	*iodev
	jsr	input		; get input from sci port
	cmpa	#0x0d
	beq	buff4		; jump if cr - sci is terminal port
	ldaa	*extdev
	beq	buff3		; jump if no external device
	staa	*iodev
	jsr	input		; get input from external device
	cmpa	#0x0d
	beq	buff4		; jump if cr - terminal found ext
	bra	buff3

signon:	jsr	init		; initialize device
	ldx	#msg1		; buffalo message
	jsr	outstrg
	rts

;* determine where host port should be.

buff4:	clr	*hostdev		; default - host = sci port
	ldaa	*iodev
	cmpa	#0x01
	beq	buff5		; default host if term = acia
	ldaa	#0x03
	staa	*hostdev		; else host is duart port b
buff5	= .

;*****************
;**	main - this module reads the user's input into
;** a buffer called inbuff.  the first field (assumed
;** to be the command field) is then parsed into a
;** second buffer called combuff.  the command table
;** is then searched for the contents of combuff and
;** if found, the address of the corresponding task
;** routine is fetched from the command table.  the
;** task is then called as a subroutine so that
;** control returns back to here upon completion of
;** the task.  buffalo expects the following format
;** for commands:
;**	<cmd>[<wsp><arg><wsp><arg>...]<cr>
;** [] implies contents optional.
;** <wsp> means whitespace character (space,comma,tab).
;** <cmd> = command string of 1-8 characters.
;** <arg> = argument particular to the command.
;** <cr> = carriage return signifying end of input string.
;*****************
;* prompt user
;*do
;*	a=input();
;*	if(a==(cntlx or del)) continue;
;*	elseif(a==backspace)
;*	b--;
;*	if(b<0) b=0;
;*	else
;*	if(a==cr && buffer empty)
;*		repeat last command;
;*	else put a into buffer;
;*		check if buffer full;
;*while(a != (cr or /)

main:	lds	#stack		; initialize sp every time
	clr	*autolf
	inc	*autolf		; auto cr/lf = on
	jsr	outcrlf
	ldaa	#prompt		; prompt user
	jsr	output
	clrb
main1:	jsr	inchar		; read terminal
	ldx	#inbuff
	abx			; pointer into buffer
	cmpa	#ctlx
	beq	main		; jump if cntl x
	cmpa	#del
	beq	main		; jump if del
	cmpa	#0x08
	bne	main2		; jump if not bckspc
	decb
	blt	main		; jump if buffer empty
	bra	main1
main2:	cmpa	#0xd
	bne	main3		; jump if not cr
	tstb
	beq	comm0		; jump if buffer empty
	staa	,x		; put a in buffer
	bra	comm0
main3:	staa	,x		; put a in buffer
	incb
	cmpb	#bufflng
	ble	main4		; jump if not long
	ldx	#msg3		; "long"
	jsr	outstrg
	bra	main
main4:	cmpa	#'/
	bne	main1		; jump if not "/"
;*	*******************

;*****************
;*	parse out and evaluate the command field.
;*****************
;*initialize

comm0	= .
	clr	*tmp1		; enable "/" command
	clr	*shftreg
	clr	*shftreg+1
	clrb
	ldx	#inbuff		; ptrbuff[] = inbuff[]
	stx	*ptr0
	jsr	wskip		; find first char

;*while((a=readbuff) != (cr or wspace))
;*	upcase(a);
;*	buffptr[b] = a
;*	b++
;*	if (b > 8) error(too long);
;*	if(a == "/")
;*		if(enabled) mslash();
;*		else error(command?);
;*	else hexbin(a);

comm1	= .
	jsr	readbuff	; read from buffer
	ldx	#combuff
	abx
	jsr	upcase		; convert to upper case
	staa	,x		; put in command buffer
	cmpa	#0x0d
	beq	srch		; jump if cr
	jsr	wchek
	beq	srch		; jump if wspac
	jsr	incbuff		; move buffer pointer
	incb
	cmpb	#0x8
	ble	comm2
	ldx	#msg3		; "long"
	jsr	outstrg
	jmp	main

comm2	= .
	cmpa	#'/
	bne	comm4		; jump if not "/"
	tst	*tmp1
	bne	comm3		; jump if not enabled
	stab	*count
	ldx	#mslash
	jmp	exec		; execute "/"
comm3:	ldx	#msg8		; "command?"
	jsr	outstrg
	jmp	main
comm4	= .
	jsr	hexbin
	bra	comm1

;*****************
;*	search tables for command.	at this point,
;* combuff holds the command field to be executed,
;* and b =	# of characters in the command field.
;* the command table holds the whole command name
;* but only the first n characters of the command
;* must match what is in combuff where n is the
;* number of characters entered by the user.
;*****************
;*count = b;
;*ptr1 = comtabl;
;*while(ptr1[0] != end of table)
;*	ptr1 = next entry
;*	for(b=1; b=count; b++)
;*	if(ptr1[b] == combuff[b]) continue;
;*	else error(not found);
;*	execute task;
;*	return();
;*return(command not found);

srch:	stab	*count		; size of command entered
	ldx	#comtabl	; pointer to table
	stx	*ptr1		; pointer to next entry
srch1:	ldx	*ptr1
	ldy	#combuff	; pointer to command buffer
	ldab	0,x
	cmpb	#0xff
	bne	srch2
	ldx	#msg2		; "command not found"
	jsr	outstrg
	jmp	main
srch2:	pshx			; compute next table entry
	addb	#0x3
	abx
	stx	*ptr1
	pulx
	clrb
srchlp:	incb			; match characters loop
	ldaa	1,x		; read table
	cmpa	0,y		; compare to combuff
	bne	srch1		; try next entry
	inx			; move pointers
	iny
	cmpb	*count
	blt	srchlp		; loop countu1 times
	ldx	*ptr1
	dex
	dex
	ldx	0,x		; jump address from table
exec:	jsr	0,x		; call task as subroutine
	jmp	main
;*
;*****************
;*	utility subroutines - these routines
;* are called by any of the task routines.
;*****************
;*****************
;*	upcase(a) - if the contents of a is alpha,
;* returns a converted to uppercase.
;*****************
upcase:	cmpa	#'a
	blt	upcase1		; jump if < a
	cmpa	#'z
	bgt	upcase1		; jump if > z
	suba	#0x20		; convert
upcase1:
	rts

;*****************
;*	bpclr() - clear all entries in the
;* table of breakpoints.
;*****************
bpclr:	ldx	#brktabl
	ldab	#8
bpclr1:	clr	0,x
	inx
	decb
	bgt	bpclr1		; loop 8 times
	rts

;*****************
;*	rprnt1(x) - prints name and contents of a single
;* user register. on entry x points to name of register
;* in reglist.  on exit, a=register name.
;*****************
reglist:
	.ascii	'PYXABCS'	; names
	.byte	0,2,4,6,7,8,9	; offset
	.byte	1,1,1,0,0,0,1	; size

rprnt1:	ldaa	0,x
	psha
	pshx
	jsr	output		; name
	ldaa	#'-
	jsr	output		; dash
	ldab	7,x		; contents offset
	ldaa	14,x		; bytesize
	ldx	#regs		; address
	abx
	tsta
	beq	rprn2		; jump if 1 byte
	jsr	out1byt		; 2 bytes
rprn2:	jsr	out1bsp
	pulx
	pula
	rts

;*****************
;*	rprint() - print the name and contents
;* of all the user registers.
;*****************
rprint:	pshx
	ldx	#reglist
rpri1:	jsr	rprnt1		; print name
	inx
	cmpa	#'S		; s is last register
	bne	rpri1		; jump if not done
	pulx
	rts

;*****************
;*	hexbin(a) - convert the ascii character in a
;* to binary and shift into shftreg.  returns value
;* in tmp1 incremented if a is not hex.
;*****************
hexbin:	psha
	pshb
	pshx
	jsr	upcase		; convert to upper case
	cmpa	#'0
	blt	hexnot		; jump if a < 0x30
	cmpa	#'9
	ble	hexnmb		; jump if 0-9
	cmpa	#'A
	blt	hexnot		; jump if 0x39> a <0x41
	cmpa	#'F
	bgt	hexnot		; jump if a > 0x46
	adda	#0x9		; convert 0xa-0xf
hexnmb:	anda	#0x0f		; convert to binary
	ldx	#shftreg
	ldab	#4
hexshft:
	asl	1,x		; 2 byte shift through
	rol	0,x		; carry bit
	decb
	bgt	hexshft		; shift 4 times
	oraa	1,x
	staa	1,x
	bra	hexrts
hexnot:	inc	*tmp1		; indicate not hex
hexrts:	pulx
	pulb
	pula
	rts

;*****************
;*	buffarg() - build a hex argument from the
;* contents of the input buffer. characters are
;* converted to binary and shifted into shftreg
;* until a non-hex character is found.  on exit
;* shftreg holds the last four digits read, count
;* holds the number of digits read, ptrbuff points
;* to the first non-hex character read, and a holds
;* that first non-hex character.
;*****************
;*initialize
;*while((a=readbuff()) not hex)
;*	hexbin(a);
;*return();

buffarg:
	clr	*tmp1		; not hex indicator
	clr	*count		; # or digits
	clr	*shftreg
	clr	*shftreg+1
	jsr	wskip
bufflp:	jsr	readbuff	; read char
	jsr	hexbin
	tst	*tmp1
	bne	buffrts		; jump if not hex
	inc	*count
	jsr	incbuff		; move buffer pointer
	bra	bufflp
buffrts:
	rts

;*****************
;*	termarg() - build a hex argument from the
;* terminal.  characters are converted to binary
;* and shifted into shftreg until a non-hex character
;* is found.  on exit shftreg holds the last four
;* digits read, count holds the number of digits
;* read, and a holds the first non-hex character.
;*****************
;*initialize
;*while((a=inchar()) == hex)
;*	if(a = cntlx or del)
;*		abort;
;*	else
;*		hexbin(a); countu1++;
;*return();

termarg:
	clr	*count
	clr	*shftreg
	clr	*shftreg+1
term0:	jsr	inchar
	cmpa	#ctlx
	beq	term1		; jump if controlx
	cmpa	#del
	bne	term2		; jump if not delete
term1:	jmp	main		; abort
term2:	clr	*tmp1		; hex indicator
	jsr	hexbin
	tst	*tmp1
	bne	term3		; jump if not hex
	inc	*count
	bra	term0
term3:	rts

;*****************
;*	chgbyt() - if shftreg is not empty, put
;* contents of shftreg at address in x.	if x
;* is an address in eeprom then program it.
;*****************
;*if(count != 0)
;*	(x) = a;
;*	if(((x) != a) && (x == eeprom location))
;*	if((x) != 0xff) byte erase (x);
;*	if(a != 0xff) program(x) = a);
;*	if((x) != a) error(rom)
;*return;

chgbyt:	tst	*count
	beq	chgbyt4		; jump if shftreg empty
	ldaa	*shftreg+1
	staa	0,x		; attempt to write
	ldaa	0,x
	cmpa	*shftreg+1
	beq	chgbyt3		; jump if it worked
	cpx	#config
	beq	chgbyt1		; jump if config reg
	cpx	#0xb600
	blo	chgbyt3		; jump if not ee
	cpx	#0xb7ff
	bhi	chgbyt3		; jump if not ee
chgbyt1	= .
	ldaa	0,x
	cmpa	#0xff
	beq	chgbyt2		; jump if already erased
	ldaa	#0x16		; do byte erase
	staa	pprog
	ldaa	#0xff
	staa	0,x
	ldaa	#0x17
	bne	acl1
	clra			; fail safe
acl1:	staa	pprog
	bsr	chgwait
	ldaa	#0x00
	staa	pprog		; end of byte erase
chgbyt2	= .
	ldaa	*shftreg+1
	cmpa	#0xff
	beq	chgbyt3		; jump if no need to program
	ldaa	#0x02		; do byte program
	staa	pprog
	ldaa	*shftreg+1
	staa	0,x
	ldaa	#0x03
	bne	acl2
	clra			; fail safe
acl2:	staa	pprog
	bsr	chgwait
	ldaa	#0x00
	staa	pprog		; end of byte program
chgbyt3	= .
	ldaa	,x
	cmpa	*shftreg+1
	beq	chgbyt4
	pshx
	ldx	#msg6		; "rom"
	jsr	outstrg
	jsr	outcrlf
	pulx
chgbyt4	= .
	rts

chgwait	= . 		; delay 10 ms at E = 2mhz
	pshx
	ldx	#0x0d06
chgwait1:
	dex
	bne	chgwait1
	pulx
	rts

;*****************
;*	readbuff() -  read the character in inbuff
;* pointed at by ptrbuff into a.  returns ptrbuff
;* unchanged.
;*****************
readbuff:
	pshx
	ldx	*ptr0
	ldaa	0,x
	pulx
	rts

;*****************
;*	incbuff(), decbuff() - increment or decrement
;* ptrbuff.
;*****************
incbuff:
	pshx
	ldx	*ptr0
	inx
	bra	incdec
decbuff:
	pshx
	ldx	*ptr0
	dex
incdec:	stx	*ptr0
	pulx
	rts

;*****************
;*	wskip() - read from the inbuff until a
;* non whitespace (space, comma, tab) character
;* is found.  returns ptrbuff pointing to the
;* first non-whitespace character and a holds
;* that character.
;*****************
wskip:	jsr	readbuff	; read character
	jsr	wchek
	bne	wskip1		; jump if not wspc
	jsr	incbuff		; move pointer
	bra	wskip		; loop
wskip1:	rts

;*****************
;*	wchek(a) - returns z=1 if a holds a
;* whitespace character, else z=0.
;*****************
wchek:	cmpa	#0x2c		; comma
	beq	wchek1
	cmpa	#0x20		; space
	beq	wchek1
	cmpa	#0x09		; tab
wchek1:	rts

;*****************
;*	dchek(a) - returns z=1 if a = whitespace
;* or carriage return.	else returns z=0.
;*****************
dchek:	jsr	wchek
	beq	dchek1		; jump if whitespace
	cmpa	#0x0d
dchek1:	rts

;*****************
;*	chkabrt() - checks for a control x or delete
;* from the terminal.  if found, the stack is
;* reset and the control is transferred to main.
;* note that this is an abnormal termination.
;*	if the input from the terminal is a control w
;* then this routine keeps waiting until any other
;* character is read.
;*****************
;*a=input();
;*if(a=cntl w) wait until any other key;
;*if(a = cntl x or del) abort;

chkabrt:
	jsr	input
	beq	chk4		; jump if no input
	cmpa	#ctlw
	bne	chk2		; jump in not cntlw
chkabrt1:
	jsr	input
	beq	chkabrt1	; jump if no input
chk2:	cmpa	#del
	beq	chk3		; jump if delete
	cmpa	#ctlx
	beq	chk3		; jump if control x
	cmpa	#ctla
	bne	chk4		; jump not control a
chk3:	jmp	main		; abort
chk4:	rts			; return

;***********************
;*	hostco - connect sci to host for evb board.
;*	targco - connect sci to target for evb board.
;***********************
hostco:	psha
	ldaa	#0x01
	staa	dflop		; send 1 to d-flop
	pula
	rts

targco:	psha
	ldaa	#0x00
	staa	dflop		; send 0 to d-flop
	pula
	rts

;*
;**********
;*
;*	vecinit - this routine checks for
;*	vectors in the ram table.	all
;*	uninitialized vectors are programmed
;*	to jmp stopit
;*
;**********
;*
vecinit:
	ldx	#jsci		; point to first ram vector
	ldy	#stopit		; pointer to stopit routine
	ldd	#0x7e03		; a=jmp opcode; b=offset
vecloop:
	cmpa	0,x
	beq	vecnext		; if vector already in
	staa	0,x		; install jmp
	sty	1,x		; to stopit routine
vecnext:
	abx			; add 3 to point at next vector
	cpx	#jclm+3		; done?
	bne	vecloop		; if not, continue loop
	rts
;*
stopit:	ldaa	#0x50		; stop-enable; irq, xirq-off
	tap
	stop			; you are lost!	shut down
	jmp	stopit		; in case continue by xirq

;**********
;*
;*	i/o module
;*	communications with the outside world.
;* 3 i/o routines (init, input, and output) call
;* drivers specified by iodev (0=sci, 1=acia,
;* 2=duarta, 3=duartb).
;*
;**********
;*	init() - initialize device specified by iodev.
;*********
;*
init	= .
	psha			; save registers
	pshx
	ldaa	*iodev
	cmpa	#0x00
	bne	init1		; jump not sci
	jsr	onsci		; initialize sci
	bra	init4
init1:	cmpa	#0x01
	bne	init2		; jump not acia
	jsr	onacia		; initialize acia
	bra	init4
init2:	ldx	#porta
	cmpa	#0x02
	beq	init3		; jump duart a
	ldx	#portb
init3:	jsr	onuart		; initialize duart
init4:	pulx			; restore registers
	pula
	rts

;**********
;*	input() - read device. returns a=char or 0.
;*	this routine also disarms the cop.
;**********
input	= .
	pshx
	ldaa	#0x55		; reset cop
	staa	coprst
	ldaa	#0xaa
	staa	coprst
	ldaa	*iodev
	bne	input1		; jump not sci
	jsr	insci		; read sci
	bra	input4
input1:	cmpa	#0x01
	bne	input2		; jump not acia
	jsr	inacia		; read acia
	bra	input4
input2:	ldx	#porta
	cmpa	#0x02
	beq	input3		; jump if duart a
	ldx	#portb
input3:	jsr	inuart		; read uart
input4:	pulx
	rts

;**********
;*	output() - output character in a.
;**********

output	= .
	psha			; save registers
	pshb
	pshx
	ldab	*iodev
	bne	output1		; jump not sci
	jsr	outsci		; write sci
	bra	output4
output1:
	cmpb	#0x01
	bne	output4		; jump not acia
	jsr	outacia		; write acia
	bra	output4
output2:
	ldx	#porta
	cmpb	#0x02
	beq	output3		; jump if duart a
	ldx	#portb
output3:
	jsr	outuart		; write uart
output4:
	pulx
	pulb
	pula
	rts

;**********
;*	onuart(port) - initialize a duart port.
;* sets duart to internal clock, divide by 16,
;* 8 data + 1 stop bits.
;**********

onuart:	ldaa	#0x22
	staa	2,x		; reset receiver
	ldaa	#0x38
	staa	2,x		; reset transmitter
	ldaa	#0x40
	staa	2,x		; reset error status
	ldaa	#0x10
	staa	2,x		; reset pointer
	ldaa	#0x00
	staa	duart+4		; clock source
	ldaa	#0x00
	staa	duart+5		; interrupt mask
	ldaa	#0x13
	staa	0,x		; 8 data, no parity
	ldaa	#0x07
	staa	0,x		; 1 stop bits
	ldaa	#0xbb		; baud rate (9600)
	staa	1,x		; tx and rcv baud rate
	ldaa	#0x05
	staa	2,x		; enable tx and rcv
	rts

;**********
;*	inuart(port) - check duart for any input.
;**********

inuart:	ldaa	1,x		; read status
	anda	#0x01		; check rdrf
	beq	inuart1		; jump if no data
	ldaa	3,x		; read data
	anda	#0x7f		; to mask parity
inuart1:
	rts

;**********
;*	outuart(port) - output the character in a.
;*	if autolf=1, transmits cr or lf as crlf.
;**********
outuart:
	tst	*autolf
	beq	outuart2	; jump if no autolf
	bsr	outuart2
	cmpa	#0x0d
	bne	outuart1
	ldaa	#0x0a		; if cr, output lf
	bra	outuart2
outuart1:
	cmpa	#0x0a
	bne	outuart3
	ldaa	#0x0d		; if lf, output cr
outuart2:
	 ldab	1,x		; check status
	andb	#0x4
	beq	outuart2	; loop until tdre=1
	anda	#0x7f		; mask parity
	staa	3,x		; send character
outuart3:
	rts

;**********
;*	onsci() - initialize the sci for 9600
;*			baud at 8 mhz extal.
;**********
onsci:	ldaa	#0x30
	staa	baud		; baud register
	ldaa	#0x00
	staa	sccr1
	ldaa	#0x0c
	staa	sccr2		; enable
	rts

;**********
;*	insci() - read from sci.	return a=char or 0.
;**********
insci:	ldaa	scsr		; read status reg
	anda	#0x20
	beq	insci1		; jump if rdrf=0
	ldaa	scdat		; read data register
	anda	#0x7f		; mask parity
insci1:	rts

;**********
;*	outsci() - output a to sci. if autolf = 1,
;*		cr and lf sent as crlf.
;**********
outsci:	tst	*autolf
	beq	outsci2		; jump if autolf=0
	bsr	outsci2
	cmpa	#0x0d
	bne	outsci1
	ldaa	#0x0a		; if cr, send lf
	bra	outsci2
outsci1:
	cmpa	#0x0a
	bne	outsci3
	ldaa	#0x0d		; if lf, send cr
outsci2:
	ldab	scsr		; read status
	bitb	#0x80
	beq	outsci2		; loop until tdre=1
	anda	#0x7f		; mask parity
	staa	scdat		; send character
outsci3:
	rts

;**********
;*	onacia - initialize the acia for
;* 8 data bits, 1 stop bit, divide by 64 clock.
;**********
onacia:	ldx	#acia
	ldaa	#0x03
	staa	0,x		; master reset
	ldaa	#0x16
	staa	0,x		; setup
	rts

;**********
;*	inacia - read from the acia, return a=char or 0.
;**********
inacia:	ldx	#acia
	ldaa	0,x		; status
	psha
	anda	#0x70		; check pe, ov, fe
	pula
	beq	inacia1		; jump - no error
	bsr	onacia		; reinitialize and try again
	bra	inacia
inacia1:
	lsra			; check rdrf
	bcs	inacia2		; jump if data
	clra			; return(no data)
	rts
inacia2:
	ldaa	1,x		; read data
	anda	#0x7f		; mask parity
	rts

;**********
;*	outacia - output a to acia. if autolf = 1,
;*		cr or lf sent as crlf.
;**********
outacia:
	bsr	outacia3	; output char
	tst	*autolf
	beq	outacia2	; jump no autolf
	cmpa	#0x0d
	bne	outacia1
	ldaa	#0x0a
	bsr	outacia3	; if cr, output lf
	bra	outacia2
outacia1:
	cmpa	#0x0a
	bne	outacia2
	ldaa	#0x0d
	bsr	outacia3	; if lf, output cr
outacia2:
	rts

outacia3:
	ldx	#acia
	ldab	0,x
	bitb	#0x2
	beq	outacia3	; loop until tdre
	anda	#0x7f		; mask parity
	staa	1,x		; output
	rts
;*
;*	space for modifying outacia routine
;*
	.word	0xffff,0xffff,0xffff,0xffff
;*******************************
;*** i/o utility subroutines ***
;***these subroutines perform the neccesary
;* data i/o operations.
;* outlhlf-convert left 4 bits of a from binary
;*		to ascii and output.
;* outrhlf-convert right 4 bits of a from binary
;*		to ascii and output.
;* out1byt-convert byte addresed by x from binary
;*		to ascii and output.
;* out1bsp-convert byte addressed by x from binary
;*		to ascii and output followed by a space.
;* out2bsp-convert 2 bytes addressed by x from binary
;*		to ascii and  output followed by a space.
;* outspac-output a space.
;*
;* outcrlf-output a line feed and carriage return.
;*
;* outstrg-output the string of ascii bytes addressed
;*		by x until 0x04.
;* outa-output the ascii character in a.
;*
;* inchar-input to a and echo one character.  loops
;*		until character read.
;********************

;**********
;*	outrhlf(), outlhlf(), outa()
;*convert a from binary to ascii and output.
;*contents of a are destroyed..
;**********
outlhlf:
	lsra			; shift data to right
	lsra
	lsra
	lsra
outrhlf:
	anda	#0x0f		; mask top half
	adda	#0x30		; convert to ascii
	cmpa	#0x39
	ble	outa		; jump if 0-9
	adda	#0x07		; convert to hex a-f
outa:	jsr	output		; output character
	rts

;**********
;*	out1byt(x) - convert the byte at x to two
;* ascii characters and output. return x pointing
;* to next byte.
;**********
out1byt:
	psha
	ldaa	0,x		; get data in a
	psha			; save copy
	bsr	outlhlf		; output left half
	pula			; retrieve copy
	bsr	outrhlf		; output right half
	pula
	inx
	rts

;**********
;*	out1bsp(x), out2bsp(x) - output 1 or 2 bytes
;* at x followed by a space.  returns x pointing to
;* next byte.
;**********
out2bsp:
	jsr	out1byt		; do first byte
out1bsp:
	jsr	out1byt		; do next byte
outspac:
	ldaa	#0x20		; output a space
	jsr	output
	rts

;**********
;*	outcrlf() - output a carriage return and
;* a line feed.	returns a = cr.
;**********
outcrlf:
	ldaa	#0x0d		; cr
	jsr	output		; output a
	ldaa	#0x00
	jsr	output		; output padding
	ldaa	#0x0d
	rts

;**********
;*	outstrg(x) - output string of ascii bytes
;* starting at x until end of text (0x04).	can
;* be paused by control w (any char restarts).
;**********
outstrg:
	jsr	outcrlf
outstrg0:
	psha
outstrg1:
	ldaa	0,x		; read char into a
	cmpa	#eot
	beq	outstrg3	; jump if eot
	jsr	output		; output character
	inx
	jsr	input
	beq	outstrg1	; jump if no input
	cmpa	#ctlw
	bne	outstrg1	; jump if not cntlw
outstrg2:
	jsr	input
	beq	outstrg2	; jump if any input
	bra	outstrg1
outstrg3:
	pula
	rts

;**********
;*	inchar() - reads input until character sent.
;*	echoes char and returns with a = char.
inchar:	jsr	input
	tsta
	beq	inchar		; jump if no input
	jsr	output		; echo
	rts

;*********************
;*** command table ***
comtabl	= .
	.byte	5
	.ascii	'ASSEM'
	.word	#assem
	.byte	5
	.ascii	'BREAK'
	.word	#break
	.byte	4
	.ascii	'BULK'
	.word	#bulk
	.byte	7
	.ascii	'BULKALL'
	.word	#bulkall
	.byte	4
	.ascii	'CALL'
	.word	#call
	.byte	4
	.ascii	'DUMP'
	.word	#dump
	.byte	4
	.ascii	'FILL'
	.word	#fill
	.byte	2
	.ascii	'GO'
	.word	#go
	.byte	4
	.ascii	'HELP'
	.word	#help
	.byte	4
	.ascii	'HOST'
	.word	#host
	.byte	4
	.ascii	'LOAD'
	.word	#load
	.byte	6 		; length of command
	.ascii	'MEMORY'	; ascii command
	.word	#memory		; command address
	.byte	4
	.ascii	'MOVE'
	.word	#move
	.byte	7
	.ascii	'PROCEED'
	.word	#proceed
	.byte	8
	.ascii	'REGISTER'
	.word	#register
	.byte	5
	.ascii	'TRACE'
	.word	#trace
	.byte	6
	.ascii	'VERIFY'
	.word	#verify
	.byte	1
	.ascii	'?'		; initial command
	.word	#help
	.byte	5
	.ascii	'XBOOT'
	.word	#boot
;*
;*** command names for evm compatability ***
;*
	.byte	3
	.ascii	'ASM'
	.word	#assem
	.byte	2
	.ascii	'BF'
	.word	#fill
	.byte	4
	.ascii	'COPY'
	.word	#move
	.byte	5
	.ascii	'ERASE'
	.word	#bulk
	.byte	2
	.ascii	'MD'
	.word	#dump
	.byte	2
	.ascii	'MM'
	.word	#memory
	.byte	2
	.ascii	'RD'
	.word	#register
	.byte	2
	.ascii	'RM'
	.word	#register
	.byte	4
	.ascii	'READ'
	.word	#move
	.byte	2
	.ascii	'TM'
	.word	#host
	.byte	4
	.ascii	'TEST'
	.word	#evbtest
	.byte	-1

;*******************
;*** text tables ***

msg1:	.ascii	'BUFFALO 2.5 (ext) - '
	.ascii	'Bit User Fast Friendly Aid to Logical Operation'
	.byte	eot
msg2:	.ascii	'What?'
	.byte	eot
msg3:	.ascii	'Too Long'
	.byte	eot
msg4:	.ascii	'Full'
	.byte	eot
msg5:	.ascii	'Op- '
	.byte	eot
msg6:	.ascii	'rom-'
	.byte	eot
msg8:	.ascii	'Command?'
	.byte	eot
msg9:	.ascii	'Bad argument'
	.byte	eot
msg10:	.ascii	'No host port available'
	.byte	eot
msg11:	.ascii	'done'
	.byte	eot
msg12:	.ascii	'checksum error'
	.byte	eot
msg13:	.ascii	'error addr '
	.byte	eot

;**********
;*	break [-][<addr>] . . .
;* modifies the breakpoint table.  more than
;* one argument can be entered on the command
;* line but the table will hold only 4 entries.
;* 4 types of arguments are implied above:
;* break 		prints table contents.
;* break <addr>		inserts <addr>.
;* break -<addr>	deletes <addr>.
;* break -		clears all entries.
;**********
;* while 1
;*	a = wskip();
;*	switch(a)
;*		case(cr):
;*		bprint(); return;

break:	jsr	wskip
	cmpa	#0x0d
	bne	brkdel		; jump if not cr
	jsr	bprint		; print table
	rts

;*		case("-"):
;*		incbuff(); readbuff();
;*		if(dchek(a))		/* look for wspac or cr */
;*			bpclr();
;*			breaksw;
;*		a = buffarg();
;*		if( !dchek(a) ) return(bad argument);
;*		b = bpsrch();
;*		if(b >= 0)
;*			brktabl[b] = 0;
;*		breaksw;

brkdel:	cmpa	#'-
	bne	brkdef		; jump if not -
	jsr	incbuff
	jsr	readbuff
	jsr	dchek
	bne	brkdel1		; jump if not delimeter
	jsr	bpclr		; clear table
	jmp	break		; do next argument
brkdel1:
	jsr	buffarg		; get address to delete
	jsr	dchek
	beq	brkdel2		; jump if delimeter
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
brkdel2:
	jsr	bpsrch		; look for addr in table
	tstb
	bmi	brkdel3		; jump if not found
	ldx	#brktabl
	abx
	clr	0,x		; clear entry
	clr	1,x
brkdel3:
	jmp	break		; do next argument

;*		default:
;*		a = buffarg();
;*		if( !dchek(a) ) return(bad argument);
;*		b = bpsrch();
;*		if(b < 0)		/* not already in table */
;*			x = shftreg;
;*			shftreg = 0;
;*			a = x[0]; x[0] = 0x3f
;*			b = x[0]; x[0] = a;
;*			if(b != 0x3f) return(rom);
;*			b = bpsrch();	/* look for hole */
;*			if(b >= 0) return(table full);
;*			brktabl[b] = x;
;*		breaksw;

brkdef:	jsr	buffarg		; get argument
	jsr	dchek
	beq	brkdef1		; jump if delimiter
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
brkdef1:
	jsr	bpsrch		; look for entry in table
	tstb
	bge	break		; jump if already in table
	ldx	*shftreg	; x = new entry
	ldaa	0,x
	ldab	#swi
	stab	0,x
	ldab	0,x
	staa	0,x
	cmpb	#swi
	beq	brkdef2		; jump if writes ok
	stx	*ptr1		; save address
	ldx	#msg6		; "rom-"
	jsr	outstrg
	ldx	#ptr1
	jsr	out2bsp		; print address
	jsr	bprint
	rts
brkdef2:
	clr	*shftreg
	clr	*shftreg+1
	pshx
	jsr	bpsrch		; look for 0 entry
	pulx
	tstb
	bpl	brkdef3		; jump if table not full
	ldx	#msg4		; "full"
	jsr	outstrg
	jsr	bprint
	rts
brkdef3:

	ldy	#brktabl
	aby
	stx	0,y		; put new entry in
	jmp	break		; do next argument

;**********
;*	bprint() - print the contents of the table.
;**********
bprint:	jsr	outcrlf
	ldx	#brktabl
	ldab	#4
bprint1:
	jsr	out2bsp
	decb
	bgt	bprint1		; loop 4 times
	rts

;**********
;*	bpsrch() - search table for address in
;* shftreg. returns b = index to entry or
;* b = -1 if not found.
;**********
;*for(b=0; b=6; b=+2)
;*	x[] = brktabl + b;
;*	if(x[0] = shftreg)
;*		return(b);
;*return(-1);

bpsrch:	clrb
bpsrch1:
	ldx	#brktabl
	abx
	ldx	0,x		; get table entry
	cpx	*shftreg
	bne	bpsrch2		; jump if no match
	rts
bpsrch2:
	incb
	incb
	cmpb	#0x6
	ble	bpsrch1		; loop 4 times
	ldab	#0xff
	rts


;**********
;*	bulk - bulk erase the eeprom except the
;* config register.
;**********
bulk:
	clr	*tmp2
	bra	bulk1

;**********
;*	bulkall - bulk erase the eeprom and the
;* config register.
;**********
bulkall:
	clr	*tmp2
	inc	*tmp2

;*set up pprog register for erase
bulk1:	psha
	ldaa	#0x06
	staa	pprog		; set eelat, erase bits

;*if (ee only) write to 0xb600
;*else write to config register
	ldaa	#0xff
	tst	*tmp2
	bne	bulk2		; jump if config
	staa	0xb600		; write to 0xb600
	bra	bulk3
bulk2:	staa	config
bulk3	= .

;*start erasing
	ldaa	#0x07
	bne	acl3
	clra			; fail safe
acl3:	staa	pprog

;*delay for 10 ms at E = 2 mhz
	pshx
	ldx	#0x0d06		; 6~ * 3334 = 20,004 * 0.5 mhz
bulkdly:
	dex			; 2~
	bne	bulkdly		; 3~
	pulx

;*stop programming
	clr	pprog
	pula
	rts

;**********
;*	dump [<addr1> [<addr2>]]  - dump memory
;* in 16 byte lines from <addr1> to <addr2>.
;*	default starting address is "current
;* location" and default number of lines is 8.
;**********
;*ptr1 = ptrmem;	/* default start address */
;*ptr2 = ptr1 + 0x80;	/* default end address */
;*a = wskip();
;*if(a != cr)
;*	a = buffarg();
;*	if(countu1 = 0) return(bad argument);
;*	if( !dchek(a) ) return(bad argument);
;*	ptr1 = shftreg;
;*	ptr2 = ptr1 + 0x80;	/* default end address */
;*	a = wskip();
;*	if(a != cr)
;*		a = buffarg();
;*		if(countu1 = 0) return(bad argument);
;*		a = wskip();
;*		if(a != cr) return(bad argument);
;*		ptr2 = shftreg;

dump:	ldx	*ptrmem		; current location
	stx	*ptr1		; default start
	ldab	#0x80
	abx
	stx	*ptr2		; default end
	jsr	wskip
	cmpa	#0xd
	beq	dump1		; jump - no arguments
	jsr	buffarg		; read argument
	tst	*count
	beq	dumperr		; jump if no argument
	jsr	dchek
	bne	dumperr		; jump if delimiter
	ldx	*shftreg
	stx	*ptr1
	ldab	#0x80
	abx
	stx	*ptr2		; default end address
	jsr	wskip
	cmpa	#0xd
	beq	dump1		; jump - 1 argument
	jsr	buffarg		; read argument
	tst	*count
	beq	dumperr		; jump if no argument
	jsr	wskip
	cmpa	#0x0d
	bne	dumperr		; jump if not cr
	ldx	*shftreg
	stx	*ptr2
	bra	dump1		; jump - 2 arguments
dumperr:
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts

;*ptrmem = ptr1;
;*ptr1 = ptr1 & 0xfff0;

dump1:	ldd	*ptr1
	std	*ptrmem		; new current location
	andb	#0xf0
	std	*ptr1		; start dump at 16 byte boundary

;*** dump loop starts here ***
;*do:
;*	output address of first byte;

dumplp:	jsr	outcrlf
	ldx	#ptr1
	jsr	out2bsp		; first address

;*	x = ptr1;
;*	for(b=0; b=16; b++)
;*		output contents;

	ldx	*ptr1		; base address
	clrb			; loop counter
dumpdat:
	jsr	out1bsp		; hex value loop
	incb
	cmpb	#0x10
	blt	dumpdat		; loop 16 times

;*	x = ptr1;
;*	for(b=0; b=16; b++)
;*		a = x[b];
;*		if(0x7a < a < 0x20)  a = 0x20;
;*		output ascii contents;

	clrb			; loop counter
dumpasc:
	ldx	*ptr1		; base address
	abx
	ldaa	,x		; ascii value loop
	cmpa	#0x20
	blo	dump3		; jump if non printable
	cmpa	#0x7a
	bls	dump4		; jump if printable
dump3:	ldaa	#0x20		; space for non printables
dump4:	jsr	output		; output ascii value
	incb
	cmpb	#0x10
	blt	dumpasc		; loop 16 times

;*	chkabrt();
;*	ptr1 = ptr1 + 0x10;
;*while(ptr1 <= ptr2);
;*return;

	jsr	chkabrt		; check abort or wait
	ldd	*ptr1
	addd	#0x10		; point to next 16 byte bound
	std	*ptr1		; update ptr1
	cpd	*ptr2
	bhi	dump5		; quit if ptr1 > ptr2
	cpd	#0x00		; check wraparound at 0xffff
	bne	dumplp		; jump - no wraparound
	ldd	*ptr2
	cpd	#0xfff0
	blo	dumplp		; upper bound not at top
dump5:	rts			; quit

;**********
;*	fill <addr1> <addr2> [<data>]  - block fill
;*memory from addr1 to addr2 with data.	data
;*defaults to 0xff.
;**********
;*get addr1 and addr2

fill	= .
	jsr	wskip
	jsr	buffarg
	tst	*count
	beq	fillerr		; jump if no argument
	jsr	wchek
	bne	fillerr		; jump if bad argument
	ldx	*shftreg
	stx	*ptr1		; address1
	jsr	wskip
	jsr	buffarg
	tst	*count
	beq	fillerr		; jump if no argument
	jsr	dchek
	bne	fillerr		; jump if bad argument
	ldx	*shftreg
	stx	*ptr2		; address2

;*get data if it exists
	ldaa	#0xff
	staa	*tmp2		; default data
	jsr	wskip
	cmpa	#0x0d
	beq	fill1		; jump if default data
	jsr	buffarg
	tst	*count
	beq	fillerr		; jump if no argument
	jsr	wskip
	cmpa	#0x0d
	bne	fillerr		; jump if bad argument
	ldaa	*shftreg+1
	staa	*tmp2

;*while(ptr1 <= ptr2)
;*	*ptr1 = data
;*	if(*ptr1 != data) abort

fill1	= .
	jsr	chkabrt		; check for abort
	ldx	*ptr1		; starting address
	ldaa	*tmp2		; data
	staa	0,x
	cmpa	0,x
	bne	fillbad		; jump if no write
	cpx	*ptr2
	beq	fill2		; quit yet?
	inx
	stx	*ptr1
	bra	fill1		; loop
fill2:	rts

fillerr:
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts

fillbad:
	ldx	#msg6		; "rom -"
	jsr	outstrg
	ldx	#ptr1
	jsr	out2bsp
	rts

;**********
;*	call [<addr>] - execute a jsr to addr or
;*user's pc value.  return to monitor by rts
;*or breakpoint.
;**********
;*a = wskip();
;*if(a != cr)
;*	a = buffarg();
;*	a = wskip();
;*	if(a != cr) return(bad argument)
;*	pc = shftreg;

call:	jsr	wskip
	cmpa	#0xd
	beq	call3		; jump if no arg
	jsr	buffarg
	jsr	wskip
	cmpa	#0xd
	beq	call2		; jump if cr
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
call2:	ldx	*shftreg
	stx	*regs		; pc = <addr>

;*user_stack[0] = return_to_monitor;
;*setbps();
;*restack();	/* restack and go*/

call3:	ldx	*sp
	dex			; user stack pointer
	ldd	#return		; return address
	std	0,x
	dex
	stx	*sp		; new user stack pointer
	jsr	setbps
	clr	*tmp2		; flag for breakpoints
	jmp	restack		; executes an rti

;**********
;*	return() - return here from rts after
;*call command.
;**********
return:	psha			; save a register
	tpa
	staa	*regs+8		; cc register
	pula
	std	*regs+6		; a and b registers
	stx	*regs+4		; x register
	sty	*regs+2		; y register
	sts	*sp		; user stack pointer
	lds	#stack		; monitor stack pointer
	jsr	rembps		; remove breakpoints
	jsr	outcrlf
	jsr	rprint		; print user registers
	jmp	main

;**********
;*	go [<addr>] - execute starting at <addr> or
;*user's pc value.  executes an rti to user code.
;*returns to monitor via an swi through swiin.
;**********
;*a = wskip();
;*if(a != cr)
;*	a = buffarg();
;*	a = wskip();
;*	if(a != cr) return(bad argument)
;*	pc = shftreg;
;*setbps();
;*restack();	/* restack and go*/

go:	jsr	wskip
	cmpa	#0x0d
	beq	go2		; jump if no arg
	jsr	buffarg
	jsr	wskip
	cmpa	#0x0d
	beq	go1		; jump if cr
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
go1:	ldx	*shftreg
	stx	*regs		; pc = <addr>
go2:	clr	*tmp2		; flag for breakpoints
	inc	*tmp2		; (1=go, 0=call)
	jsr	setbps
	jmp	restack		; execute an rti

;**********
;*	swiin() - return from swi.	set up
;*stack pointers, save user registers, and
;*return to main.
;**********
swiin:	tsx			; swi entry point
	lds	#stack
	jsr	savstack	; save user regs
	ldx	*regs
	dex
	stx	*regs		; save user pc
	ldx	*ptr4		; restore user swi vector
	stx	*jswi+1

;*if(flagt1 = 0) remove return addr from stack;

	tst	*tmp2		; 0=call, 1=go
	bne	go3		; jump if go command
	ldx	*sp		; remove return address
	inx
	inx
	stx	*sp
go3:	jsr	outcrlf		; print register values
	jsr	rprint
	jsr	rembps
	jmp	main		; return to monitor
;*				; (sp destroyed above)

;**********
;*	proceed - same as go except it ignores
;*a breakpoint at the first opcode.  calls
;*trace once and the go.
;**********
proceed:
	clr	*tmp2		; flag for breakpoints
	inc	*tmp2		; 0=trace, 1=proceed
	jmp	trace3

;**********
;*	trace <n> - trace n instructions starting
;*at user's pc value. n is a hex number less than
;*0xff (defaults to 1).
;**********
;*countt1 = 1
;*a = wskip();
;*if(a != cr)
;*	a = buffarg(); a = wskip();
;*	if(a != cr) return(bad argument);
;*	countt1 = n

trace:	clr	*tmp4
	inc	*tmp4		; default countt1 = 1
	clr	*tmp2		; 0 = trace
	jsr	wskip
	cmpa	#0x0d
	beq	trace2		; jump if cr
	jsr	buffarg
	jsr	wskip
	cmpa	#0x0d
	beq	trace1		; jump if cr
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
trace1:	ldaa	*shftreg+1	; n
	staa	*tmp4

;*print opcode
trace2:	jsr	outcrlf
	ldx	#msg5		; "op-"
	jsr	outstrg
	ldx	*regs
	jsr	out1bsp		; opcode

;*save user oc5 regs, setup monitor oc5 regs
trace3:	ldaa	tctl1
	staa	*ptr2		; save user mode/level
	anda	#0xfc
	staa	tctl1		; disable oc5 output
	ldaa	tmsk1
	staa	*ptr2+1		; save user int masks
	clr	tmsk2		; disable tof and pac ints

;*put monitor toc5 vector into jump table
	ldx	*jtoc5+1
	stx	*ptr4		; save user's vector
	ldaa	#0x7e		; jmp opcode
	staa	*jtoc5
	ldx	#tracein
	stx	*jtoc5+1	; monitor toc5 vector

;*unmask i bit in user ccr
	ldaa	*regs+8		; user ccr
	anda	#0xef		; clear i bit
	staa	*regs+8

;*arm oc5 interrupt
	ldab	#87		; cycles to end of rti
	ldx	tcnt		; timer count value
	abx			; 			3~ )
	stx	toc5		; oc5 match register	5~  )
	ldaa	#0x08		; 			2~	)
	staa	tflg1		; clear oc5 int flag	4~	) 86~
	staa	tmsk1		; enable oc5 interrupt	4~	)
	cli			; 			2~  )
	jmp	restack		; execute an rti 	66~ )

;**********
;*	tracein - return from toc5 interrupt.
;**********
;*disable toc5 interrupt
;*replace user's toc5 vector
tracein:
	sei
	clr	tmsk1		; disable timer ints
	tsx
	lds	#stack
	jsr	savstack	; save user regs
	ldx	*ptr4
	stx	*jtoc5+1
	jsr	chkabrt		; check for abort

;*if(flagt1 = 1) jump to go command ( proceed )
	tst	*tmp2
	beq	trace9		; jump if trace command
	jmp	go2

;*rprint();
;*while(countt1 >= 0) continue trace;

trace9:	jsr	outcrlf		; print registers for
	jsr	rprint		; trace only.
	dec	*tmp4
	bhi	trace2		; jump if countt1 >= 0
	jmp	main		; return to monitor
;*				; (sp destroyed above)

;**********
;*	setbps - replace user code with swi's at
;*breakpoint addresses.
;**********
;*for(b=0; b=6; b =+ 2)
;*	x = brktabl[b];
;*	if(x != 0)
;*		optabl[b] = x[0];
;*		x[0] = 0x3f;

setbps:	clrb
setbps1:
	ldx	#brktabl
	ldy	#ptr6
	abx
	aby
	ldx	0,x		; breakpoint table entry
	beq	setbps2		; jump if 0
	ldaa	0,x		; save user opcode
	staa	0,y
	ldaa	#swi		; insert swi into code
	staa	0,x
setbps2:
	addb	#0x2
	cmpb	#0x6
	ble	setbps1		; loop 4 times

;*put monitor swi vector into jump table
	ldx	*jswi+1
	stx	*ptr4		; save user swi vector
	ldaa	#0x7e		; jmp opcode
	staa	*jswi
	ldx	#swiin
	stx	*jswi+1		; monitor swi vector
	rts

;**********
;*	rembps - remove breakpoints from user code.
;**********
;*for(b=0; b=6; b =+ 2)
;*	x = brktabl[b];
;*	if(x != 0)
;*		x[0] = optabl[b];

rembps:	clrb
rembps1:
	ldx	#brktabl
	ldy	#ptr6
	abx
	aby
	ldx	0,x		; breakpoint table entry
	beq	rembps2		; jump if 0
	ldaa	0,y		; restore user's opcode
	staa	0,x
rembps2:
	addb	#0x2
	cmpb	#0x6
	ble	rembps1		; loop 4 times

;*replace user's swi vector
	ldx	*ptr4
	stx	*jswi+1
	rts

;**********
;*	restack() - restore user stack and
;*execute an rti. extended addressing forced
;*to ensure count value for trace.
;**********
restack:
	lds	sp		; stack pointer
	ldx	regs
	pshx			; pc
	ldx	regs+2
	pshx			; y
	ldx	regs+4
	pshx			; x
	ldd	regs+6
	psha			; a
	pshb			; b
	ldaa	regs+8
	psha			; ccr
restack1:
	rti

;**********
;*	savstack() -	save user's registers.
;**********
savstack:
	ldaa	0,x
	staa	*regs+8		; ccr
	ldd	1,x
	staa	*regs+7		; b
	stab	*regs+6		; a
	ldd	3,x
	std	*regs+4		; x
	ldd	5,x
	std	*regs+2		; y
	ldd	7,x
	std	*regs		; pc
	ldab	#8
	abx
	stx	*sp		; stack pointer
	rts

;**********
;*	help  -  list buffalo commands to terminal.
;**********
help	= .
	ldx	#helpmsg1
	jsr	outstrg		; print help screen
	rts

helpmsg1	= .
	.ascii	'ASM [<addr>]  Line assembler/disassembler.'
	.byte	0x0d
	.ascii	'    /        Do same address.'
	.ascii	'           ^        Do previous address.'
	.byte	0x0d
	.ascii	'    CTRL-J   Do next address.'
	.ascii	'           RETURN   Do next opcode.'
	.byte	0x0d
	.ascii	'    CTRL-A   Quit.'
	.byte	0x0d
	.ascii	'BF <addr1> <addr2> [<data>]  Block fill.'
	.byte	0x0d
	.ascii	'BR [-][<addr>]  Set up breakpoint table.'
	.byte	0x0d
	.ascii	'BULK  Erase the EEPROM.'
	.ascii	'                   BULKALL  Erase EEPROM and CONFIG.'
	.byte	0x0d
	.ascii	'CALL [<addr>]  Call user subroutine.'
	.ascii	'      G [<addr>]  Execute user code.'
	.byte	0x0d
	.ascii	'LOAD, VERIFY [T] <host download command>'
	.ascii	'  Load or verify S-records.'
	.byte	0x0d
	.ascii	'MD [<addr1> [<addr2>]]  Memory dump.'
	.byte	0x0d
	.ascii	'MM [<addr>]  Memory modify.'
	.byte	0x0d
	.ascii	'    /        Open same address.         CTRL-H'
	.ascii	' or ^   Open previous address.'
	.byte	0x0d
	.ascii	'    CTRL-J   Open next address.         SPACE'
	.ascii	'         Open next address.'
	.byte	0x0d
	.ascii	'    RETURN   Quit.                      <addr>O'
	.ascii	'       Compute offset to <addr>.'
	.byte	0x0d
	.ascii	'MOVE <s1> <s2> [<d>]  Block move.'
	.byte	0x0d
	.ascii	'P  Proceed/continue execution.'
	.byte	0x0d
	.ascii	'RM [P, Y, X, A, B, C, or S]  Register modify.'
	.byte	0x0d
	.ascii	'T [<n>]  Trace n instructions.'
	.byte	0x0d
	.ascii	'TM  Transparent mode (CTRL-A = exit, CTRL-B = send break).'
	.byte	0x0d
	.ascii	'CTRL-H  Backspace.'
	.ascii	'                      CTRL-W  Wait for any key.'
	.byte	0x0d
	.ascii	'CTRL-X or DELETE  Abort/cancel command.'
	.byte	0x0d
	.ascii	'RETURN  Repeat last command.'
	.byte	4

;**********
;*	host() - establishes transparent link between
;*	terminal and host.  port used for host is
;*	determined in the reset initialization routine
;*	and stored in hostdev.
;*		to exit type control a.
;*		to send break to host type control b.
;*if(no external device) return;
;*initialize host port;
;*while( !(control a))
;*	input(terminal); output(host);
;*	input(host); output(terminal);

host:	ldaa	*extdev
	bne	host0		; jump if host port avail.
	ldx	#msg10		; "no host port avail"
	jsr	outstrg
	rts
host0:	clr	*autolf		; turn off autolf
	jsr	hostco		; connect sci (evb board)
	jsr	hostinit	; initialize host port
host1:	jsr	input		; read terminal
	tsta
	beq	host3		; jump if no char
	cmpa	#ctla
	beq	hostend		; jump if control a
	cmpa	#ctlb
	bne	host2		; jump if not control b
	jsr	txbreak		; send break to host
	bra	host3
host2:	jsr	hostout		; echo to host
host3:	jsr	hostin		; read host
	tsta
	beq	host1		; jump if no char
	jsr	output		; echo to terminal
	bra	host1
hostend:
	inc	*autolf		; turn on autolf
	jsr	targco		; disconnect sci (evb board)
	rts			; return

;**********
;* txbreak() - transmit break to host port.
;* the duration of the transmitted break is
;* approximately 200,000 e-clock cycles, or
;* 100ms at 2.0 mhz.
;***********
txbreak	= .
	ldaa	*hostdev
	cmpa	#0x03
	beq	txbdu		; jump if duartb is host

txbsci:	ldx	#sccr2		; sci is host
	bset	0,x ,#0x01	; set send break bit
	bsr	txbwait
	bclr	0,x ,#0x01	; clear send break bit
	bra txb1

txbdu:	ldx	#portb		; duart host port
	ldaa	#0x60		; start break cmd
	staa	2,x		; port b command register
	bsr	txbwait
	ldaa	#0x70		; stop break cmd
	staa	2,x		; port b command register

txb1:	ldaa	#0x0d
	jsr	hostout		; send carriage return
	ldaa	#0x0a
	jsr	hostout		; send linefeed
	rts

txbwait:
	ldy	#0x6f9b		; loop count = 28571
txbwait1:
	dey			; 7 cycle loop
	bne	txbwait1
	rts


;**********
;*	hostinit(), hostin(), hostout() - host i/o
;*routines.  restores original terminal device.
;**********
hostinit:
	ldab	*iodev		; save terminal
	pshb
	ldab	*hostdev
	stab	*iodev		; point to host
	jsr	init		; initialize host
	bra	termres		; restore terminal
hostin:	ldab	*iodev		; save terminal
	pshb
	ldab	*hostdev
	stab	*iodev		; point to host
	jsr	input		; read host
	bra	termres		; restore terminal
hostout:
	ldab	*iodev		; save terminal
	pshb
	ldab	*hostdev
	stab	*iodev		; point to host
	jsr	output		; write to host
termres:
	pulb			; restore terminal device
	stab	*iodev
	rts


;**********
;*	load(ptrbuff[]) - load s1/s9 records from
;*host to memory.  ptrbuff[] points to string in
;*input buffer which is a command to output s1/s9
;*records from the host ("cat filename" for unix).
;*	returns error and address if it can't write
;*to a particular location.
;**********
;*	verify(ptrbuff[]) - verify memory from load
;*command.  ptrbuff[] is same as for load.
;**********
verify:	clr	*tmp2
	inc	*tmp2		; flagt1 = 1 = verify
	bra	load1
load:	clr	*tmp2		; flagt1 = 0 = load


;*a=wskip();
;*if(a = cr) goto transparent mode;
;*if(t option) hostdev = iodev;

load1:	jsr	wskip
	cmpa	#0x0d
	bne	load1a
	jmp	host		; go to host if no args
load1a:	jsr	upcase
	cmpa	#'T		; look for t option
	bne	load1b		; jump not t option
	jsr	incbuff
	jsr	readbuff	; get next character
	jsr	decbuff
	cmpa	#0x0d
	bne	load1b		; jump if not t option
	clr	*autolf
	ldaa	*iodev
	staa	*hostdev		; set host port = terminal
	bra	load6		; go wait for s1 records

;*else while(not cr)
;*	read character from input buffer;
;*	send character to host;

load1b:	clr	*autolf
	jsr	hostco		; connect sci (evb board)
	jsr	hostinit	; initialize host port
load2:	jsr	readbuff	; get next char
	jsr	incbuff
	psha			; save char
	jsr	hostout		; output to host
	jsr	output		; echo to terminal
	pula
	cmpa	#0x0d
	bne	load2		; jump if not cr

;*repeat:
;*	if(hostdev != iodev) check abort;
;*	a = hostin();
;*	if(a = 's')
;*		a = hostin;
;*		if(a = '9')
;*		read rest of record;
;*		return(done);
;*		if(a = '1')
;*		checksum = 0;
;*		byte(); b = shftreg+1;	/* byte count */
;*		byte(); byte(); x = shftreg; /* base addr*/
;*		do
;*			byte();
;*			if(flagt1 = 0)
;*			x[0] = shftreg+1
;*			if(x[0] != shftreg+1)
;*				return("rom-(x)");
;*			x++; b--;
;*		until(b = 0)

load6	= .
	ldaa	*hostdev
	cmpa	*iodev
	beq	load65		; jump if hostdev=iodev
	jsr	chkabrt		; check for abort
load65:	jsr	hostin		; read host
	tsta
	beq	load6		; jump if no input
	cmpa	#'S
	bne	load6		; jump if not s
load7:	jsr	hostin		; read host
	tsta
	beq	load7		; jump if no input
	cmpa	#'9
	bne	load8		; jump if not s9
	jsr	byte
	ldab	*shftreg+1	; b = byte count
load75:	jsr	byte
	decb
	bne	load75		; loop until end of record
	inc	*autolf		; turn on autolf
	jsr	targco		; disconnect sci (evb)
	ldx	#msg11		; "done"
	jsr	outstrg
	rts
load8:	cmpa	#'1
	bne	load6		; jump if not s1
	clr	*tmp4		; clear checksum
	jsr	byte
	ldab	*shftreg+1
	subb	#0x2		; b = byte count
	jsr	byte
	jsr	byte
	ldx	*shftreg	; x = base address
	dex
load10:	jsr	byte		; get next byte
	inx
	decb			; check byte count
	beq	load12		; if 0, go do checksum
	ldaa	*shftreg+1
	tst	*tmp2
	bne	load11		; jump if verify
	staa	0,x		; load only
load11:	cmpa	0,x		; verify ram location
	beq	load10		; jump if ram ok
	stx	*ptr3		; save error address
	inc	*autolf		; turn on autolf
	jsr	targco		; disconnect sci(evb)
	jsr	outcrlf
	ldx	#msg13		; "error addr"
	jsr	outstrg
	ldx	#ptr3
	jsr	out2bsp		; address
	rts
load12:	ldaa	*tmp4
	inca			; do checksum
	bne	load13		; jump if s1 record okay
	jmp	load6
load13:	inc	*autolf
	jsr	targco		; disconnect sci(evb)
	jsr	outcrlf
	ldx	#msg12		; "checksum error"
	jsr	outstrg
	rts

;**********
;*	byte() -  read 2 ascii bytes from host and
;*convert to one hex byte.  returns byte
;*shifted into shftreg and added to tmp4.
;**********
byte:	pshb
	pshx
byte0:	jsr	hostin		; read host (1st byte)
	tsta
	beq	byte0		; loop until input
	jsr	hexbin
byte1:	jsr	hostin		; read host (2nd byte)
	tsta
	beq	byte1		; loop until input
	jsr	hexbin
	ldaa	*shftreg+1
	adda	*tmp4
	staa	*tmp4		; add to checksum
	pulx
	pulb
	rts


;*******************************************
;*	memory [<addr>]
;*	[<addr>]/
;* opens memory and allows user to modify the
;*contents at <addr> or the last opened location.
;*	subcommands:
;* [<data>]<cr> - close current location and exit.
;* [<data>]<lf> - close current and open next.
;* [<data>]<^> - close current and open previous.
;* [<data>]<sp> - close current and open next.
;* [<data>]/ - reopen current location.
;*	the contents of the current location is only
;*	changed if valid data is entered before each
;*  subcommand.
;* [<addr>]o - compute relative offset from current
;*	location to <addr>.  the current location must
;*	be the address of the offset byte.
;**********
;*a = wskip();
;*if(a != cr)
;*	a = buffarg();
;*	if(a != cr) return(bad argument);
;*	if(countu1 != 0) ptrmem[] = shftreg;

memory:	jsr	wskip
	cmpa	#0xd
	beq	mem1		; jump if cr
	jsr	buffarg
	jsr	wskip
	cmpa	#0xd
	beq	mslash		; jump if cr
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
mslash:	tst	*count
	beq	mem1		; jump if no argument
	ldx	*shftreg
	stx	*ptrmem		; update "current location"

;**********
;* subcommands
;**********
;*outcrlf();
;*out2bsp(ptrmem[]);
;*out1bsp(ptrmem[0]);

mem1:	jsr	outcrlf
mem2:	ldx	#ptrmem
	jsr	out2bsp		; output address
mem3:	ldx	*ptrmem
	jsr	out1bsp		; output contents
	clr	*shftreg
	clr	*shftreg+1
;*while 1
;*a = termarg();
;*	switch(a)
;*		case(space):
;*		chgbyt();
;*		ptrmem[]++;
;*		case(linefeed):
;*		chgbyt();
;*		ptrmem[]++;
;*		case(up arrow):
;*		case(backspace):
;*		chgbyt();
;*		ptrmem[]--;
;*		case("/"):
;*		chgbyt();
;*		outcrlf();
;*		case(o):
;*		d = ptrmem[0] - (shftreg);
;*		if(0x80 < d < 0xff81)
;*			print(out of range);
;*		countt1 = d-1;
;*		out1bsp(countt1);
;*		case(carriage return):
;*		chgbyt();
;*		return;
;*		default: return(command?)

mem4:	jsr	termarg
	jsr	upcase
	ldx	*ptrmem
	cmpa	#0x20
	beq	memsp		; jump if space
	cmpa	#0x0a
	beq	memlf		; jump if linefeed
	cmpa	#0x5e
	beq	memua		; jump if up arrow
	cmpa	#0x08
	beq	membs		; jump if backspace
	cmpa	#'/
	beq	memsl		; jump if /
	cmpa	#'O
	beq	memoff		; jump if o
	cmpa	#0x0d
	beq	memcr		; jump if carriage ret
	ldx	#msg8		; "command?"
	jsr	outstrg
	jmp	mem1
memsp:	jsr	chgbyt
	inx
	stx	*ptrmem
	jmp	mem3		; output contents
memlf:	jsr	chgbyt
	inx
	stx	*ptrmem
	jmp	mem2		; output addr, contents
memua	= .
membs:	jsr	chgbyt
	dex
	stx	*ptrmem
	jmp	mem1		; output cr, addr, contents
memsl:	jsr	chgbyt
	jmp	mem1		; output cr, addr, contents
memoff:	ldd	*shftreg	; destination addr
	subd	*ptrmem
	cmpa	#0x0
	bne	memoff1		; jump if not 0
	cmpb	#0x80
	bls	memoff3		; jump if in range
	bra	memoff2		; out of range
memoff1:
	cmpa	#0xff
	bne	memoff2		; out of range
	cmpb	#0x81
	bhs	memoff3		; in range
memoff2:
	ldx	#msg3		; "too long"
	jsr	outstrg
	jmp	mem1		; output cr, addr, contents
memoff3:
	subd	#0x1		; b now has offset
	stab	*tmp4
	jsr	outspac
	ldx	#tmp4
	jsr	out1bsp		; output offset
	jmp	mem1		; output cr, addr, contents
memcr:	jsr	chgbyt
	rts			; exit task


;**********
;*	move <src1> <src2> [<dest>]	- move
;*block at <src1> to <src2> to <dest>.
;*	moves block 1 byte up if no <dest>.
;**********
;*a = buffarg();
;*if(countu1 = 0) return(bad argument);
;*if( !wchek(a) ) return(bad argument);
;*ptr1 = shftreg;	/* src1 */

move	= .
	jsr	buffarg
	tst	*count
	beq	moverr		; jump if no arg
	jsr	wchek
	bne	moverr		; jump if no delim
	ldx	*shftreg	; src1
	stx	*ptr1

;*a = buffarg();
;*if(countu1 = 0) return(bad argument);
;*if( !dchek(a) ) return(bad argument);
;*ptr2 = shftreg;	/* src2 */

	jsr	buffarg
	tst	*count
	beq	moverr		; jump if no arg
	jsr	dchek
	bne	moverr		; jump if no delim
	ldx	*shftreg	; src2
	stx	*ptr2

;*a = buffarg();
;*a = wskip();
;*if(a != cr) return(bad argument);
;*if(countu1 != 0) tmp2 = shftreg;  /* dest */
;*else tmp2 = ptr1 + 1;

	jsr	buffarg
	jsr	wskip
	cmpa	#0x0d
	bne	moverr		; jump if not cr
	tst	*count
	beq	move1		; jump if no arg
	ldx	*shftreg	; dest
	bra	move2
moverr:	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
move1:	ldx	*ptr1
	inx			; default dest
move2:	stx	*ptr3

;*if(src1 < dest <= src2)
;*	dest = dest+(src2-src1);
;*	for(x = src2; x = src1; x--)
;*		dest[0]-- = x[0]--;

	ldx	*ptr3		; dest
	cpx	*ptr1		; src1
	bls	move3		; jump if dest =< src1
	cpx	*ptr2		; src2
	bhi	move3		; jump if dest > src2
	ldd	*ptr2
	subd	*ptr1
	addd	*ptr3
	std	*ptr3		; dest = dest+(src2-src1)
	ldx	*ptr2
movelp1:
	jsr	chkabrt		; check for abort
	ldaa	,x		; char at src2
	pshx
	ldx	*ptr3
	cpx	#0xb600		; jump if not eeprom
	blo	movea
	cpx	#0xb7ff		; jump if not eeprom
	bhi	movea
	jsr	movprog		; program eeprom
movea:	staa	,x		; dest
	dex
	stx	*ptr3
	pulx
	cpx	*ptr1
	beq	movrts
	dex
	bra	movelp1		; loop src2 - src1 times
;*
;* else
;*	for(x=src1; x=src2; x++)
;*		dest[0]++ = x[0]++;


move3:	ldx	*ptr1		; srce1
movelp2:
	jsr	chkabrt		; check for abort
	ldaa	,x
	pshx
	ldx	*ptr3		; dest
	cpx	#0xb600		; jump if not eeprom
	blo	moveb
	cpx	#0xb7ff		; jump if not eeprom
	bhi	moveb
	jsr	movprog		; program eeprom
moveb:	staa	,x
	inx
	stx	*ptr3
	pulx
	cpx	*ptr2
	beq	movrts
	inx
	bra	movelp2		; loop src2-src1 times
movrts:	rts

;*************
;*	movprog - program eeprom location in x with
;*	data in a.
;*************
movprog:
	pshb
	pshx
	ldab	#0x02
	stab	pprog		; set eelat
	staa	,x
	ldab	#0x03
	bne	acl4
	clrb			; fail safe
acl4:	stab	pprog		; set pgm
	ldx	#0x0d06
movedly:
	dex
	bne	movedly		; delay 10 ms at E = 2 mhz
	ldab	#0x00
	stab	pprog
	pulx
	pulb
	rts


;**********
;*	register [<name>]	- prints the user regs
;*and opens them for modification.	<name> is
;*the first register opened (default = p).
;*	subcommands:
;* [<nn>]<space>	opens the next register.
;* [<nn>]<cr>	return.
;*	the register value is only changed if
;*	<nn> is entered before the subcommand.
;**********
;*x[] = reglist
;*a = wskip(); a = upcase(a);
;*if(a != cr)
;*	while( a != x[0] )
;*		if( x[0] = "s") return(bad argument);
;*		x[]++;
;*	incbuff(); a = wskip();
;*	if(a != cr) return(bad argument);

register:
	ldx	#reglist
	jsr	wskip		; a = first char of arg
	jsr	upcase		; convert to upper case
	cmpa	#0xd
	beq	reg4		; jump if no argument
reg1:	cmpa	0,x
	beq	reg3
	ldab	0,x
	inx
	cmpb	#'S
	bne	reg1		; jump if not "s"
reg2:	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
reg3:	pshx
	jsr	incbuff
	jsr	wskip		; next char after arg
	cmpa	#0xd
	pulx
	bne	reg2		; jump if not cr

;*rprint();
;*	while(x[0] != "s")
;*		rprnt1(x);
;*		a = termarg();	/* read from terminal */
;*		if( ! dchek(a) ) return(bad argument);
;*		if(countu1 != 0)
;*		if(x[14] = 1)
;*			regs[x[7]++ = shftreg;
;*		regs[x[7]] = shftreg+1;
;*		if(a = cr) break;
;*return;

reg4:	jsr	rprint		; print all registers
reg5:	jsr	outcrlf
	jsr	rprnt1		; print reg name
	clr	*shftreg
	clr	*shftreg+1
	jsr	termarg		; read subcommand
	jsr	dchek
	beq	reg6		; jump if delimeter
	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts
reg6:	psha
	pshx
	tst	*count
	beq	reg8		; jump if no input
	ldab	7,x		; get reg offset
	ldaa	14,x		; byte size
	ldx	#regs		; user registers
	abx
	tsta
	beq	reg7		; jump if 1 byte reg
	ldaa	*shftreg
	staa	0,x		; put in top byte
	inx
reg7:	ldaa	*shftreg+1
	staa	0,x		; put in bottom byte
reg8:	pulx
	pula
	ldab	0,x		; check for register s
	cmpb	#'S
	beq	reg9		; jump if "s"
	inx			; point to next register
	cmpa	#0xd
	bne	reg5		; jump if not cr
reg9:	rts

page1	=	0x00		; values for page opcodes
page2	=	0x18
page3	=	0x1a
page4	=	0xcd
immed	=	0x0		; addressing modes
indx	=	0x1
indy	=	0x2
limmed	=	0x3		; (long immediate)
other	=	0x4

;*** rename variables for assem/disassem ***
amode	=	tmp2		; addressing mode
yflag	=	tmp3
pnorm	=	tmp4		; page for normal opcode
oldpc	=	ptrmem
pc	=	ptr1		; program counter
px	=	ptr2		; page for x indexed
py	=	ptr2+1		; page for y indexed
baseop	=	ptr3		; base opcode
class	=	ptr3+1		; class
dispc	=	ptr4		; pc for disassembler
braddr	=	ptr5		; relative branch offset
mneptr	=	ptr6		; pointer to table for dis
asscomm	=	ptr7		; subcommand for assembler

;*** error messages for assembler ***
msgdir:	.word	#msga1		; message table index
	.word	#msga2
	.word	#msga3
	.word	#msga4
	.word	#msga5
	.word	#msga6
	.word	#msga7
	.word	#msga8
	.word	#msga9
msga1:	.ascii	'Immediate mode illegal'
	.byte	eot
msga2:	.ascii	'Error in mnemonic table'
	.byte	eot
msga3:	.ascii	'Illegal bit op'
	.byte	eot
msga4:	.ascii	'Bad argument'
	.byte	eot
msga5:	.ascii	'Mnemonic not found'
	.byte	eot
msga6:	.ascii	'Unknown addressing mode'
	.byte	eot
msga7:	.ascii	'Indexed addressing assumed'
	.byte	eot
msga8:	.ascii	'Syntax error'
	.byte	eot
msga9:	.ascii	'Branch out of range'
	.byte	eot

;****************
;*	assem(addr) -68hc11 line assembler/disassembler.
;*	this routine will disassemble the opcode at
;*<addr> and then allow the user to enter a line for
;*assembly. rules for assembly are as follows:
;* -a '#' sign indicates immediate addressing.
;* -a ',' (comma) indicates indexed addressing
;*	and the next character must be x or y.
;* -all arguments are assumed to be hex and the
;*	'$' sign shouldn't be used.
;* -arguments should be separated by 1 or more
;*	spaces or tabs.
;* -any input after the required number of
;*	arguments is ignored.
;* -upper or lower case makes no difference.
;*
;*	to signify end of input line, the following
;*commands are available and have the indicated action:
;*	<cr>  -carriage return finds the next opcode for
;*		assembly.  if there was no assembly input,
;*		the next opcode disassembled is retrieved
;*		from the disassembler.
;*	<lf>  -linefeed works the same as carriage return
;*		except if there was no assembly input, the
;*		<addr> is incremented and the next <addr> is
;*		disassembled.
;*	'^'  -up arrow decrements <addr> and the previous
;*		address is then disassembled.
;*	'/'  -slash redisassembles the current address.
;*
;*	to exit the assembler use control a.  of course
;*control x and del will also allow you to abort.
;**********
;*oldpc = rambase;
;*a = wskip();
;*if (a != cr)
;*	buffarg()
;*	a = wskip();
;*	if ( a != cr ) return(error);
;*	oldpc = a;

assem	= .
	ldx	#rambs
	stx	*oldpc
	jsr	wskip
	cmpa	#0x0d
	beq	assloop 	; jump if no argument
	jsr	buffarg
	jsr	wskip
	cmpa	#0x0d
	beq	assem1		; jump if argument ok
	ldx	#msga4		; "bad argument"
	jsr	outstrg
	rts
assem1:	ldx	*shftreg
	stx	*oldpc

;*repeat
;*	pc = oldpc;
;*	out2bsp(pc);
;*	disassem();
;*	a=readln();
;*	asscomm = a;	/* save command */
;*	if(a == ('^' or '/')) outcrlf;
;*	if(a == 0) return(error);

assloop:
	ldx	*oldpc
	stx	*pc
	jsr	outcrlf
	ldx	#pc
	jsr	out2bsp		; output the address
	jsr	disassm		; disassemble opcode
	jsr	outcrlf
	jsr	outspac
	jsr	outspac
	jsr	outspac
	jsr	outspac
	ldaa	#prompt		; prompt user
	jsr	outa		; output prompt character
	jsr	readln		; read input for assembly
	staa	*asscomm
	cmpa	#'^
	beq	asslp0		; jump if up arrow
	cmpa	#'/
	beq	asslp0		; jump if slash
	cmpa	#0x00
	bne	asslp1		; jump if none of above
	rts			; return if bad input
asslp0:	jsr	outcrlf
asslp1	= .
	jsr	outspac
	jsr	outspac
	jsr	outspac
	jsr	outspac
	jsr	outspac

;*	b = parse(input); /* get mnemonic */
;*	if(b > 5) print("not found"); asscomm='/';
;*	elseif(b >= 1)
;*	msrch();
;*	if(class==0xff)
;*	print("not found"); asscomm='/';
;*	else
;*	a = doop(opcode,class);
;*	if(a == 0) dispc=0;
;*	else process error; asscomm='/';

	jsr	parse
	cmpb	#0x5
	ble	asslp2		; jump if mnemonic <= 5 chars
	ldx	#msga5		; "mnemonic not found"
	jsr	outstrg
	bra	asslp5
asslp2	= .
	cmpb	#0x0
	beq	asslp10 	; jump if no input
	jsr	msrch
	ldaa	*class
	cmpa	#0xff
	bne	asslp3
	ldx	#msga5		; "mnemonic not found"
	jsr	outstrg
	bra	asslp5
asslp3:	jsr	doop
	cmpa	#0x00
	bne	asslp4		; jump if doop error
	ldx	#0x00
	stx	*dispc		; indicate good assembly
	bra	asslp10
asslp4:	deca			; a = error message index
	tab
	ldx	#msgdir
	abx
	abx
	ldx	0,x
	jsr	outstrg 	; output error message
asslp5:	clr	*asscomm 	; error command

;*	/* compute next address - asscomm holds subcommand
;*	and dispc indicates if valid assembly occured. */
;*  if(asscomm=='^') oldpc -= 1;
;*  if(asscomm==(lf or cr)
;*	if(dispc==0) oldpc=pc;
;*	else
;*	if(asscomm==lf) dispc=oldpc+1;
;*	oldpc=dispc;
;*until(eot)


asslp10	= .
	ldaa	*asscomm
	cmpa	#'^
	bne	asslp11		; jump if not up arrow
	ldx	*oldpc
	dex
	stx	*oldpc		; back up
	bra	asslp15
asslp11:
	cmpa	#0x0a
	beq	asslp12		; jump if linefeed
	cmpa	#0x0d
	bne	asslp15		; jump if not cr
asslp12:
	ldx	*dispc
	bne	asslp13		; jump if dispc != 0
	ldx	*pc
	stx	*oldpc
	bra	asslp15
asslp13:
	cmpa	#0x0a
	bne	asslp14		; jump if not linefeed
	ldx	*oldpc
	inx
	stx	*dispc
asslp14:
	ldx	*dispc
	stx	*oldpc
asslp15:
	jmp	assloop

;****************
;*	readln() --- read input from terminal into buffer
;* until a command character is read (cr,lf,/,^).
;* if more chars are typed than the buffer will hold,
;* the extra characters are overwritten on the end.
;*  on exit: b=number of chars read, a=0 if quit,
;* else a=next command.
;****************
;*for(b==0;b<=bufflng;b++) inbuff[b] = cr;

readln:	clrb
	ldaa	#0x0d		; carriage ret
rln0:	ldx	#inbuff
	abx
	staa	0,x		; initialize input buffer
	incb
	cmpb	#bufflng
	blt	rln0
;*b=0;
;*repeat
;*	if(a == (ctla, cntlc, cntld, cntlx, del))
;*	return(a=0);
;*  if(a == backspace)
;*	if(b > 0) b--;
;*	else b=0;
;*  else  inbuff[b] = upcase(a);
;*  if(b < bufflng) b++;
;*until (a == (cr,lf,^,/))
;*return(a);

	clrb
rln1:	jsr	inchar
	cmpa	#del		; delete
	beq	rlnquit
	cmpa	#ctlx		; control x
	beq	rlnquit
	cmpa	#ctla		; control a
	beq	rlnquit
	cmpa	#0x03		; control c
	beq	rlnquit
	cmpa	#0x04		; control d
	beq	rlnquit
	cmpa	#0x08		; backspace
	bne	rln2
	decb
	bgt	rln1
	bra	readln		; start over
rln2:	ldx	#inbuff
	abx
	jsr	upcase
	staa	0,x		; put char in buffer
	cmpb	#bufflng	; max buffer length
	bge	rln3		; jump if buffer full
	incb			; move buffer pointer
rln3:	jsr	asschek 	; check for subcommand
	bne	rln1
	rts
rlnquit:
	clra			; quit
	rts			; return


;**********
;*	parse() -parse out the mnemonic from inbuff
;* to combuff. on exit: b=number of chars parsed.
;**********
;*combuff[3] = <space>;	initialize 4th character to space.
;*ptrbuff[] = inbuff[];
;*a=wskip();
;*for (b = 0; b = 5; b++)
;*	a=readbuff(); incbuff();
;*	if (a = (cr,lf,^,/,wspace)) return(b);
;*	combuff[b] = upcase(a);
;*return(b);

parse:	ldaa	#0x20
	staa	*combuff+3
	ldx	#inbuff		; initialize buffer ptr
	stx	*ptr0
	jsr	wskip		; find first character
	clrb
parslp:	jsr	readbuff	; read character
	jsr	incbuff
	jsr	wchek
	beq	parsrt		; jump if whitespace
	jsr	asschek
	beq	parsrt		; jump if end of line
	jsr	upcase		; convert to upper case
	ldx	#combuff
	abx
	staa	0,x		; store in combuff
	incb
	cmpb	#0x5
	ble	parslp		; loop 6 times
parsrt:	rts


;****************
;*	asschek() -perform compares for
;* cr, lf, ^, /
;****************
asschek:
	cmpa	#0x0a		; linefeed
	beq	asschk1
	cmpa	#0x0d		; carriage ret
	beq	asschk1
	cmpa	#'^		; up arrow
	beq	asschk1
	cmpa	#'/		; slash
asschk1:
	rts


;*********
;*	msrch() --- search mnetabl for mnemonic in combuff.
;*stores base opcode at baseop and class at class.
;*  class = ff if not found.
;**********
;*while ( != eof )
;*	if (combuff[0-3] = mnetabl[0-3])
;*	return(mnetabl[4],mnetabl[5]);
;*	else *mnetabl =+ 6

msrch:	ldx	#mnetabl	; pointer to mnemonic table
	ldy	#combuff	; pointer to string
	bra	msrch1
msnext	= .
	ldab	#6
	abx			; point to next table entry
msrch1:	ldaa	0,x		; read table
	cmpa	#eot
	bne	msrch2		; jump if not end of table
	ldaa	#0xff
	staa	*class		; ff = not in table
	rts
msrch2:	cmpa	0,y		; op[0] = tabl[0] ?
	bne	msnext
	ldaa	1,x
	cmpa	1,y		; op[1] = tabl[1] ?
	bne	msnext
	ldaa	2,x
	cmpa	2,y		; op[2] = tabl[2] ?
	bne	msnext
	ldaa	3,x
	cmpa	3,y		; op[2] = tabl[2] ?
	bne	msnext
	ldd	4,x		; opcode, class
	staa	*baseop
	stab	*class
	rts

;**********
;**	doop(baseop,class) --- process mnemonic.
;**	on exit: a=error code corresponding to error
;**					messages.
;**********
;*amode = other; /* addressing mode */
;*yflag = 0;	/* ynoimm, nlimm, and cpd flag */
;*x[] = ptrbuff[]

doop	= .
	ldaa	#other
	staa	*amode		; mode
	clr	*yflag
	ldx	*ptr0

;*while (*x != end of buffer)
;*	if (x[0]++ == ',')
;*	if (x[0] == 'y') amode = indy;
;*	else amod = indx;
;*	break;
;*a = wskip()
;*if( a == '#' ) amode = immed;

doplp1:	cpx	#endbuff	; (end of buffer)
	beq	doop1		; jump if end of buffer
	ldd	0,x		; read 2 chars from buffer
	inx			; move pointer
	cmpa	#',
	bne	doplp1
	cmpb	#'Y		; look for ",y"
	bne	doplp2
	ldaa	#indy
	staa	*amode
	bra	doop1
doplp2:	cmpb	#'X		; look for ",x"
	bne	doop1		; jump if not x
	ldaa	#indx
	staa	*amode
	bra	doop1
doop1:	jsr	wskip
	cmpa	#'#		; look for immediate mode
	bne	doop2
	jsr	incbuff 	; point at argument
	ldaa	#immed
	staa	*amode
doop2	= .

;*switch(class)
	ldab	*class
	cmpb	#p2inh
	bne	dosw1
	jmp	dop2i
dosw1:	cmpb	#inh
	bne	dosw2
	jmp	doinh
dosw2:	cmpb	#rel
	bne	dosw3
	jmp	dorel
dosw3:	cmpb	#limm
	bne	dosw4
	jmp	dolim
dosw4:	cmpb	#nimm
	bne	dosw5
	jmp	donoi
dosw5:	cmpb	#gen
	bne	dosw6
	jmp	dogene
dosw6:	cmpb	#grp2
	bne	dosw7
	jmp	dogrp
dosw7:	cmpb	#cpd
	bne	dosw8
	jmp	docpd
dosw8:	cmpb	#xnimm
	bne	dosw9
	jmp	doxnoi
dosw9:	cmpb	#xlimm
	bne	dosw10
	jmp	doxli
dosw10:	cmpb	#ynimm
	bne	dosw11
	jmp	doynoi
dosw11:	cmpb	#ylimm
	bne	dosw12
	jmp	doyli
dosw12:	cmpb	#btb
	bne	dosw13
	jmp	dobtb
dosw13:	cmpb	#setclr
	bne	dodef
	jmp	doset

;*	default: return("error in mnemonic table");

dodef:	ldaa	#0x2
	rts

;*  case p2inh: emit(page2)

dop2i:	ldaa	#page2
	jsr	emit

;*  case inh: emit(baseop);
;*	return(0);

doinh:	ldaa	*baseop
	jsr	emit
	clra
	rts

;*  case rel: a = assarg();
;*		if(a=4) return(a);
;*		d = address - pc + 2;
;*		if (0x7f >= d >= 0xff82)
;*		return (out of range);
;*		emit(opcode);
;*		emit(offset);
;*		return(0);

dorel:	jsr	assarg
	cmpa	#0x04
	bne	dorel1		; jump if arg ok
	rts
dorel1:	ldd	*shftreg 	; get branch address
	ldx	*pc		; get program counter
	inx
	inx			; point to end of opcode
	stx	*braddr
	subd	*braddr		; calculate offset
	std	*braddr		; save result
	cmpd	#0x7f		; in range ?
	bls	dorel2		; jump if in range
	cmpd	#0xff80
	bhs	dorel2		; jump if in range
	ldaa	#0x09		; 'out of range'
	rts
dorel2:	ldaa	*baseop
	jsr	emit		; emit opcode
	ldaa	*braddr+1
	jsr	emit		; emit offset
	clra			; normal return
	rts

;*	case limm: if (amode == immed) amode = limmed;

dolim:	ldaa	*amode
	cmpa	#immed
	bne	donoi
	ldaa	#limmed
	staa	*amode

;*	case nimm: if (amode == immed)
;*		return("immediate mode illegal");

donoi:	ldaa	*amode
	cmpa	#immed
	bne	dogene		; jump if not immediate
	ldaa	#0x1		; "immediate mode illegal"
	rts

;*  case gen: dogen(baseop,amode,page1,page1,page2);
;*		return;

dogene:	ldaa	#page1
	staa	*pnorm
	staa	*px
	ldaa	#page2
	staa	*py
	jsr	dogen
	rts

;*  case grp2: if (amode == indy)
;*		emit(page2);
;*		amode = indx;
;*		if( amode == indx )
;*		doindx(baseop);
;*		else a = assarg();
;*		if(a=4) return(a);
;*		emit(opcode+0x10);
;*		emit(extended address);
;*		return;

dogrp:	ldaa	*amode
	cmpa	#indy
	bne	dogrp1
	ldaa	#page2
	jsr	emit
	ldaa	#indx
	staa	*amode
dogrp1	= .
	ldaa	*amode
	cmpa	#indx
	bne	dogrp2
	jsr	doindex
	rts
dogrp2	= .
	ldaa	*baseop
	adda	#0x10
	jsr	emit
	jsr	assarg
	cmpa	#0x04
	beq	dogrprt 	; jump if bad arg
	ldd	*shftreg 	; extended address
	jsr	emit
	tba
	jsr	emit
	clra
dogrprt:
	rts

;*  case cpd: if (amode == immed)
;*		amode = limmed; /* cpd */
;*		if( amode == indy ) yflag = 1;
;*		dogen(baseop,amode,page3,page3,page4);
;*		return;

docpd:	ldaa	*amode
	cmpa	#immed
	bne	docpd1
	ldaa	#limmed
	staa	*amode
docpd1:	ldaa	*amode
	cmpa	#indy
	bne	docpd2
	inc	*yflag
docpd2:	ldaa	#page3
	staa	*pnorm
	staa	*px
	ldaa	#page4
	staa	*py
	jsr	dogen
	rts

;*	case xnimm: if (amode == immed)	/* stx */
;*			return("immediate mode illegal");

doxnoi:	ldaa	*amode
	cmpa	#immed
	bne	doxli
	ldaa	#0x1		; "immediate mode illegal"
	rts

;*	case xlimm: if (amode == immed)	/* cpx, ldx */
;*			amode = limmed;
;*		dogen(baseop,amode,page1,page1,page4);
;*		return;

doxli:	ldaa	*amode
	cmpa	#immed
	bne	doxli1
	ldaa	#limmed
	staa	*amode
doxli1:	ldaa	#page1
	staa	*pnorm
	staa	*px
	ldaa	#page4
	staa	*py
	jsr	dogen
	rts

;*	case ynimm: if (amode == immed)	/* sty */
;*			return("immediate mode illegal");

doynoi:	ldaa	*amode
	cmpa	#immed
	bne	doyli
	ldaa	#0x1		; "immediate mode illegal"
	rts

;*	case ylimm: if (amode == indy) yflag = 1;/* cpy, ldy */
;*		if(amode == immed) amode = limmed;
;*		dogen(opcode,amode,page2,page3,page2);
;*		return;

doyli:	ldaa	*amode
	cmpa	#indy
	bne	doyli1
	inc	*yflag
doyli1:	cmpa	#immed
	bne	doyli2
	ldaa	#limmed
	staa	*amode
doyli2:	ldaa	#page2
	staa	*pnorm
	staa	*py
	ldaa	#page3
	staa	*px
	jsr	dogen
	rts

;*	case btb:		/* bset, bclr */
;*	case setclr: a = bitop(baseop,amode,class);
;*		if(a=0) return(a = 3);
;*		if( amode == indy )
;*			emit(page2);
;*			amode = indx;

dobtb	= .
doset:	jsr	bitop
	cmpa	#0x00
	bne	doset1
	ldaa	#0x3		; "illegal bit op"
	rts
doset1:	ldaa	*amode
	cmpa	#indy
	bne	doset2
	ldaa	#page2
	jsr	emit
	ldaa	#indx
	staa	*amode
doset2	= .

;*		emit(baseop);
;*		a = assarg();
;*		if(a = 4) return(a);
;*		emit(index offset);
;*		if( amode == indx )
;*			buffptr += 2;	/* skip ,x or ,y */

	ldaa	*baseop
	jsr	emit
	jsr	assarg
	cmpa	#0x04
	bne	doset22		; jump if arg ok
	rts
doset22:
	ldaa	*shftreg+1	; index offset
	jsr	emit
	ldaa	*amode
	cmpa	#indx
	bne	doset3
	jsr	incbuff
	jsr	incbuff
doset3	= .

;*		a = assarg();
;*		if(a = 4) return(a);
;*		emit(mask);	/* mask */
;*		if( class == setclr )
;*			return;

	jsr	assarg
	cmpa	#0x04
	bne	doset33		; jump if arg ok
	rts
doset33:
	ldaa	*shftreg+1	; mask
	jsr	emit
	ldaa	*class
	cmpa	#setclr
	bne	doset4
	clra
	rts
doset4	= .

;*		a = assarg();
;*		if(a = 4) return(a);
;*		d = (pc+1) - shftreg;
;*		if (0x7f >= d >= 0xff82)
;*			return (out of range);
;*		emit(branch offset);
;*		return(0);

	jsr	assarg
	cmpa	#0x04
	bne	doset5		; jump if arg ok
	rts
doset5:	ldx	*pc 		; program counter
	inx			; point to next inst
	stx	*braddr		; save pc value
	ldd	*shftreg		; get branch address
	subd	*braddr		; calculate offset
	cmpd	#0x7f
	bls	doset6		; jump if in range
	cmpd	#0xff80
	bhs	doset6		; jump if in range
	clra
	jsr	emit
	ldaa	#0x09		; 'out of range'
	rts
doset6:	tba			; offset
	jsr	emit
	clra
	rts


;**********
;**	bitop(baseop,amode,class) --- adjust opcode on bit
;**	manipulation instructions.  returns opcode in a
;**	or a = 0 if error
;**********
;*if( amode == indx || amode == indy ) return(op);
;*if( class == setclr ) return(op-8);
;*else if(class==btb) return(op-12);
;*else fatal("bitop");

bitop	= .
	ldaa	*amode
	ldab	*class
	cmpa	#indx
	bne	bitop1
	rts
bitop1:	cmpa	#indy
	bne	bitop2		; jump not indexed
	rts
bitop2:	cmpb	#setclr
	bne	bitop3		; jump not bset,bclr
	ldaa	*baseop		; get opcode
	suba	#8
	staa	*baseop
	rts
bitop3:	cmpb	#btb
	bne	bitop4		; jump not bit branch
	ldaa	*baseop		; get opcode
	suba	#12
	staa	*baseop
	rts
bitop4:	clra			; 0 = fatal bitop
	rts

;**********
;**	dogen(baseop,mode,pnorm,px,py) - process
;** general addressing modes. returns a = error	#.
;**********
;*pnorm = page for normal addressing modes: imm,dir,ext
;*px = page for indx addressing
;*py = page for indy addressing
;*switch(amode)
dogen:	ldaa	*amode
	cmpa	#limmed
	beq	doglim
	cmpa	#immed
	beq	dogimm
	cmpa	#indy
	beq	dogindy
	cmpa	#indx
	beq	dogindx
	cmpa	#other
	beq	dogoth

;*default: error("unknown addressing mode");

dogdef:	ldaa	#0x06		; unknown addre...
	rts

;*case limmed: epage(pnorm);
;*		emit(baseop);
;*		a = assarg();
;*		if(a = 4) return(a);
;*		emit(2 bytes);
;*		return(0);

doglim:	ldaa	*pnorm
	jsr	epage
doglim1:
	ldaa	*baseop
	jsr	emit
	jsr	assarg		; get next argument
	cmpa	#0x04
	bne	doglim2		; jump if arg ok
	rts
doglim2:
	ldd	*shftreg
	jsr	emit
	tba
	jsr	emit
	clra
	rts

;*case immed: epage(pnorm);
;*		emit(baseop);
;*		a = assarg();
;*		if(a = 4) return(a);
;*		emit(lobyte);
;*		return(0);

dogimm:	ldaa	*pnorm
	jsr	epage
	ldaa	*baseop
	jsr	emit
	jsr	assarg
	cmpa	#0x04
	bne	dogimm1		; jump if arg ok
	rts
dogimm1:
	ldaa	*shftreg+1
	jsr	emit
	clra
	rts

;*case indy: epage(py);
;*		a=doindex(op+0x20);
;*		return(a);

dogindy:
	ldaa	*py
	jsr	epage
	ldaa	*baseop
	adda	#0x20
	staa	*baseop
	jsr	doindex
	rts

;*case indx: epage(px);
;*		a=doindex(op+0x20);
;*		return(a);

dogindx:
	ldaa	*px
	jsr	epage
	ldaa	*baseop
	adda	#0x20
	staa	*baseop
	jsr	doindex
	rts

;*case other: a = assarg();
;*		if(a = 4) return(a);
;*		epage(pnorm);
;*		if(countu1 <= 2 digits)	/* direct */
;*		emit(op+0x10);
;*		emit(lobyte(result));
;*		return(0);
;*		else	emit(op+0x30);	/* extended */
;*		eword(result);
;*		return(0)

dogoth:	jsr	assarg
	cmpa	#0x04
	bne	dogoth0		; jump if arg ok
	rts
dogoth0:
	ldaa	*pnorm
	jsr	epage
	ldaa	*count
	cmpa	#0x2
	bgt	dogoth1
	ldaa	*baseop
	adda	#0x10		; direct mode opcode
	jsr	emit
	ldaa	*shftreg+1
	jsr	emit
	clra
	rts
dogoth1:
	ldaa	*baseop
	adda	#0x30		; extended mode opcode
	jsr	emit
	ldd	*shftreg
	jsr	emit
	tba
	jsr	emit
	clra
	rts

;**********
;**	doindex(op) --- handle all wierd stuff for
;**	indexed addressing. returns a = error number.
;**********
;*emit(baseop);
;*a=assarg();
;*if(a = 4) return(a);
;*if( a != ',' ) return("syntax");
;*buffptr++
;*a=readbuff()
;*if( a != 'x' && != 'y') warn("ind addr assumed");
;*emit(lobyte);
;*return(0);

doindex:
	ldaa	*baseop
	jsr	emit
	jsr	assarg
	cmpa	#0x04
	bne	doindx0		; jump if arg ok
	rts
doindx0:
	cmpa	#',
	beq	doindx1
	ldaa	#0x08		; "syntax error"
	rts
doindx1:
	jsr	incbuff
	jsr	readbuff
	cmpa	#'Y
	beq	doindx2
	cmpa	#'X
	beq	doindx2
	ldx	msga7		; "index addr assumed"
	jsr	outstrg
doindx2:
	ldaa	*shftreg+1
	jsr	emit
	clra
	rts

;**********
;**	assarg(); - get argument.	returns a = 4 if bad
;** argument, else a = first non hex char.
;**********
;*a = buffarg()
;*if(asschk(aa) && countu1 != 0) return(a);
;*return(bad argument);

assarg:	jsr	buffarg
	jsr	asschek		; check for command
	beq	assarg1		; jump if ok
	jsr	wchek		; check for whitespace
	bne	assarg2		; jump if not ok
assarg1:
	tst	*count
	beq	assarg2		; jump if no argument
	rts
assarg2:
	ldaa	#0x04		; bad argument
	rts

;**********
;**  epage(a) --- emit page prebyte
;**********
;*if( a != page1 ) emit(a);

epage:	cmpa	#page1
	beq	epagrt		; jump if page 1
	jsr	emit
epagrt:	rts

;**********
;*	emit(a) --- emit contents of a
;**********
emit:	ldx	*pc
	staa	0,x
	jsr	out1bsp
	stx	*pc
	rts

;*mnemonic table for hc11 line assembler
null	=	0x0		; nothing
inh	=	0x1		; inherent
p2inh	=	0x2		; page 2 inherent
gen	=	0x3		; general addressing
grp2	=	0x4		; group 2
rel	=	0x5		; relative
imm	=	0x6		; immediate
nimm	=	0x7		; general except for immediate
limm	=	0x8		; 2 byte immediate
xlimm	=	0x9		; longimm for x
xnimm	=	0x10		; no immediate for x
ylimm	=	0x11		; longimm for y
ynimm	=	0x12		; no immediate for y
btb	=	0x13		; bit test and branch
setclr	=	0x14		; bit set or clear
cpd	=	0x15		; compare d
btbd	=	0x16		; bit test and branch direct
setclrd	=	0x17		; bit set or clear direct

;**********
;*	mnetabl - includes all '11 mnemonics, base opcodes,
;* and type of instruction.  the assembler search routine
;*depends on 4 characters for each mnemonic so that 3 char
;*mnemonics are extended with a space and 5 char mnemonics
;*are truncated.
;**********

mnetabl	= .
	.ascii	'ABA '		; mnemonic
	.byte	0x1b		; base opcode
	.byte	inh		; class
	.ascii	'ABX '
	.byte	0x3a
	.byte	inh
	.ascii	'ABY '
	.byte	0x3a
	.byte	p2inh
	.ascii	'ADCA'
	.byte	0x89
	.byte	gen
	.ascii	'ADCB'
	.byte	0xc9
	.byte	gen
	.ascii	'ADDA'
	.byte	0x8b
	.byte	gen
	.ascii	'ADDB'
	.byte	0xcb
	.byte	gen
	.ascii	'ADDD'
	.byte	0xc3
	.byte	limm
	.ascii	'ANDA'
	.byte	0x84
	.byte	gen
	.ascii	'ANDB'
	.byte	0xc4
	.byte	gen
	.ascii	'ASL '
	.byte	0x68
	.byte	grp2
	.ascii	'ASLA'
	.byte	0x48
	.byte	inh
	.ascii	'ASLB'
	.byte	0x58
	.byte	inh
	.ascii	'ASLD'
	.byte	0x05
	.byte	inh
	.ascii	'ASR '
	.byte	0x67
	.byte	grp2
	.ascii	'ASRA'
	.byte	0x47
	.byte	inh
	.ascii	'ASRB'
	.byte	0x57
	.byte	inh
	.ascii	'BCC '
	.byte	0x24
	.byte	rel
	.ascii	'BCLR'
	.byte	0x1d
	.byte	setclr
	.ascii	'BCS '
	.byte	0x25
	.byte	rel
	.ascii	'BEQ '
	.byte	0x27
	.byte	rel
	.ascii	'BGE '
	.byte	0x2c
	.byte	rel
	.ascii	'BGT '
	.byte	0x2e
	.byte	rel
	.ascii	'BHI '
	.byte	0x22
	.byte	rel
	.ascii	'BHS '
	.byte	0x24
	.byte	rel
	.ascii	'BITA'
	.byte	0x85
	.byte	gen
	.ascii	'BITB'
	.byte	0xc5
	.byte	gen
	.ascii	'BLE '
	.byte	0x2f
	.byte	rel
	.ascii	'BLO '
	.byte	0x25
	.byte	rel
	.ascii	'BLS '
	.byte	0x23
	.byte	rel
	.ascii	'BLT '
	.byte	0x2d
	.byte	rel
	.ascii	'BMI '
	.byte	0x2b
	.byte	rel
	.ascii	'BNE '
	.byte	0x26
	.byte	rel
	.ascii	'BPL '
	.byte	0x2a
	.byte	rel
	.ascii	'BRA '
	.byte	0x20
	.byte	rel
	.ascii	'BRCL'		; (brclr)
	.byte	0x1f
	.byte	btb
	.ascii	'BRN '
	.byte	0x21
	.byte	rel
	.ascii	'BRSE'		; (brset)
	.byte	0x1e
	.byte	btb
	.ascii	'BSET'
	.byte	0x1c
	.byte	setclr
	.ascii	'BSR '
	.byte	0x8d
	.byte	rel
	.ascii	'BVC '
	.byte	0x28
	.byte	rel
	.ascii	'BVS '
	.byte	0x29
	.byte	rel
	.ascii	'CBA '
	.byte	0x11
	.byte	inh
	.ascii	'CLC '
	.byte	0x0c
	.byte	inh
	.ascii	'CLI '
	.byte	0x0e
	.byte	inh
	.ascii	'CLR '
	.byte	0x6f
	.byte	grp2
	.ascii	'CLRA'
	.byte	0x4f
	.byte	inh
	.ascii	'CLRB'
	.byte	0x5f
	.byte	inh
	.ascii	'CLV '
	.byte	0x0a
	.byte	inh
	.ascii	'CMPA'
	.byte	0x81
	.byte	gen
	.ascii	'CMPB'
	.byte	0xc1
	.byte	gen
	.ascii	'COM '
	.byte	0x63
	.byte	grp2
	.ascii	'COMA'
	.byte	0x43
	.byte	inh
	.ascii	'COMB'
	.byte	0x53
	.byte	inh
	.ascii	'CPD '
	.byte	0x83
	.byte	cpd
	.ascii	'CPX '
	.byte	0x8c
	.byte	xlimm
	.ascii	'CPY '
	.byte	0x8c
	.byte	ylimm
	.ascii	'DAA '
	.byte	0x19
	.byte	inh
	.ascii	'DEC '
	.byte	0x6a
	.byte	grp2
	.ascii	'DECA'
	.byte	0x4a
	.byte	inh
	.ascii	'DECB'
	.byte	0x5a
	.byte	inh
	.ascii	'DES '
	.byte	0x34
	.byte	inh
	.ascii	'DEX '
	.byte	0x09
	.byte	inh
	.ascii	'DEY '
	.byte	0x09
	.byte	p2inh
	.ascii	'EORA'
	.byte	0x88
	.byte	gen
	.ascii	'EORB'
	.byte	0xc8
	.byte	gen
	.ascii	'FDIV'
	.byte	0x03
	.byte	inh
	.ascii	'IDIV'
	.byte	0x02
	.byte	inh
	.ascii	'INC '
	.byte	0x6c
	.byte	grp2
	.ascii	'INCA'
	.byte	0x4c
	.byte	inh
	.ascii	'INCB'
	.byte	0x5c
	.byte	inh
	.ascii	'INS '
	.byte	0x31
	.byte	inh
	.ascii	'INX '
	.byte	0x08
	.byte	inh
	.ascii	'INY '
	.byte	0x08
	.byte	p2inh
	.ascii	'JMP '
	.byte	0x6e
	.byte	grp2
	.ascii	'JSR '
	.byte	0x8d
	.byte	nimm
	.ascii	'LDAA'
	.byte	0x86
	.byte	gen
	.ascii	'LDAB'
	.byte	0xc6
	.byte	gen
	.ascii	'LDD '
	.byte	0xcc
	.byte	limm
	.ascii	'LDS '
	.byte	0x8e
	.byte	limm
	.ascii	'LDX '
	.byte	0xce
	.byte	xlimm
	.ascii	'LDY '
	.byte	0xce
	.byte	ylimm
	.ascii	'LSL '
	.byte	0x68
	.byte	grp2
	.ascii	'LSLA'
	.byte	0x48
	.byte	inh
	.ascii	'LSLB'
	.byte	0x58
	.byte	inh
	.ascii	'LSLD'
	.byte	0x05
	.byte	inh
	.ascii	'LSR '
	.byte	0x64
	.byte	grp2
	.ascii	'LSRA'
	.byte	0x44
	.byte	inh
	.ascii	'LSRB'
	.byte	0x54
	.byte	inh
	.ascii	'LSRD'
	.byte	0x04
	.byte	inh
	.ascii	'MUL '
	.byte	0x3d
	.byte	inh
	.ascii	'NEG '
	.byte	0x60
	.byte	grp2
	.ascii	'NEGA'
	.byte	0x40
	.byte	inh
	.ascii	'NEGB'
	.byte	0x50
	.byte	inh
	.ascii	'NOP '
	.byte	0x01
	.byte	inh
	.ascii	'ORAA'
	.byte	0x8a
	.byte	gen
	.ascii	'ORAB'
	.byte	0xca
	.byte	gen
	.ascii	'PSHA'
	.byte	0x36
	.byte	inh
	.ascii	'PSHB'
	.byte	0x37
	.byte	inh
	.ascii	'PSHX'
	.byte	0x3c
	.byte	inh
	.ascii	'PSHY'
	.byte	0x3c
	.byte	p2inh
	.ascii	'PULA'
	.byte	0x32
	.byte	inh
	.ascii	'PULB'
	.byte	0x33
	.byte	inh
	.ascii	'PULX'
	.byte	0x38
	.byte	inh
	.ascii	'PULY'
	.byte	0x38
	.byte	p2inh
	.ascii	'ROL '
	.byte	0x69
	.byte	grp2
	.ascii	'ROLA'
	.byte	0x49
	.byte	inh
	.ascii	'ROLB'
	.byte	0x59
	.byte	inh
	.ascii	'ROR '
	.byte	0x66
	.byte	grp2
	.ascii	'RORA'
	.byte	0x46
	.byte	inh
	.ascii	'RORB'
	.byte	0x56
	.byte	inh
	.ascii	'RTI '
	.byte	0x3b
	.byte	inh
	.ascii	'RTS '
	.byte	0x39
	.byte	inh
	.ascii	'SBA '
	.byte	0x10
	.byte	inh
	.ascii	'SBCA'
	.byte	0x82
	.byte	gen
	.ascii	'SBCB'
	.byte	0xc2
	.byte	gen
	.ascii	'SEC '
	.byte	0x0d
	.byte	inh
	.ascii	'SEI '
	.byte	0x0f
	.byte	inh
	.ascii	'SEV '
	.byte	0x0b
	.byte	inh
	.ascii	'STAA'
	.byte	0x87
	.byte	nimm
	.ascii	'STAB'
	.byte	0xc7
	.byte	nimm
	.ascii	'STD '
	.byte	0xcd
	.byte	nimm
	.ascii	'STOP'
	.byte	0xcf
	.byte	inh
	.ascii	'STS '
	.byte	0x8f
	.byte	nimm
	.ascii	'STX '
	.byte	0xcf
	.byte	xnimm
	.ascii	'STY '
	.byte	0xcf
	.byte	ynimm
	.ascii	'SUBA'
	.byte	0x80
	.byte	gen
	.ascii	'SUBB'
	.byte	0xc0
	.byte	gen
	.ascii	'SUBD'
	.byte	0x83
	.byte	limm
	.ascii	'SWI '
	.byte	0x3f
	.byte	inh
	.ascii	'TAB '
	.byte	0x16
	.byte	inh
	.ascii	'TAP '
	.byte	0x06
	.byte	inh
	.ascii	'TBA '
	.byte	0x17
	.byte	inh
	.ascii	'TPA '
	.byte	0x07
	.byte	inh
	.ascii	'TEST'
	.byte	0x00
	.byte	inh
	.ascii	'TST '
	.byte	0x6d
	.byte	grp2
	.ascii	'TSTA'
	.byte	0x4d
	.byte	inh
	.ascii	'TSTB'
	.byte	0x5d
	.byte	inh
	.ascii	'TSX '
	.byte	0x30
	.byte	inh
	.ascii	'TSY '
	.byte	0x30
	.byte	p2inh
	.ascii	'TXS '
	.byte	0x35
	.byte	inh
	.ascii	'TYS '
	.byte	0x35
	.byte	p2inh
	.ascii	'WAI '
	.byte	0x3e
	.byte	inh
	.ascii	'XGDX'
	.byte	0x8f
	.byte	inh
	.ascii	'XGDY'
	.byte	0x8f
	.byte	p2inh
	.ascii	'BRSE'		; bit direct modes for
	.byte	0x12		; disassembler.
	.byte	btbd
	.ascii	'BRCL'
	.byte	0x13
	.byte	btbd
	.ascii	'BSET'
	.byte	0x14
	.byte	setclrd
	.ascii	'BCLR'
	.byte	0x15
	.byte	setclrd
	.byte	eot		; end of table

;**********************************************
pg1	=	0x0
pg2	=	0x1
pg3	=	0x2
pg4	=	0x3

;******************
;*disassem() - disassemble the opcode.
;******************
;*(check for page prebyte)
;*baseop=pc[0];
;*pnorm=pg1;
;*if(baseop==0x18) pnorm=pg2;
;*if(baseop==0x1a) pnorm=pg3;
;*if(baseop==0xcd) pnorm=pg4;
;*if(pnorm != pg1) dispc=pc+1;
;*else dispc=pc; (dispc points to next byte)

disassm	= .
	ldx	*pc 		; address
	ldaa	0,x		; opcode
	ldab	#pg1
	cmpa	#0x18
	beq	disp2		; jump if page2
	cmpa	#0x1a
	beq	disp3		; jump if page3
	cmpa	#0xcd
	bne	disp1		; jump if not page4
disp4:	incb			; set up page value
disp3:	incb
disp2:	incb
	inx
disp1:	stx	*dispc		; point to opcode
	stab	*pnorm		; save page

;*if(opcode == (0x00-0x5f or 0x8d or 0x8f or 0xcf))
;*	if(pnorm == (pg3 or pg4))
;*	disillop(); return();
;*  b=disrch(opcode,null);
;*  if(b==0) disillop(); return();

	ldaa	0,x		; get current opcode
	staa	*baseop
	inx
	stx	*dispc		; point to next byte
	cmpa	#0x5f
	bls	dis1		; jump if in range
	cmpa	#0x8d
	beq	dis1		; jump if bsr
	cmpa	#0x8f
	beq	dis1		; jump if xgdx
	cmpa	#0xcf
	beq	dis1		; jump if stop
	jmp	disgrp		; try next part of map
dis1:	ldab	*pnorm
	cmpb	#pg3
	blo	dis2		; jump if page 1 or 2
	jsr	disillop	; "illegal opcode"
	rts
dis2:	ldab	*baseop		; opcode
	clrb			; class=null
	jsr	disrch
	tstb
	bne	dispec		; jump if opcode found
	jsr	disillop	; "illegal opcode"
	rts

;*	if(opcode==0x8d) dissrch(opcode,rel);
;*	if(opcode==(0x8f or 0xcf)) disrch(opcode,inh);

dispec:	ldaa	*baseop
	cmpa	#0x8d
	bne	dispec1
	ldab	#rel
	bra	dispec3		; look for bsr opcode
dispec1:
	cmpa	#0x8f
	beq	dispec2		; jump if xgdx opcode
	cmpa	#0xcf
	bne	disinh		; jump not stop opcode
dispec2:
	ldab	#inh
dispec3:
	jsr	disrch		; find other entry in table

;*	if(class==inh)		/* inh */
;*	if(pnorm==pg2)
;*	b=disrch(baseop,p2inh);
;*	if(b==0) disillop(); return();
;*	prntmne();
;*	return();

disinh	= .
	ldab	*class
	cmpb	#inh
	bne	disrel		; jump if not inherent
	ldab	*pnorm
	cmpb	#pg1
	beq	disinh1		; jump if page1
	ldaa	*baseop		; get opcode
	ldab	#p2inh		; class=p2inh
	jsr	disrch
	tstb
	bne	disinh1		; jump if found
	jsr	disillop	; "illegal opcode"
	rts
disinh1:
	jsr	prntmne
	rts

;*	elseif(class=rel)		/* rel */
;*	if(pnorm != pg1)
;*	disillop(); return();
;*	prntmne();
;*	disrelad();
;*	return();

disrel	= .
	ldab	*class
	cmpb	#rel
	bne	disbtd
	tst	*pnorm
	beq	disrel1		; jump if page1
	jsr	disillop	; "illegal opcode"
	rts
disrel1:
	jsr	prntmne		; output mnemonic
	jsr	disrelad	; compute relative address
	rts

;*	else		/* setclr,setclrd,btb,btbd */
;*	if(class == (setclrd or btbd))
;*		if(pnorm != pg1)
;*		disillop(); return();	/* illop */
;*		prntmne();		/* direct */
;*		disdir();		/* output 0xbyte */
;*	else (class == (setclr or btb))
;*		prntmne();		/* indexed */
;*		disindx();
;*	outspac();
;*	disdir();
;*	outspac();
;*	if(class == (btb or btbd))
;*		disrelad();
;*	return();

disbtd	= .
	ldab	*class
	cmpb	#setclrd
	beq	disbtd1
	cmpb	#btbd
	bne	disbit		; jump not direct bitop
disbtd1:
	tst	*pnorm
	beq	disbtd2		; jump if page 1
	jsr	disillop
	rts
disbtd2:
	jsr	prntmne
	jsr	disdir		; operand(direct)
	bra	disbit1
disbit	= .
	jsr	prntmne
	jsr	disindx		; operand(indexed)
disbit1:
	jsr	outspac
	jsr	disdir		; mask
	ldab	*class
	cmpb	#btb
	beq	disbit2		; jump if btb
	cmpb	#btbd
	bne	disbit3		; jump if not bit branch
disbit2:
	jsr	disrelad	; relative address
disbit3:
	rts


;*elseif(0x60 <= opcode <= 0x7f)  /*  grp2 */
;*	if(pnorm == (pg3 or pg4))
;*	disillop(); return();
;*	if((pnorm==pg2) and (opcode != 0x6x))
;*	disillop(); return();
;*	b=disrch(baseop & 0x6f,null);
;*	if(b==0) disillop(); return();
;*	prntmne();
;*	if(opcode == 0x6x)
;*	disindx();
;*	else
;*	disext();
;*	return();

disgrp	= .
	cmpa	#0x7f		; a=opcode
	bhi	disnext		; try next part of map
	ldab	*pnorm
	cmpb	#pg3
	blo	disgrp2		; jump if page 1 or 2
	jsr	disillop	; "illegal opcode"
	rts
disgrp2:
	anda	#0x6f		; mask bit 4
	clrb			; class=null
	jsr	disrch
	tstb
	bne	disgrp3		; jump if found
	jsr	disillop	; "illegal opcode"
	rts
disgrp3:
	jsr	prntmne
	ldaa	*baseop		; get opcode
	anda	#0xf0
	cmpa	#0x60
	bne	disgrp4		; jump if not 6x
	jsr	disindx		; operand(indexed)
	rts
disgrp4:
	jsr	disext		; operand(extended)
	rts

;*else	(0x80 <= opcode <= 0xff)
;*	if(opcode == (0x87 or 0xc7))
;*	disillop(); return();
;*	b=disrch(opcode&0xcf,null);
;*	if(b==0) disillop(); return();

disnext	= .
	cmpa	#0x87		; a=opcode
	beq	disnex1
	cmpa	#0xc7
	bne	disnex2
disnex1:
	jsr	disillop	; "illegal opcode"
	rts
disnex2:
	anda	#0xcf
	clrb			; class=null
	jsr	disrch
	tstb
	bne	disnew		; jump if mne found
	jsr	disillop	; "illegal opcode"
	rts

;*	if(opcode&0xcf==0x8d) disrch(baseop,nimm; (jsr)
;*	if(opcode&0xcf==0x8f) disrch(baseop,nimm; (sts)
;*	if(opcode&0xcf==0xcf) disrch(baseop,xnimm; (stx)
;*	if(opcode&0xcf==0x83) disrch(baseop,limm); (subd)

disnew:	ldaa	*baseop
	anda	#0xcf
	cmpa	#0x8d
	bne	disnew1		; jump not jsr
	ldab	#nimm
	bra	disnew4
disnew1:
	cmpa	#0x8f
	bne	disnew2		; jump not sts
	ldab	#nimm
	bra	disnew4
disnew2:
	cmpa	#0xcf
	bne	disnew3		; jump not stx
	ldab	#xnimm
	bra	disnew4
disnew3:
	cmpa	#0x83
	bne	disgen		; jump not subd
	ldab	#limm
disnew4:
	jsr	disrch
	tstb
	bne	disgen		; jump if found
	jsr	disillop	; "illegal opcode"
	rts

;*	if(class == (gen or nimm or limm	))	/* gen,nimm,limm,cpd */
;*	if(opcode&0xcf==0x83)
;*		if(pnorm==(pg3 or pg4)) disrch(opcode#0xcf,cpd)
;*		class=limm;
;*	if((pnorm == (pg2 or pg4) and (opcode != (0xax or 0xex)))
;*		disillop(); return();
;*	disgenrl();
;*	return();

disgen:	ldab	*class		; get class
	cmpb	#gen
	beq	disgen1
	cmpb	#nimm
	beq	disgen1
	cmpb	#limm
	bne	disxln		; jump if other class
disgen1:
	ldaa	*baseop
	anda	#0xcf
	cmpa	#0x83
	bne	disgen3		; jump if not	#0x83
	ldab	*pnorm
	cmpb	#pg3
	blo	disgen3		; jump not pg3 or 4
	ldab	#cpd
	jsr	disrch		; look for cpd mne
	ldab	#limm
	stab	*class		; set class to limm
disgen3:
	ldab	*pnorm
	cmpb	#pg2
	beq	disgen4		; jump if page 2
	cmpb	#pg4
	bne	#disgen5	; jump not page 2 or 4
disgen4:
	ldaa	*baseop
	anda	#0xb0		; mask bits 6,3-0
	cmpa	#0xa0
	beq	disgen5		; jump if 0xax or 0xex
	jsr	disillop	; "illegal opcode"
	rts
disgen5:
	jsr	disgenrl	; process general class
	rts

;*	else	/* xlimm,xnimm,ylimm,ynimm */
;*	if(pnorm==(pg2 or pg3))
;*	if(class==xlimm) disrch(opcode&0xcf,ylimm);
;*	else disrch(opcode&0xcf,ynimm);
;*	if((pnorm == (pg3 or pg4))
;*	if(opcode != (0xax or 0xex))
;*		disillop(); return();
;*	class=limm;
;*	disgen();
;*	return();

disxln:	ldab	*pnorm
	cmpb	#pg2
	beq	disxln1		; jump if page2
	cmpb	#pg3
	bne	disxln4		; jump not page3
disxln1:
	ldaa	*baseop
	anda	#0xcf
	ldab	*class
	cmpb	#xlimm
	bne	disxln2
	ldab	#ylimm
	bra	disxln3		; look for ylimm
disxln2:
	ldab	#ynimm		; look for ynimm
disxln3:
	jsr	disrch
disxln4:
	ldab	*pnorm
	cmpb	#pg3
	blo	disxln5		; jump if page 1 or 2
	ldaa	*baseop		; get opcode
	anda	#0xb0		; mask bits 6,3-0
	cmpa	#0xa0
	beq	disxln5		; jump opcode = 0xax or 0xex
	jsr	disillop	; "illegal opcode"
	rts
disxln5:
	ldab	#limm
	stab	*class
	jsr	disgenrl	; process general class
	rts


;******************
;*disrch(a=opcode,b=class)
;*return b=0 if not found
;*	else mneptr=points to mnemonic
;*	class=class of opcode
;******************
;*x=#mnetabl
;*while(x[0] != eot)
;*	if((opcode==x[4]) && ((class=null) || (class=x[5])))
;*	mneptr=x;
;*	class=x[5];
;*	return(1);
;*	x += 6;
;*return(0);	/* not found */

disrch	= .
	ldx	#mnetabl	; point to top of table
disrch1:
	cmpa	4,x		; test opcode
	bne	disrch3		; jump not this entry
	tstb
	beq	disrch2		; jump if class=null
	cmpb	5,x		; test class
	bne	disrch3		; jump not this entry
disrch2:
	ldab	5,x
	stab	*class
	stx	*mneptr		; return ptr to mnemonic
	incb
	rts			; return found
disrch3:
	pshb			; save class
	ldab	#6
	abx
	ldab	0,x
	cmpb	#eot		; test end of table
	pulb
	bne	disrch1
	clrb
	rts			; return not found

;******************
;*prntmne() - output the mnemonic pointed
;*at by mneptr.
;******************
;*outa(mneptr[0-3]);
;*outspac;
;*return();

prntmne	= .
	ldx	*mneptr
	ldaa	0,x
	jsr	outa		; output char1
	ldaa	1,x
	jsr	outa		; output char2
	ldaa	2,x
	jsr	outa		; output char3
	ldaa	3,x
	jsr	outa		; output char4
	jsr	outspac
	rts

;******************
;*disindx() - process indexed mode
;******************
;*disdir();
;*outa(',');
;*if(pnorm == (pg2 or pg4)) outa('y');
;*else outa('x');
;*return();

disindx	= .
	jsr	disdir		; output 0xbyte
	ldaa	#',
	jsr	outa		; output ,
	ldab	*pnorm
	cmpb	#pg2
	beq	disind1		; jump if page2
	cmpb	#pg4
	bne	disind2		; jump if not page4
disind1:
	ldaa	#'Y
	bra disind3
disind2:
	ldaa	#'X
disind3:
	jsr	outa		; output x or y
	rts

;******************
;*disrelad() - compute and output relative address.
;******************
;* braddr = dispc[0] + (dispc++);( 2's comp arith)
;*outa('$');
;*out2bsp(braddr);
;*return();

disrelad	= .
	ldx	*dispc
	ldab	0,x		; get relative offset
	inx
	stx	*dispc
	tstb
	bmi	disrld1		; jump if negative
	abx
	bra	disrld2
disrld1:
	dex
	incb
	bne	disrld1		; subtract
disrld2:
	stx	*braddr		; save address
	jsr	outspac
	ldaa	#'$
	jsr	outa
	ldx	#braddr
	jsr	out2bsp		; output address
	rts


;******************
;*disgenrl() - output data for the general cases which
;*includes immediate, direct, indexed, and extended modes.
;******************
;*prntmne();
;*if(baseop == (0x8x or 0xcx))	/* immediate */
;*	outa('#');
;*	disdir();
;*	if(class == limm)
;*	out1byt(dispc++);
;*elseif(baseop == (0x9x or 0xdx))	/* direct */
;*	disdir();
;*elseif(baseop == (0xax or 0xex)) /* indexed */
;*	disindx();
;*else	(baseop == (0xbx or 0xfx)) /* extended */
;*	disext();
;*return();

disgenrl	= .
	jsr	prntmne		; print mnemonic
	ldaa	*baseop		; get opcode
	anda	#0xb0		; mask bits 6,3-0
	cmpa	#0x80
	bne	disgrl2		; jump if not immed
	ldaa	#'#		; do immediate
	jsr	outa
	jsr	disdir
	ldab	*class
	cmpb	#limm
	beq	disgrl1		; jump class = limm
	rts
disgrl1:
	ldx	*dispc
	jsr	out1byt
	stx	*dispc
	rts
disgrl2:
	cmpa	#0x90
	bne	disgrl3		; jump not direct
	jsr	disdir		; do direct
	rts
disgrl3:
	cmpa	#0xa0
	bne	disgrl4		; jump not indexed
	jsr	disindx		; do extended
	rts
disgrl4:
	jsr	disext		; do extended
	rts

;*****************
;*disdir() - output "$ next byte"
;*****************
disdir	= .
	ldaa	#'$
	jsr	outa
	ldx	*dispc
	jsr	out1byt
	stx	*dispc
	rts

;*****************
;*disext() - output "$ next 2 bytes"
;*****************
disext	= .
	ldaa	#'$
	jsr	outa
	ldx	*dispc
	jsr	out2bsp
	stx	*dispc
	rts


;*****************
;*disillop() - output "illegal opcode"
;*****************
dismsg1:
	.ascii	'ILLOP'
	.byte	eot
disillop	= .
	pshx
	ldx	#dismsg1
	jsr	outstrg0	; no cr
	pulx
	rts

;* equates
jportd	=	0x08
jddrd	=	0x09
jbaud	=	0x2b
jsccr1	=	0x2c
jsccr2	=	0x2d
jscsr	=	0x2e
jscdat	=	0x2f
;*

;************
;*	boot [<addr>] - use sci to talk to an 'hc11 in
;* boot mode.  downloads 256 bytes starting at addr.
;* default addr = 0x2000.
;************

;*get arguments
;*if no args, default 0x2000
boot:	jsr	wskip
	cmpa	#0x0d
	bne	bot1		; jump if arguments
	ldy	#0x2000
	bra	bot2		; go - use default address

;*else get arguments
bot1:	jsr	buffarg
	tst	*count
	beq	boterr		; jump if no address
	jsr	wskip
	ldy	*shftreg	; start address
	cmpa	#0xd
	beq	bot2		; go - use arguments
boterr:	ldx	#msg9		; "bad argument"
	jsr	outstrg
	rts

;*boot routine
bot2:	ldab	#0xff		; control character (0xff -> download)
	jsr	btsub		; set up sci and send control char

;*download 256 byte block
	clrb			; counter
blop:	ldaa	0,y
	staa	jscdat,x	; write to transmitter
	iny
	brclr jscsr,x ,#0x80, .	; wait for tdre
	decb
	bne	blop
	rts

;************************************************
;*subroutine
;*	btsub	- sets up sci and outputs control character
;* on entry, b = control character
;* on exit,  x = 0x1000
;*		a = 0x0c
;***************************

btsub	= .
	ldx	#0x1000		; to use indexed addressing
	ldaa	#0x02
	staa	jportd,x	; drive transmitter line
	staa	jddrd,x		; high
	clr	jsccr2,x	; turn off xmtr and rcvr
	ldaa	#0x22		; baud = /16
	staa	jbaud,x
	ldaa	#0x0c		; turn on xmtr & rcvr
	staa	jsccr2,x
	stab	jscdat,x
	brclr jscsr,x ,#0x80, .	; wait for tdre
	rts

;******************
;*
;*	evbtest - this routine makes it a little easier
;*	on us to test this board.
;*
;******************

evbtest:
	ldaa	#0xff

	staa	0x1000		; write ones to port a

	clr	*autolf		; turn off auto lf
	jsr	hostco		; connect host
	jsr	hostinit	; initialize host

	ldaa	#0x7f
	jsr	hostout		; send delete to altos
	ldaa	#0x0d
	jsr	hostout		; send <cr>
	inc	*autolf		; turn on auto lf
	ldx	#inbuff+5	; point at load message
	stx	*ptr0		; set pointer for load command
	ldy	#msgevb		; point at cat line
loop:	ldaa	0,y		; loop to xfer command line
	cmpa	#04		; into buffalo line buffer
	beq	done		; quit on 0x04
	staa	0,x
	inx			; next character
	iny
	bra	loop
done:	clr	*tmp2		; set load vs. verify
	jsr	load1b		; jmp into middle of load
	lds	#stack		; reset stack
	jmp	0xc0b3		; jump to downloaded code

msgevb:	.ascii	/cat evbtest.out/
	.byte	0x0d
	.byte	0x04

	.org	rombs+0x1fa0
;*** jump table ***
.upcase:jmp	upcase
.wchek:	jmp	wchek
.dchek:	jmp	dchek
.init:	jmp	init
.input:	jmp	input
.output:jmp	output
.outlhl:jmp	outlhlf
.outrhl:jmp	outrhlf
.outa:	jmp	outa
.out1by:jmp	out1byt
.out1bs:jmp	out1bsp
.out2bs:jmp	out2bsp
.outcrl:jmp	outcrlf
.outstr:jmp	outstrg
.outst0:jmp	outstrg0
.inchar:jmp	inchar
.vecint:jmp	vecinit

	.org	rombs+0x1fd6
;*** vectors ***
vsci:	.word	jsci
vspi:	.word	jspi
vpaie:	.word	jpaie
vpao:	.word	jpao
vtof:	.word	jtof
vtoc5:	.word	jtoc5
vtoc4:	.word	jtoc4
vtoc3:	.word	jtoc3
vtoc2:	.word	jtoc2
vtoc1:	.word	jtoc1
vtic3:	.word	jtic3
vtic2:	.word	jtic2
vtic1:	.word	jtic1
vrti:	.word	jrti
virq:	.word	jirq
vxirq:	.word	jxirq
vswi:	.word	jswi
villop:	.word	jillop
vcop:	.word	jcop
vclm:	.word	jclm
vrst:	.word	buffalo

