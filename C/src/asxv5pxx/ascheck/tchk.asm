	.title	ASCHECK Test File

	;
	;  The ASCHECK assembler is basic ASxxxx assembler template.
	;
	;  All ASxxxx assembler directives are available for testing.
	;
	;  The .opcode directive allows testing of the -c option.
	;



	.area	ascheck	(rel,con)


	.opcode	0	; 00
	.opcode 1	; 01
	.opcode 2	; 02
	.opcode 3	; 03
	.opcode 4	; 04
	.opcode 5	; 05
	.opcode 6	; 06
	.opcode 7	; 07
	.opcode 8	; 08
	.opcode 9	; 09
	.opcode 10	; 0A
	.opcode 11	; 0B
	.opcode 12	; 0C
	.opcode 13	; 0D
	.opcode 14	; 0E
	.opcode 15	; 0F
	.opcode 16	; 10


	.byte	varL
	.byte	varG

	var2	==	2
	var4	=:	4

	.local	varL	;r
	.local	var1	;u
	.local	var2

	.globl	varG
	.globl	var3	;u
	.globl	var4

