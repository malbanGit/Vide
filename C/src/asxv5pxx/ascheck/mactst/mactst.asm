	.title	Macro Processor Tests
	.nlist	(md)
	.list	(me)

	;	The Macro Processor directives are:
	;
	;	.macro	arg(,arg ...)		Create a Macro Definition
	;	.endm				End of Macro Definition
	;
	;	.mexit				Unconditional GoTo .endm
	;
	;	.irp	arg(,arg ...)		Indefinite Repeat Block
	;	.irpc	acbdefg			Indefinite Repeat on Characters
	;	.rept	arg			Repeat Code Block arg Times
	;
	;	.mdelete  arg(,arg ...)		Delete Macro Definitions
	;
	;	.nchr	arg			Number of Characters in String
	;	.narg	sym			Return Number of args in .macro call
	;	.ntyp	typ,symbol		Return Symbol Type - (ABS = 0, REL = 1)
	;	.nval	val,symbol		Return Value of Symbol (As Absolute Value)
	;

	.page
	.sbttl	Macro Creation

	; Macro definition with the
	; name 'seta' and two arguments.
	;
	.macro	seta	A,B	; Define macro seta
	  .byte	A,B
	.endm

	seta	0x01, 'j

	; Macro definition with the
	; name 'setb' and a regular
	; argument and a dumby argument.
	;
	.macro	setb	A,?B	; Define macro setb
B:	  .byte	A
	  .word	B
	.endm

	setb	0x02, K		; Use label K

	setb	0x03		; Create a local symbol

	.page
	; Macro definition with the
	; name 'setc' and two regular
	; arguments with concatenation.
	;
	.macro setc	A,B	; Define macro setc
A'B:	  .byte	0x04
	  .word	A'B
	.endm

	setc	J, K

	; Macro definition with the
	; name 'setd' and three regular
	; arguments with concatenation.
	;
	.macro setd	A,B,C	; Define macro setd
A'B:	  .byte	0x05
	  .word	A'B
A'C:	  .byte	0x06
	  .word	A'C
B'C:	  .byte	0x07
	  .word	B'C
A''B''C:  .byte	0x08
	  .word	A''B''C
	.endm

	setd	X, Y, Z


	.page
	; Macro definition with the
	; name 'sete' and two regular
	; arguments.  The second
	; argument is converted to
	; a numerical value.
	.macro	sete	A,B	; Define macro sete
	 .byte	A,B
	 A = A + 1
	.endm

	qxd = 0
	sete	qxd, \(qxd+1)
	sete	qxd, \(qxd+2)
	sete	qxd, \(qxd+3)


	.page
	; Macro definition with
	; conditional exits.
	.macro	cond	A,B,C	; Define macro cond
	.if	nb,^!A!
	  .if	nb,^!B!
	    .if	nb,^!C!
	      .mexit	; C
	    .endif
	    .mexit	; B
	  .endif
	  .mexit	; A
	.endif
	.endm

	cond

	cond	1

	cond	1,2

	cond	1,2,3


	.page
	; Macro definition with
	; conditional exits.
	.macro	.cond	I,J,K	; Define macro .cond
	.if	eq,I
	.ift
	  .byte	K
	  .iif	ne,J	.mexit
	.iff
	  .byte	K+1
	  .iif	ne,J	.mexit
	.iftf
	  .byte	K+2
	.endif
	.endm

	A = 0
	B = 0
	C = 3
	.cond	A,B,C

	A = 0
	B = 2
	C = 3
	.cond	A,B,C

	A = 1
	B = 0
	C = 3
	.cond	A,B,C

	A = 1
	B = 2
	C = 3
	.cond	A,B,C


	.page
	; Macro Definition with Strings,
	; character count, argument count,
	; variable type, and variable value.
	.macro	insert	A,B,C	; Define macro insert
	.narg	...cnt
	.word	...cnt
	.if	ne,...cnt
	  .ntyp	...typ,A
	  .nval	...val,A
	  .word	...typ,...val
	.endif
	.irp	...arg	^!B!,^!C!
	 .if	nb,^!...arg!
	  .nchr		...cnt,...arg
	  .word		...cnt
	  .asciz	...arg
	 .endif
	.endm
	.endm

	A = 1
	B = 2
	C = 3

	insert

	insert	A

	insert	A,

	insert	B,"Hello"

	insert	B,"Hello",

	insert	C,"Hello",^!"Hello World"!


	.page
	.sbttl	Repeat Macro
	; Repeat Macro Definition.

	...cnt = 0
	.rept	0d5
	 .byte	...cnt
	 ...cnt = ...cnt + 1
	.endm


	...cnt = 0
	.rept	0d10
	 .byte	...cnt
	 ...cnt = ...cnt + 1
	 .iif	eq,...cnt - 5	.mexit
	.endm


	.page
	.sbttl	Indefinite Repeat Macro

	...val = 0d12
	.irp	sym	A,B,\...val
	 .globl	val'sym
	 .word	val'sym
	.endm


	.irp	sym	^!.word	0x1234!,	^!.byte	0xFF	; End of .irp!
	 sym
	.endm


	.page
	.sbttl	Indefinite Repeat on Character

	.irpc	sym	0123456789abcdefg
	 .if	ge,''sym - '0
	  .if	le,''sym - '9
	   .byte	''sym,''sym - '0
	  .else
	   .asciz	"'sym"
	   .iif	t	.asciz	"'sym"
	  .endif
	 .endif
	.endm


	.page
	.sbttl	Macro Definitions and User Labels

	.macro	LESS	I,J	; Define macro LESS
	  .iif	lt,(I - J)	.byte	I
	  .iif	gt,(I - J)	.byte	J
	  .iif	eq,(I - J)	.byte	0
	.endm

	sym1	=	1
	sym2	=	2

LESS:	.opcode	2		;LESS is defined as a label
	  ;
	  ;
	  ;
	.word	LESS		;LESS is considered to be a label
	  ;
	  ;
	  ;
	LESS	sym1,sym2	;LESS is a macro call


	.page
	.sbttl	Immediate Conditional Macro Execution

	.if	ne,0
	  .byte	0xE0
	  .iif    f	LESS	sym1,sym2
	  .byte 0xE1
	  .iif	  t	LESS	sym2,sym1
	  .byte	0xE2
	  .iif    tf	LESS	sym1,sym1
	  .byte	0xE3
	.endif

	.if	eq,0
	  .byte	0xF0
	  .iif	  f	LESS	sym1,sym2
	  .byte	0xF1
	  .iif    t	LESS	sym2,sym1
	  .byte 0xF2
	  .iif    tf	LESS	sym2,sym2
	  .byte	0xF3
	.endif


