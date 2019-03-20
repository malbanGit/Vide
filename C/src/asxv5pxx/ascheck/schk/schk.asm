	.title	AScheck Tests

	.sbttl	String Substitution Checks

	.area	SCHK


	; These definitions will cause a 'recursion runaway'

	.define	AA,	"A AA A AA"
	.define	A,	"AA A AA A"


begin:	.asciz	"A"



