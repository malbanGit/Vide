	.page
	.sbttl	Macro Processor Tests

	.list	(md)
	.list	(me)

	.radix	X

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
	  .byte	A,B		; 01 6A
	.endm

	.org	0
	seta	0x01, 'j

	.mdelete	seta


	; Macro definition with the
	; name 'setb' and a regular
	; argument and a dumby argument.
	;
	.macro	setb	A,?B	; Define macro setb
B:	  .byte	A		; 02
	  .word	B		;s00r00
	.endm

	.org	0
	setb	0x02, K		; Use label K

	.mdelete	setb


	.macro	setb	A,?B	; Define macro setb
B:	  .byte	A		; 03
	  .word	B		;s00r03
	.endm

	setb	0x03		; Create a local symbol

	.mdelete	setb


	.page
	; Macro definition with the
	; name 'setc' and two regular
	; arguments with concatenation.
	;
	.macro setc	A,B	; Define macro setc
A'B:	  .byte	0x04		; 04
	  .word	A'B		;s00r00
	.endm

	.org	0
	setc	J, K

	.mdelete	.setc


	; Macro definition with the
	; name 'setd' and three regular
	; arguments with concatenation.
	;
	.macro setd	A,B,C	; Define macro setd
A'B:	  .byte	0x05		; 05
	  .word	A'B		;s00r00
A'C:	  .byte	0x06		; 06
	  .word	A'C		;s00r03
B'C:	  .byte	0x07		; 07
	  .word	B'C		;s00r06
A''B''C:  .byte	0x08		; 08
	  .word	A''B''C		;s00r09
	.endm

	.org	0
	setd	X, Y, Z

	.mdelete	.setd


	.page
	; Macro definition with the
	; name 'sete' and two regular
	; arguments.  The second
	; argument is converted to
	; a numerical value.
	.macro	sete	A,B	; Define macro sete
	 ...A = A
	 ...B = B
	 .byte	A,B
	 A = A + 1
	.endm

	qxd = 0
	sete	qxd, \(qxd+1)
	.iif	ne,...A-0	.error	1	; ...A != 0
	.iif	ne,...B-1	.error	1	; ...B != 1
	sete	qxd, \(qxd+2)
	.iif	ne,...A-1	.error	1	; ...A != 1
	.iif	ne,...B-3	.error	1	; ...B != 3
	sete	qxd, \(qxd+3)
	.iif	ne,...A-2	.error	1	; ...A != 2
	.iif	ne,...B-5	.error	1	; ...B != 5

	.mdelete	.sete


	.page
	; Macro definition with
	; conditional exits.
	.macro	cond	A,B,C	; Define macro cond
	...A = 0
	.if	nb,^!A!
	  .if	nb,^!B!
	    .if	nb,^!C!
	      ...A = 3
	      .mexit	; C
	    .endif
	    ...A = 2
	    .mexit	; B
	  .endif
	  ...A = 1
	  .mexit	; A
	.endif
	.endm

	cond
	.iif	ne,...A-0	.error	1	; ...A != 0
	cond	1
	.iif	ne,...A-1	.error	1	; ...A != 1
	cond	1,2
	.iif	ne,...A-2	.error	1	; ...A != 2
	cond	1,2,3
	.iif	ne,...A-3	.error	1	; ...A != 3

	.mdelete	cond


	.page
	.sbttl	Repeat Macro
	; Repeat Macro Definition.

	.macro	RMD	J,K
	 .byte	...cnt	J'K
	.endm

	...cnt = 0
	.rept	0d5
	 RMD	^!; 0!,\...cnt
	 ...cnt = ...cnt + 1
	.endm
	.iif	ne,...cnt - 5	.error	1	; ...cnt != 5


	...cnt = 0
	.rept	0d10
	 RMD	^!; 0!,\...cnt
	 ...cnt = ...cnt + 1
	 .iif	eq,...cnt - 5	.mexit
	 .iif	gt,...cnt - 5	.error	1	; ...cnt >  5
	.endm
	.iif	ne,...cnt - 5	.error	1	; ...cnt != 5

	.mdelete	RMD


	.page
	.sbttl	Indefinite Repeat Macro

	...val = 0d12
	.irp	sym	A,B,\...val
	 .globl	val'sym
	 .word	val'sym		;s00r00
	.endm


	.irp	sym	^!.word	0x1234		; 12 34!,	^!.byte	0xFF		; FF!
	 sym
	.endm


	.page
	.sbttl	Indefinite Repeat on Character
	;
	; Note that these macros are used to create
	; comments.  The comment delimiter ';' always
	; terminates the macro substitution scan when
	; found in a macro call.
	;(even if the ';' is within a delimited string !!!)
	;
	; The ';' character is thus placed in the last
	; argument of the macro call.
	;

	.macro	irpcm1	I	J,K,L,M
	 .byte	''I,''I - '0	M'J'K'L
	.endm

	.macro	irpcm2	I	J,K
	 .asciz	"'I"			K'J' 00
	.endm

	.irpc	sym	0123456789abcdef
	 ...sym = ''sym
	 .if	ge,''sym - '0
	  .if	le,''sym - '9
	   irpcm1	sym	\''sym, ^! 0!, \(''sym-'0), ^!; !
	  .else
	   irpcm2	sym	\''sym, ^!; !
	  .endif
	 .endif
	.endm

	.mdelete	irpcm1, irpcm2


	.page
	.sbttl	Macro Definitions and User Labels

	.macro	DUL	A	B,C
	 .byte	A	C'B
	.endm

	.macro	LESS	I,J	; Define macro LESS
	  .iif	lt,(I - J)	DUL	I	\I, ^!; 0!
	  .iif	gt,(I - J)	DUL	J	\J, ^!; 0!
	  .iif	eq,(I - J)	DUL	0	\0, ^!; 0!
	.endm

	sym1	=	1
	sym2	=	2

	.org	0
				;LESS is defined as a label
LESS:	.byte	2	        ; 02
	  ;
	  ;
	  ;			;LESS is considered to be a label
	.word	LESS		;s00r00
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

	.mdelete	DUL, LESS


