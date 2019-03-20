	.title	Assembler Equate Testing
	.sbttl	equtst.asm

	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	; Assemble and Link as follows:
	;
	;	ascheck -loxff equtst
	;	aslink -mx equtst
	;
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	; This .asm source file attempts to test the assemblers for
	; correct variable/symbol processing by the equate directives.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	;	The General Equate Directives:
	;
	;	var	=	<arg>	a general equate which
	;	var	.equ	<arg>	does not change the variable/
	;	.equ	var,	<arg>	symbol type declaration.
	;
	;	NOTES:
	;		If var is a local variable then its definition
	;		is not output to the .rel file.
	;
	;		If var is a global variable then its definition
	;		is output to the .rel file.
	;
	;		If var has not been declared global or local
	;		then the assembler '-a' option will promote
	;		the variable/symbol to global and output its
	;		value to the .rel file.
	;
	;		If a referenced var is not defined then
	;		the assembler '-g' option will promote
	;		the variable/symbol to global and output its
	;		value to the .rel file.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	;	The Global Equate Directives:
	;
	;	var 	==	<arg>	an equate which defines the
	;	var	.gblequ	<arg>	variable/symbol as global
	;       .gblequ	var,	<arg>
	;
	;	NOTES:
	;		A global is always output to the .rel file.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	;	The Local Equate Directives:
	;
	;	var 	=:	<arg>	an equate which defines the
	;	var	.lclequ	<arg>	variable/symbol as local
	;       .lclequ	var,	<arg>
	;
	;	NOTES:
	;		A local is never output to the .rel file.
	;		The assembler option '-a' does not apply
	;		to local variables/symbols.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	;	Variable and Symbol NOTES:
	;
	;	In the ASxxxx assemblers the variables and
	;	symbols are equivalent. Examples:
	;
	;		var = .			; The variable var
	;					; is equivalent to the
	;	sym:				; symbol sym.
	;
	;		gvar == .		; The global variable gvar
	;					; is equivalent to the
	;	gsym::				; global symbol gsym.
	;
	;
	;	Variable/Symbol types can be changed using the .local or .globl
	;	assembler directives:
	;
	;	.local	var	; The variable is set Local.
	;       .local	sym	; The symbol is set Local.
	;
	;	.globl	var	; The variable is set Global.
	;	.globl	sym	; The symbol is set Global.
	;
	;	Variables/Symbols that are specified as local/global using
	;	the assembler directives are not flagged as undefined if
	;	they are not used in the current assembly.  However even
	;	if a global variable is unused it will be exported to the
	;	.rel file as a global reference.  The linker will report
	;	the undefined global variable as an error if no other
	;	linked file defines this variable.  To suppress this link
	;	error remove the unused global specification from the source
	;	file or if the global is specified in a header definition
	;	file add the following to the effected source file:
	;
	;	.ifndef	var
	;	.local	var
	;	.endif
	;
	;	The conditional checks that the variable/symbol has not been
	;	used in an equate or as a label and makes the reference local
	;	suppressing its output to the .rel file.
	;
	;	The last type specification in the source assembly determines
	;	the variable/symbol type and whether the assembler outputs
	;	the variable/symbol to the .rel file.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	;	Variable Arguments:
	;
	;	The value of a variable is restricted to a constant
	;	or any location within the local assembly plus/minus
	;	a constant.  External global variables/symbols are
	;	not allowed and will report an 'r' error (relocation)
	;	during assembly.
	;
	;	You might be tempted to define a variable like
	;
	;	addr = xdata + 4
	;	.word	addr
	;
	;	where xdata is an external data address and use this
	;	variable as an argument in an instruction or allocation
	;	directive.
	;
	;	The value of addr will be an undefine external variable + 4
	;	(reports an 'r' error) and the allocation directive will have
	;	a word value of 4.  This is not the desired result.
	;
	;	You must write the allocation as
	;
	;	.word	xdata + 4
	;
	;	or use a declaration similar to the following:
	;
	;	.define	xaddr,	"xdata + 4"
	;
	;	and use this definition in your assembly file.
	;
	;	.word	xaddr
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;

	.page
	.sbttl	Global Export Suppression

	;**** From an external file. ****
	.globl	gblvar
	.globl	gblsym
	;****

	.ifndef	gblvar		; suppress export of gblvar if unused
	.local	gblvar
	.endif

glbsym:				; gblsym is used.

	.ifndef	gblsym		; suppress export of gblsym if unused
	.local	gblsym
	.endif

	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;

	.page
	.sbttl	Variable Usage Errors

	.local	lval		; A  declared Local variable
;	.globl	gval		; An undeclared Global variable
	.globl	xgval		; A  declared External Global variable

	.word	lval		;u 00 00	undefined error
	.word	gval		;u 00 00	undefined error
	.word	xgval		; s00r00	-->> (.rel)  xgval Ref0000

	ilval = lval + 2	;u		undefined error
	igval = gval + 4	;u		undefined error
	ixval = xgval + 6	;r		relocation error


	.page
	.sbttl	Variable Redeclaration

	.local	alval		; A  declared Local variable
;	.globl	agval		; An undeclared global variable
	.globl	axgval		; A  declared External Global variable

	alval == 1		; ==, Global	-->> (.rel)  alval Def0001
	agval =: 2		; =:, Local
	axgval =: 3		; =:, Local


	blval =: 4		; =:, Local
	bgval == 5		; ==, Global
	bxgval == 6		; ==, Global

	.globl	blval		;     Global	-->> (.rel)  blval Def0004
	.local	bgval		;     Local
	.local	bxgval		;     Local


	.local	clval		; A  declared Local variable
;	.globl	cgval		; An undeclared global variable
	.globl	cxgval		; A  declared External Global variable

	clval  .gblequ	1	;     Global	-->> (.rel)  clval Def0001
	cgval  .lclequ	2	;     Local
	cxgval .lclequ	3	;     Local


	.lclequ	dlval, 4	;     Local
	.gblequ	dgval, 5	;     Global
	.gblequ	dxgval,	6	;     Global

	.globl	dlval		;     Global	-->> (.rel)  dlval Def0004
	.local	dgval		;     Local
	.local	dxgval		;     Local


	.page
	.sbttl	Symbol Definitions

	; 'm'	Multiple definition error
	; 'p'	Phase error (address changeing for same symbol)

syma:				;m
syma:				;m

symb:	.blkb	4		;mp

symb:	.blkb	4		;mp

1$:	.blkb	4		;mp

1$:	.blkb	4		;mp

2$:				;m
2$:	.blkb	4		;m

	symc = .		;

	.blkb	4
symc:	.blkb	4		;p

	symd = . + 4		;

	.blkb	4
symd:	.blkb	4		;


	.page
	.sbttl	Program Counter Variable

	.local	elval		; A  declared Local variable
;	.globl	egval		; An undeclared global variable
	.globl	exgval		; A  declared External Global variable

	; Only '.' +/- a constant is allowed
	; '.' with an undefined or external variable is NOT allowed
	.word	.		;  s__r__
	.word	. + elval	;u s__r__	undefined error
	.word	. + egval	;u s__r__	undefined error
	.word	. + exgval	;r s__r__	relocation error

1$:	.blkb	4
	; '.' and '1$' are in the same area, their difference is a constant
	.word	. - 1$		;   00 04
	; '.' +/- a constant is always allowed
	.word	. + 4		;  s__r__
	; A symbol in the local assembly +/- a constant is always allowed
	.word	1$ + 4		;  s__r_
	; '.' and '1$' are in the same area, their difference is a constant
	.word	1$ - .		;   FF F6
	; Only '.' +/- a constant is allowed
	.word	4 - .		;r  __ __	relocation error
	; Only a symbol in the local assembly +/- a constant is allowed
	.word	4 - 1$		;r  __ __	relocation error


	dotval == . + 4		;		-->> (.rel) dotval Def____

syme::				;		-->> (.rel) syme Def____

	. = 4			;.		program counter error
	. = . + 4		;


	.page
	.sbttl	Assembly Options

	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	; When assembled and linked as follows:
	;
	;	ascheck -gloxff equtst
	;	aslink -mx equtst
	;
	;	All non local undefined variables (symbols) will be
	;	flagged as global and referenced in the .rel file.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;
	; When assembled and linked as follows:
	;
	;	ascheck -gloaxff equtst
	;	aslink -mx equtst
	;
	;	(1) All non local undefined variables (symbols) will be
	;	    flagged as global and referenced in the .rel file.
	;
	;	(2) All non local variables and symbols will be flagged
	;	    as global and defined in the .rel file.
	;
	;*****-----*****-----*****-----*****-----*****-----*****-----
	;

	.end

